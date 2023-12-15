//
//  FitnessModel.swift
//  MonsterFitness
//
//  Created by loaner on 12/8/23.
//

let SERVER_URL = "http://10.8.157.40:8000"

import UIKit
import CoreMotion

class FitnessModel: NSObject, URLSessionDelegate {
    static let myFitness = FitnessModel()
    // MARK: =====class variables=====
    let pedometer = CMPedometer()
    
    let today = Calendar.current.startOfDay(for: Date())
    
    // using the calendar to determine the time at the start of the day today, as well as the past 6 days for a whole week
    let pastWeek:[Date] = [
        Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: Date()))!,
        Calendar.current.date(byAdding: .day, value: -2, to: Calendar.current.startOfDay(for: Date()))!,
        Calendar.current.date(byAdding: .day, value: -3, to: Calendar.current.startOfDay(for: Date()))!,
        Calendar.current.date(byAdding: .day, value: -4, to: Calendar.current.startOfDay(for: Date()))!,
        Calendar.current.date(byAdding: .day, value: -5, to: Calendar.current.startOfDay(for: Date()))!,
        Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!,
        Calendar.current.date(byAdding: .day, value: -7, to: Calendar.current.startOfDay(for: Date()))!
    ]
    
    // MARK: Class Properties with Observers
    
//    var calibrationStage:CalibrationStage = .notCalibrating {
//        didSet{
//            switch calibrationStage {
//            case .up:
//                self.isCalibrating = true
//                DispatchQueue.main.async{
//                    self.setAsCalibrating(self.upArrow)
//                    self.setAsNormal(self.rightArrow)
//                    self.setAsNormal(self.leftArrow)
//                    self.setAsNormal(self.downArrow)
//                }
//                break
//            case .left:
//                self.isCalibrating = true
//                DispatchQueue.main.async{
//                    self.setAsNormal(self.upArrow)
//                    self.setAsNormal(self.rightArrow)
//                    self.setAsCalibrating(self.leftArrow)
//                    self.setAsNormal(self.downArrow)
//                }
//                break
//            case .down:
//                self.isCalibrating = true
//                DispatchQueue.main.async{
//                    self.setAsNormal(self.upArrow)
//                    self.setAsNormal(self.rightArrow)
//                    self.setAsNormal(self.leftArrow)
//                    self.setAsCalibrating(self.downArrow)
//                }
//                break
//
//            case .right:
//                self.isCalibrating = true
//                DispatchQueue.main.async{
//                    self.setAsNormal(self.upArrow)
//                    self.setAsCalibrating(self.rightArrow)
//                    self.setAsNormal(self.leftArrow)
//                    self.setAsNormal(self.downArrow)
//                }
//                break
//            case .notCalibrating:
//                self.isCalibrating = false
//                DispatchQueue.main.async{
//                    self.setAsNormal(self.upArrow)
//                    self.setAsNormal(self.rightArrow)
//                    self.setAsNormal(self.leftArrow)
//                    self.setAsNormal(self.downArrow)
//                }
//                break
//            }
//        }
//    }
    
    // variable to hold the mount of steps taken over a week, as well as the current steps taken today
    var weekSteps:[Float] = []
    var todaySteps: Float = 0.0
    
    var weekFlights:[Float] = []
    var todayFlights:Float = 0.0
    
    var weekDistances:[Float] = []
    var todayDistance:Float = 0.0
    
    // the default goal the user is trying to achieve as well as the default stretch goal
    let target = 10000
    let stretchTarget = 11000
    
    //url sessions
    lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.ephemeral
        
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 8.0
        sessionConfig.httpMaximumConnectionsPerHost = 1
        
        return URLSession(configuration: sessionConfig,
                          delegate: self,
                          delegateQueue:self.operationQueue)
    }()
    
    // custom queues
    let operationQueue = OperationQueue()
    let motionOperationQueue = OperationQueue()
    let calibrationOperationQueue = OperationQueue()
    
    var dsid:Int = 0 {
        didSet{
            DispatchQueue.main.async{
                // update label when set
                //self.dsidLabel.layer.add(self.animation, forKey: nil)
                //self.dsidLabel.text = "Current DSID: \(self.dsid)"
            }
        }
    }
    
    //MARK: =====Public Functions=====
    // creating a temp array to hold all of the users steps and returning it
    func getStepsData()->[Float] {
        var tempArray:[Float]
        tempArray = weekSteps
        tempArray.insert(todaySteps, at: 0)
        return tempArray
    }
    
    func getDataSetID(){
        // create a GET request for a new DSID from server
        let baseURL = "\(SERVER_URL)/GetNewDatasetId"
        
        let getUrl = URL(string: baseURL)
        let request: URLRequest = URLRequest(url: getUrl!)
        let dataTask : URLSessionDataTask = self.session.dataTask(with: request,
            completionHandler:{(data, response, error) in
                if(error != nil){
                    print("Response:\n%@",response!)
                }
                else{
                    let jsonDictionary = self.convertDataToDictionary(with: data)
                    
                    // This better be an integer
                    if let dsid = jsonDictionary["dsid"]{
                        self.dsid = dsid as! Int
                    }
                }
                
        })
        
        dataTask.resume() // start the task
    }
    
    //MARK: =====Pedometer Methods=====
    func startPedometerMonitoring(){
        if (CMPedometer.isStepCountingAvailable() && CMPedometer.isFloorCountingAvailable() && CMPedometer.isDistanceAvailable()) {
            //start updating the pedometer with the step count starting from today
            pedometer.startUpdates(from: today, withHandler: handlePedometer(_:error:))
            //get the step count from the previous day and store that as yesterday's value
            for i in 0..<pastWeek.count-1 {
                if (i == 0) {
                    pedometer.queryPedometerData(from: pastWeek[0], to: today, withHandler: handleOldPedometerData(_:error:))
                }
                pedometer.queryPedometerData(from: pastWeek[i+1], to: pastWeek[i], withHandler: handleOldPedometerData(_:error:))
            }
        }
    }
    
    func getStepGoal()->Float {
        var totalSteps:Float = 0
        for step in weekSteps {
            totalSteps += step
        }
        totalSteps += todaySteps
        totalSteps/=7
        totalSteps += 100
        return totalSteps
    }
    
    func getStepStretchGoal()->Float {
        var totalSteps:Float = 0
        for step in weekSteps {
            totalSteps += step
        }
        totalSteps += todaySteps
        totalSteps/=7
        totalSteps += 500
        return totalSteps
    }
    
    func getFlightGoal()->Float {
        var totalSteps:Float = 0
        for flight in weekFlights {
            totalSteps += flight
        }
        totalSteps += todayFlights
        totalSteps/=7
        totalSteps += 1
        return totalSteps
    }
    
    func getFlightStretchGoal()->Float {
        var totalSteps:Float = 0
        for flight in weekFlights {
            totalSteps += flight
        }
        totalSteps += todayFlights
        totalSteps/=7
        totalSteps += 5
        return totalSteps
    }
    
    func getDistanceGoal()->Float {
        var totalSteps:Float = 0
        for distance in weekDistances {
            totalSteps += distance
        }
        totalSteps += todayDistance
        totalSteps/=7
        totalSteps += 1
        return totalSteps
    }
    
    func getDistanceStretchGoal()->Float {
        var totalSteps:Float = 0
        for distance in weekDistances {
            totalSteps += distance
        }
        totalSteps += todayDistance
        totalSteps/=7
        totalSteps += 5
        return totalSteps
    }
    
    // steps from today
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?)->(){
        self.todaySteps = pedData!.numberOfSteps.floatValue
        self.todayFlights = pedData!.floorsAscended!.floatValue
        self.todayDistance = pedData!.distance!.floatValue
    }
    
    // appending the past steps from throughout the week to an array
    func handleOldPedometerData(_ pedData:CMPedometerData?, error:Error?)->(){
        self.weekSteps.append(pedData!.numberOfSteps.floatValue)
        self.weekFlights.append(pedData!.floorsAscended!.floatValue)
        self.weekDistances.append(pedData!.distance!.floatValue)
    }
    
    //MARK: =====URL Session Methods=====
    func convertDictionaryToData(with jsonUpload:NSDictionary) -> Data?{
        do { // try to make JSON and deal with errors using do/catch block
            let requestBody = try JSONSerialization.data(withJSONObject: jsonUpload, options:JSONSerialization.WritingOptions.prettyPrinted)
            return requestBody
        } catch {
            print("json error: \(error.localizedDescription)")
            return nil
        }
    }
    func convertDataToDictionary(with data:Data?)->NSDictionary{
        do { // try to parse JSON and deal with errors using do/catch block
            let jsonDictionary: NSDictionary =
                try JSONSerialization.jsonObject(with: data!,
                                              options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            return jsonDictionary
            
        } catch {
            
            if let strData = String(data:data!, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue)){
                            print("printing JSON received as string: "+strData)
            }else{
                print("json error: \(error.localizedDescription)")
            }
            return NSDictionary() // just return empty
        }
    }
    
    //MARK: Comm with Server
//    func sendFeatures(_ array:String, withLabel label: todaySteps){
//        let baseURL = "\(SERVER_URL)/AddDataPoint"
//        let postUrl = URL(string: "\(baseURL)")
//
//        // create a custom HTTP POST request
//        var request = URLRequest(url: postUrl!)
//
//        // data to send in body of post request (send arguments as json)
//        let jsonUpload:NSDictionary = ["feature":array,
//                                       "label":"\(label)",
//                                       "dsid":self.dsid]
//
//
//        let requestBody:Data? = self.convertDictionaryToData(with:jsonUpload)
//
//        request.httpMethod = "POST"
//        request.httpBody = requestBody
//
//        let postTask : URLSessionDataTask = self.session.dataTask(with: request,
//            completionHandler:{(data, response, error) in
//                if(error != nil){
//                    if let res = response{
//                        print("Response:\n",res)
//                    }
//                }
//                else{
//                    let jsonDictionary = self.convertDataToDictionary(with: data)
//
//                    print(jsonDictionary["feature"]!)
//                    print(jsonDictionary["label"]!)
//                }
//
//        })
//
//        postTask.resume() // start the task
//    }
    
//    func getPrediction(_ array:String){
//        let baseURL = "\(SERVER_URL)/PredictOne"
//        let postUrl = URL(string: "\(baseURL)")
//
//        // create a custom HTTP POST request
//        var request = URLRequest(url: postUrl!)
//
//        // data to send in body of post request (send arguments as json)
//        let jsonUpload:NSDictionary = ["feature":array, "dsid":self.dsid]
//
//
//        let requestBody:Data? = self.convertDictionaryToData(with:jsonUpload)
//
//        request.httpMethod = "POST"
//        request.httpBody = requestBody
//
//        let postTask : URLSessionDataTask = self.session.dataTask(with: request,
//                                                                  completionHandler:{
//                        (data, response, error) in
//                        if(error != nil){
//                            if let res = response{
//                                print("Response:\n",res)
//                            }
//                        }
//                        else{ // no error we are aware of
//                            let jsonDictionary = self.convertDataToDictionary(with: data)
//
//                            let labelResponse = jsonDictionary["prediction"]!
//                            print(labelResponse)
//                            self.displayLabelResponse(labelResponse as! Float)
//                        }
//
//        })
//
//        postTask.resume() // start the task
//    }
    
//    func displayLabelResponse(_ response:Float){
//        switch response {
//        case "['goal']":
//            target = goal
//            break
//        case "['down']":
//            blinkLabel(downArrow)
//            break
//        case "['left']":
//            blinkLabel(leftArrow)
//            break
//        case "['right']":
//            blinkLabel(rightArrow)
//            break
//        default:
//            print("Unknown")
//            break
//        }
//    }
}

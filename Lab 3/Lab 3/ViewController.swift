//
//  ViewController.swift
//  Lab 3
//
//  Created by loaner on 10/11/23.
//
// MARK: =====Sources Used=====
// Commotion by Professor Eric Larson https://github.com/SMU-MSLC/Commotion/tree/WithBounceGame
// Logo created by me using "Linearity Curve" for iPad https://apps.apple.com/us/app/linearity-curve-vectornator/id1219074514
// Tutorial on adding shadow to a UIView https://programmingwithswift.com/add-a-shadow-to-a-uiview-with-swift/
// Tutorial on adding a progress bar https://www.youtube.com/watch?v=9ktMuL9wsDI


import UIKit
import CoreMotion

class ViewController: UIViewController, UITextFieldDelegate{
    
    // MARK: =====class variables=====
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motion = CMMotionManager()
    // using the calendar to determine the time at the start of the day today, then getting the past few 
    let today = Calendar.current.startOfDay(for: Date())
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: Date()))!
    // setting up the variable which will hold the users steps for today.
    // This also holds the logic for the progress bar and whether the user has access to the pachinko ball game
    var totalSteps: Float = 0.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                self.currSteps.text = "Today's Steps: \(newtotalSteps)"
                self.setupProgressBar()
            }
        }
    }
    // setting up the variable that will hold the users steps from yesterday
    var oldSteps: Float = 0.0 {
        willSet(newTotalSteps){
            DispatchQueue.main.async{
                self.prevSteps.text = "Yesterday's Steps: \(newTotalSteps)"
                // if yesterday's steps are greater than or equal to the goal the user set, congratulate them
                if self.oldSteps >= Float(UserDefaults.standard.integer(forKey: "goalSteps")) { self.congratsLabel.text = "🔥\nYou're On Fire!" }
                //otherwise, encourage them and tell them to keep trying
                else if self.oldSteps < Float(UserDefaults.standard.integer(forKey: "goalSteps")) { self.congratsLabel.text = "💪\nKeep trying" }
            }
        }
    }
    // this value will hold the difference between the users goal and their steps for today. If the value is
    // positive then the user still has to take more steps, if the value is negative that means they reached
    // their goal and should be congratulated
    var diffSteps: Float = 0.0 {
        willSet(newTotalSteps){
            DispatchQueue.main.async{
                if self.diffSteps >= 0 { self.distanceToGoal.text = "Steps Needed: \(newTotalSteps)" }
                else { self.distanceToGoal.text = "Congrats! Steps over goal: \(-self.diffSteps)" }
            }
        }
    }

    
    
    // MARK: =====UI  Elements=====
    @IBOutlet weak var currSteps: UILabel!
    @IBOutlet weak var currStepsView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var prevSteps: UILabel!
    @IBOutlet weak var stepGoal: UITextField!
    @IBOutlet weak var stepGoalView: UIView!
    @IBOutlet weak var distanceToGoal: UILabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var prevStepsView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pachinkoButton: UIButton!
    
    
    
    // MARK: =====View Lifecycle=====
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
        self.setupView()
        self.totalSteps = 0.0
        self.oldSteps = 0.0
        self.diffSteps = 0.0
        stepGoal.delegate = self
        self.stepGoal.text = String(UserDefaults.standard.integer(forKey: "goalSteps"))
        self.progressBar.setProgress(0.0, animated: false)
        self.progressBar.transform = CGAffineTransformScale(progressBar.transform, 1, 10)
        pachinkoButton.isEnabled = false
    }
    
    
    
    // MARK: =====Activity Methods=====
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // updating from the main queue is ok since the updates are very infrequent
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: self.handleActivity)
        }
    }
    
    // depending on the activity detected, show a different emoji and the confidence level
    func handleActivity(_ activity:CMMotionActivity?)->Void{
        // unwrap the activity
        if let unwrappedActivity = activity {
            // determine what the activity is and display it
            if(unwrappedActivity.walking){
                self.activityLabel.text = "🚶‍♂️ Walking, conf: \(unwrappedActivity.confidence.rawValue)"
            }
            else if(unwrappedActivity.running){
                self.activityLabel.text = "🏃‍♂️ Running, conf: \(unwrappedActivity.confidence.rawValue)"
            }
            else if(unwrappedActivity.stationary){
                self.activityLabel.text = "🧍‍♂️ Stationary, conf: \(unwrappedActivity.confidence.rawValue)"
            }
            else if(unwrappedActivity.cycling){
                self.activityLabel.text = "🚴‍♂️ Cycling, conf: \(unwrappedActivity.confidence.rawValue)"
            }
            else if(unwrappedActivity.automotive){
                self.activityLabel.text = "🚗 Driving, conf: \(unwrappedActivity.confidence.rawValue)"
            }
            else{
                self.activityLabel.text = "🤷‍♂️ Unknown"
            }
        }
    }
    
    
    
    //MARK: =====Pedometer Methods=====
    func startPedometerMonitoring(){
        if CMPedometer.isStepCountingAvailable(){
            //start updating the pedometer with the step count starting from today
            pedometer.startUpdates(from: today, withHandler: handlePedometer(_:error:))
            //get the step count from the previous day and store that as yesterday's value
            pedometer.queryPedometerData(from: yesterday, to: today, withHandler: handleOldPedometerData(_:error:))
        }
    }
    
    // different handlers for the steps from today and the steps from yesterday
    // steps from today (also initalizes the difference in steps between today and the goal)
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?)->(){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
            diffSteps = Float(UserDefaults.standard.integer(forKey: "goalSteps") - Int(totalSteps))
        }
    }
    
    // steps from yesterday
    func handleOldPedometerData(_ pedData:CMPedometerData?, error:Error?)->(){
        if let steps = pedData?.numberOfSteps { self.oldSteps = steps.floatValue }
    }
    
    
    
    // MARK: =====UI Functionality=====
    // perform these functions if the user taps out of the text field
    @IBAction func tapDidClose(_ sender: UITapGestureRecognizer){
        self.manageGoals()
        self.stepGoal.resignFirstResponder()
    }
    
    // perform the same functions if the user presses the button
    @IBAction func enterGoal(_ sender: UIButton){
        self.manageGoals()
        self.stepGoal.resignFirstResponder()
    }
    
    // one function to manage the goal the user enters
    // executed if the user taps out of the text field or if they press a button
    func manageGoals(){
        // storing the value that the user enters into the text field
        if let steps = Int(stepGoal.text ?? "enter goal"){
            UserDefaults.standard.set(steps, forKey: "goalSteps")
        }
        // calculate how far the user is from their goal
        diffSteps = Float(UserDefaults.standard.integer(forKey: "goalSteps") - Int(totalSteps))
        // if the steps form yesterday are more than the goal the user has set, congratulate them
        if self.oldSteps >= Float(UserDefaults.standard.integer(forKey: "goalSteps")) { self.congratsLabel.text = "🔥\nYou're On Fire!" }
        // otherwise, encourage them
        else { self.congratsLabel.text = "💪\nKeep trying" }
        // setup the progress bar to reflect the user's progress
        self.setupProgressBar()
        // get rid of the keyboard
        self.stepGoal.resignFirstResponder()

    }
    
    // adding shadows to each of the UIViews
    func setupView(){
        for obj in [activityView, prevStepsView, distanceView, currStepsView, stepGoalView]{
            obj?.layer.shadowOffset = CGSize(width: 0, height: 5)
            obj?.layer.shadowRadius = 5
            obj?.layer.shadowOpacity = 0.3
        }
    }
    
    // this function updates the progress bar to show the user how close they are to their goal
    func setupProgressBar(){
        // if the user still has more steps to reach their goal, set the progress bar accordingly
        if self.diffSteps >= 0
        {
            let progress: Float = self.totalSteps/Float(UserDefaults.standard.integer(forKey: "goalSteps"))
            self.progressBar.setProgress(progress, animated: false)
            self.progressBar.progressTintColor = UIColor.blue
            self.enablePachinkoButton()
        }
        // if the user has reached their goal, enable pachinko and turn the progress bar green
        else
        {
            self.progressBar.setProgress(1.0, animated: true)
            self.progressBar.progressTintColor = UIColor.green
            self.enablePachinkoButton()
        }
    }
    
    func enablePachinkoButton()
    {
        //if the user did meet their step goal, make the pachinko button available
        if oldSteps > Float(UserDefaults.standard.integer(forKey: "goalSteps"))
        { self.pachinkoButton.isEnabled = true }
        //if the user did not meet their step goal, disable the pachinko button
        else
        { self.pachinkoButton.isEnabled = false }
        CurrencyModel.shared.setCurrency(x: self.oldSteps - Float(UserDefaults.standard.integer(forKey: "goalSteps")))
    }
    
    
    
    // MARK: =====View Closing=====
    override func viewWillDisappear(_ animated: Bool)
    {
        if CMMotionActivityManager.isActivityAvailable() {
            self.activityManager.stopActivityUpdates()
        }
        super.viewWillDisappear(animated)
    }

}


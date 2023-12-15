//
//  FaceDetectionModel.swift
//  Lab4
//
//  Created by loaner on 11/1/23.
//

import UIKit
import MetalKit


class FaceDetectionModel: NSObject {
    
    weak var cameraView:MTKView?
    
    //MARK: Class Properties
    private var filters : [CIFilter]! = nil
    private lazy var videoManager:VisionAnalgesic! = {
        let tmpManager = VisionAnalgesic(view: cameraView!)
        tmpManager.setCameraPosition(position: .front)
        return tmpManager
    }()
    
    private lazy var detector:CIDetector! = {
        let optsDetector = [CIDetectorAccuracy:CIDetectorAccuracyHigh,
                            CIDetectorTracking:false,
                      CIDetectorMinFeatureSize:0.1,
                     CIDetectorMaxFeatureCount:3,
                      CIDetectorNumberOfAngles:11] as [String : Any]
        
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: self.videoManager.getCIContext(),
                                  options: (optsDetector as [String : AnyObject]))
        
        return detector
    }()

    init(view:MTKView){
        super.init()
        
        cameraView = view
        
        self.setupFilters()
        
        self.videoManager.setCameraPosition(position: .front)
        self.videoManager.setProcessingBlock(newProcessBlock: self.processImage)
        
        if !videoManager.isRunning{
            videoManager.start()
        }
    }
    
    //MARK: Setup filters
    private func setupFilters(){
        filters = []
        
        let filterPinch = CIFilter(name:"CITwirlDistortion")!
        filterPinch.setValue(1.0, forKey: "inputAngle")
        filterPinch.setValue(75, forKey: "inputRadius")
        filters.append(filterPinch)
        
        let eyeFilter = CIFilter(name:"CIHoleDistortion")
        eyeFilter?.setValue(25, forKey: "inputRadius")
        filters.append(eyeFilter!)
    }
    
    //MARK: Apply filters
    private func applyFiiltersToFaces(inputImage:CIImage, features:[CIFaceFeature])->CIImage{
        var retImage = inputImage
        var filterCenter = CGPoint()
        var radius = 75
        
        for face in features {
            filterCenter.x = face.bounds.midX
            filterCenter.y = face.bounds.midY
            radius = Int(face.bounds.width/2)
            
            filters[0].setValue(retImage, forKey: kCIInputImageKey)
            filters[0].setValue(CIVector(cgPoint: filterCenter), forKey: "inputCenter")
            filters[0].setValue(radius, forKey: "inputRadius")
                
            retImage = filters[0].outputImage!
        
            filterCenter.x = face.leftEyePosition.x
            filterCenter.y = face.leftEyePosition.y
            radius = 75
            
            filters[1].setValue(retImage, forKey: kCIInputImageKey)
            filters[1].setValue(CIVector(cgPoint: filterCenter), forKey: "inputCenter")
            filters[1].setValue(radius, forKey: "inputRadius")
            
            retImage = filters[1].outputImage!
            
            filterCenter.x = face.rightEyePosition.x
            filterCenter.y = face.rightEyePosition.y
            radius = 75
            
            filters[1].setValue(retImage, forKey: kCIInputImageKey)
            filters[1].setValue(CIVector(cgPoint: filterCenter), forKey: "inputCenter")
            filters[1].setValue(radius, forKey: "inputRadius")
            
            retImage = filters[1].outputImage!
        
        }
        return retImage
    }
    
    private func getFaces(img:CIImage) -> [CIFaceFeature]{
        let optsFace = [CIDetectorImageOrientation:self.videoManager.ciOrientation]
        return self.detector.features(in: img, options: optsFace) as! [CIFaceFeature]
    }
    
    private func processImage(inputImage:CIImage) -> CIImage{
        let faces = getFaces(img: inputImage)
        
        if faces.count == 0 {return inputImage}
        
        return applyFiiltersToFaces(inputImage: inputImage, features: faces)
    }
    
}

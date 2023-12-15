//
//  ViewController.swift
//  Lab4
//
//  Created by loaner on 11/1/23.
//

import UIKit
import MetalKit

class ViewControllerA: UIViewController {

    //MARK: Class Properties
    var videoModel:FaceDetectionModel? = nil
    
    
    
    @IBOutlet weak var cameraView: MTKView!
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        videoModel = FaceDetectionModel(view: self.cameraView)
        
        
    }
}


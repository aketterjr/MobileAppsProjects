//
//  ViewControllerB.swift
//  Lab4
//
//  Created by loaner on 11/1/23.
//

import UIKit
import MetalKit

class ViewControllerB: UIViewController {
    
    var videoManager:VisionAnalgesic! = nil
    var detector:CIDetector! = nil
    let bridge = OpenCVBridge()

    @IBOutlet weak var cameraView: MTKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
}

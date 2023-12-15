//
//  GameViewController.swift
//  Lab 3
//
//  Created by loaner on 10/15/23.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup game scene
        let myScene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        myScene.scaleMode = .resizeFill
        skView.presentScene(myScene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

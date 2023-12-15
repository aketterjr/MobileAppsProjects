//
//  ViewController.swift
//  MonsterFitness
//
//  Created by loaner on 12/8/23.
//
// MARK: =====Sources Used=====
// Info on how to animate icons in swift
// https://medium.com/@nimk/make-imageview-move-infinitely-from-side-to-side-of-screen-swift-8648f8cbcb1c

import UIKit

class IntroViewController: UIViewController {

    //variables to mark where the monsters start scrolling
    var snapJawPos:Float = 0.8
    var clooClooPos:Float = 0.3
    var pyraxPos:Float = -0.2
    
    var stopped:Bool = false

    // MARK: =====UI Properties=====
    @IBOutlet weak var clooClooView: UIImageView!
    @IBOutlet weak var snapJawView: UIImageView!
    @IBOutlet weak var pyraxView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup all of the creatures
        CreatureModel.shared.setUpCreatures()
        
        //set the creatures into their correct position
        snapJawView.frame.origin.x = self.view.frame.width*CGFloat(self.snapJawPos)
        clooClooView.frame.origin.x = self.view.frame.width*CGFloat(self.clooClooPos)
        pyraxView.frame.origin.x = self.view.frame.width*CGFloat(self.pyraxPos)
        
        //start animating
        moveIt(clooClooView, 0.5, self.pyraxPos, 0.7)
        moveIt(snapJawView, 0.5, self.clooClooPos, 0.4)
        moveIt(pyraxView, 0.5, -0.7, 0.7)
    }
    
    //animating the monsters to rotate through on title screen
    func moveIt(_ imageView: UIImageView,_ speed:CGFloat,_ multiple:Float,_ delay:Float) {
        var tmp = multiple
        var tmp1 = delay
        
        let imageSpeed = speed/view.frame.size.width
        
        let averageSpeed = (view.frame.size.width + imageView.frame.origin.x) * imageSpeed
        
        UIView.animate(withDuration: TimeInterval(averageSpeed), delay: TimeInterval(tmp1), options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                imageView.frame.origin.x = self.view.frame.size.width*CGFloat(tmp)
        }, completion: { (_) in
            if (tmp == self.clooClooPos) {
                tmp = self.pyraxPos
            }
            else if (tmp == self.pyraxPos) {
                tmp = -0.7
            }
            else if (tmp == -0.7) {
                tmp = self.snapJawPos
                imageView.frame.origin.x = self.view.frame.size.width
                UIView.animate(withDuration: TimeInterval(averageSpeed), delay: TimeInterval(0), options: [.curveEaseInOut, .beginFromCurrentState], animations: {imageView.frame.origin.x = self.view.frame.size.width*CGFloat(tmp)})
            }
            else if (tmp == self.snapJawPos) {
                tmp = self.clooClooPos
            }
            tmp1 = 0.5
            if (!self.stopped) {
                self.moveIt(imageView, speed, tmp, tmp1)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if (self.stopped) {
            self.stopped = false
            moveIt(clooClooView, 0.5, self.pyraxPos, 0.7)
            moveIt(snapJawView, 0.5, self.clooClooPos, 0.4)
            moveIt(pyraxView, 0.5, -0.7, 0.7)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        self.stopped = true
        snapJawView.frame.origin.x = self.view.frame.width*CGFloat(self.snapJawPos)
        clooClooView.frame.origin.x = self.view.frame.width*CGFloat(self.clooClooPos)
        pyraxView.frame.origin.x = self.view.frame.width*CGFloat(self.pyraxPos)
    }
    
}


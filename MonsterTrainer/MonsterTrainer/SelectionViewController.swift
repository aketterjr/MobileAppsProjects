//
//  SelectionViewController.swift
//  MonsterTrainer
//
//  Created by loaner on 12/10/23.
//

import UIKit

class SelectionViewController: UIViewController {
    
    // MARK: =====UI Properties=====
    @IBOutlet weak var clooCloo: UIImageView!
    @IBOutlet weak var clooClooDisplay: UIImageView!
    @IBOutlet weak var pyraxDisplay: UIImageView!
    @IBOutlet weak var pyrax: UIImageView!
    @IBOutlet weak var snapJaw: UIImageView!
    @IBOutlet weak var snapJawDisplay: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clooCloo.isHidden = true
        clooClooDisplay.isHidden = true
        pyrax.isHidden = true
        pyraxDisplay.isHidden = true
        snapJaw.isHidden = true
        snapJawDisplay.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Mediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        clooClooDisplay.isHidden = true
        clooCloo.isHidden = true
        pyraxDisplay.isHidden = true
        pyrax.isHidden = true
        snapJaw.isHidden = true
        snapJawDisplay.isHidden = true
    }
    
    @IBAction func yellowEggTap(_ sender: Any) {
        yellowEggAnimation(false)
    }
    
    func yellowEggAnimation(_ dismiss: Bool) {
        clooClooDisplay.isHidden = false
        clooCloo.isHidden = false
        snapJawDisplay.isHidden = true
        snapJaw.isHidden = true
        pyraxDisplay.isHidden = true
        pyrax.isHidden = true
        UIView.animate(withDuration: TimeInterval(0.7), delay: 0, animations: {
            self.clooCloo.image = UIImage(named: "ClooClooAction")!
            self.clooCloo.frame.origin.y = self.clooCloo.frame.origin.y - CGFloat(10)
        }, completion: {(_) in
            self.clooCloo.frame.origin.y = self.clooCloo.frame.origin.y + CGFloat(10)
            self.clooCloo.image = UIImage(named: "ClooCloo")!
            if (dismiss) {
                CreatureModel.shared.setStatsMonster("cloocloo")
                self.dismiss(animated: true)
            }
        })
    }
    
    @IBAction func redEggTap(_ sender: Any) {
        redEggAnimation(false)
    }
    
    func redEggAnimation(_ dismiss: Bool) {
        pyraxDisplay.isHidden = false
        pyrax.isHidden = false
        snapJaw.isHidden = true
        snapJawDisplay.isHidden = true
        clooClooDisplay.isHidden = true
        clooCloo.isHidden = true
        UIView.animate(withDuration: TimeInterval(0.7), delay: 0, animations: {
            self.pyrax.image = UIImage(named: "PyraxAction")!
            self.pyrax.frame.origin.y = self.pyrax.frame.origin.y - CGFloat(10)
        }, completion: {(_) in
            self.pyrax.frame.origin.y = self.pyrax.frame.origin.y + CGFloat(10)
            self.pyrax.image = UIImage(named: "Pyrax")!
            if (dismiss) {
                CreatureModel.shared.setStatsMonster("pyrax")
                self.dismiss(animated: true)
            }
        })
    }
    
    @IBAction func blueEggTap(_ sender: Any) {
        blueEggAnimation(false)
    }
    
    func blueEggAnimation(_ dismiss:Bool) {
        snapJawDisplay.isHidden = false
        snapJaw.isHidden = false
        clooClooDisplay.isHidden = true
        clooCloo.isHidden = true
        pyraxDisplay.isHidden = true
        pyrax.isHidden = true
        UIView.animate(withDuration: TimeInterval(0.7), delay: 0, animations: {
            self.snapJaw.image = UIImage(named: "SnapJawAction")!
            self.snapJaw.frame.origin.y = self.snapJaw.frame.origin.y - CGFloat(10)
        }, completion: {(_) in
            self.snapJaw.frame.origin.y = self.snapJaw.frame.origin.y + CGFloat(10)
            self.snapJaw.image = UIImage(named: "SnapJaw")!
            if (dismiss) {
                CreatureModel.shared.setStatsMonster("snapjaw")
                self.dismiss(animated: true)
            }
        })
    }
    
    
    @IBAction func pickStarter(_ sender: UITapGestureRecognizer) {
        CreatureModel.shared.setSelected(true)
        if (sender.view == snapJaw) {
            CreatureModel.shared.setCreatureUnlock(name: "snapjaw", status: true)
            CreatureModel.shared.setCurrentMonster("snapjaw")
            blueEggAnimation(true)
        }
        else if (sender.view == clooCloo) {
            CreatureModel.shared.setCreatureUnlock(name: "cloocloo", status: true)
            CreatureModel.shared.setCurrentMonster("cloocloo")
            yellowEggAnimation(true)
        }
        else if (sender.view == pyrax) {
            CreatureModel.shared.setCreatureUnlock(name: "pyrax", status: true)
            CreatureModel.shared.setCurrentMonster("pyrax")
            redEggAnimation(true)
        }
    }
}

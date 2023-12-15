//
//  CollectionViewController.swift
//  MonsterTrainer
//
//  Created by loaner on 12/12/23.
//

import UIKit

class CollectionViewController: UIViewController {
    
    // MARK: =====UI Properties=====
    @IBOutlet weak var creature11: UIImageView!
    @IBOutlet weak var creature12: UIImageView!
    @IBOutlet weak var creature13: UIImageView!
    @IBOutlet weak var creature21: UIImageView!
    @IBOutlet weak var creature22: UIImageView!
    @IBOutlet weak var creature23: UIImageView!
    
    @IBOutlet weak var lock11: UIImageView!
    @IBOutlet weak var lock12: UIImageView!
    @IBOutlet weak var lock13: UIImageView!
    @IBOutlet weak var lock21: UIImageView!
    @IBOutlet weak var lock22: UIImageView!
    @IBOutlet weak var lock23: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CreatureModel.shared.getUnlocked("cloocloo")) {
            lock11.isHidden = true
        }
        if (CreatureModel.shared.getUnlocked("snapjaw")) {
            lock12.isHidden = true
        }
        if (CreatureModel.shared.getUnlocked("pyrax")) {
            lock13.isHidden = true
        }
    }
    
    
    @IBAction func clooClooTapped(_ sender: Any) {
        CreatureModel.shared.setStatsMonster("cloocloo")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let statsView  = storyBoard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        self.navigationController?.pushViewController(statsView, animated: true)
    }
    
    @IBAction func snapJawTapped(_ sender: Any) {
        CreatureModel.shared.setStatsMonster("snapjaw")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let statsView  = storyBoard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        self.navigationController?.pushViewController(statsView, animated: true)
    }
    
    
    @IBAction func pyraxTapped(_ sender: Any) {
        CreatureModel.shared.setStatsMonster("pyrax")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let statsView  = storyBoard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        self.navigationController?.pushViewController(statsView, animated: true)
    }
}

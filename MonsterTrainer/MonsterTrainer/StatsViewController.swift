//
//  StatsViewController.swift
//  MonsterTrainer
//
//  Created by loaner on 12/10/23.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var statMonsterImage: UIImageView!
    @IBOutlet weak var hpBar: UIProgressView!
    @IBOutlet weak var spAtkBar: UIProgressView!
    @IBOutlet weak var atkBar: UIProgressView!
    @IBOutlet weak var defBar: UIProgressView!
    @IBOutlet weak var speedBar: UIProgressView!
    @IBOutlet weak var creatureName: UILabel!
    @IBOutlet weak var lvlDisplay: UILabel!
    @IBOutlet weak var creatureDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        self.creatureName.text = CreatureModel.shared.getStatsMonsterName()
        self.lvlDisplay.text = "Level: \(CreatureModel.shared.getLvl(CreatureModel.shared.getStatsMonsterName()))"
        statMonsterImage.image = CreatureModel.shared.getSprite(CreatureModel.shared.getStatsMonsterName())
        self.hpBar.transform = CGAffineTransformScale(hpBar.transform, 1, 3)
        self.spAtkBar.transform = CGAffineTransformScale(spAtkBar.transform, 1, 3)
        self.atkBar.transform = CGAffineTransformScale(atkBar.transform, 1, 3)
        self.defBar.transform = CGAffineTransformScale(defBar.transform, 1, 3)
        self.speedBar.transform = CGAffineTransformScale(speedBar.transform, 1, 3)
        
        self.hpBar.progressTintColor = UIColor.red
        self.hpBar.setProgress((CreatureModel.shared.getHP(CreatureModel.shared.getStatsMonsterName())/150), animated: false)
        self.spAtkBar.progressTintColor = UIColor.yellow
        self.spAtkBar.setProgress((CreatureModel.shared.getSpAtk(CreatureModel.shared.getStatsMonsterName())/150), animated: false)
        self.atkBar.progressTintColor = UIColor.systemIndigo
        self.atkBar.setProgress((CreatureModel.shared.getAtk(CreatureModel.shared.getStatsMonsterName())/150), animated: false)
        self.defBar.progressTintColor = UIColor.darkGray
        self.defBar.setProgress((CreatureModel.shared.getDef(CreatureModel.shared.getStatsMonsterName())/150), animated: false)
        self.speedBar.setProgress((CreatureModel.shared.getSpeed(CreatureModel.shared.getStatsMonsterName())/150), animated: false)
        self.speedBar.progressTintColor = UIColor.cyan
        
        setDescription()
    }
    
    func setDescription() {
        if (CreatureModel.shared.getStatsMonsterName() == "cloocloo") {
            self.creatureDescription.text = "ClooCloos are small flightless birds that subsist off a diet of mostly grubs and seeds. They are typically very docile creatures but will attack with their beaks when threatened."
        }
        
        if (CreatureModel.shared.getStatsMonsterName() == "snapjaw") {
            self.creatureDescription.text = "SnapJaws are aquatic apex predators. They lurk murky swamps and ambush their prey when it comes close. Their teeth are sharp and their bite is deadly."
        }
        
        if (CreatureModel.shared.getStatsMonsterName() == "pyrax") {
            self.creatureDescription.text = "Pyraxs are small mammals imbued with a fiery spirit. Not much is known of their behavior besides the fact that they live in groups and are highly territorial. When threatened they will retaliate with fire based attacks."
        }
    }
}

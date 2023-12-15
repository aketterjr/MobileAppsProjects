//
//  BattleViewController.swift
//  MonsterTrainer
//
//  Created by loaner on 12/11/23.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {
    
    var myScene = BattleScene()
    var skView = SKView()

    // MARK: =====UI Elements=====
    @IBOutlet weak var attackOne: UIButton!
    @IBOutlet weak var attackTwo: UIButton!
    @IBOutlet weak var p1HealthBar: UIProgressView!
    @IBOutlet weak var p2HealthBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScene = BattleScene(size: view.bounds.size)
        skView = view as! SKView
        myScene.scaleMode = .resizeFill
        if (CreatureModel.shared.getAttackOne(CreatureModel.shared.getCurrentMonsterName()) == "StabPeck" || CreatureModel.shared.getAttackOne(CreatureModel.shared.getCurrentMonsterName()) == "Bite") {
            attackOne.tintColor = UIColor.red
            attackOne.setTitle(CreatureModel.shared.getAttackOne(CreatureModel.shared.getCurrentMonsterName()), for: .normal)
        }
        else if (CreatureModel.shared.getAttackOne(CreatureModel.shared.getCurrentMonsterName()) == "FireBlast") {
            attackOne.tintColor = UIColor.orange
            attackOne.setTitle(CreatureModel.shared.getAttackOne(CreatureModel.shared.getCurrentMonsterName()), for: .normal)
        }
        attackTwo.setTitle(CreatureModel.shared.getAttackTwo(CreatureModel.shared.getCurrentMonsterName()), for: .normal)
        skView.presentScene(myScene)
        p1HealthBar.setProgress(1, animated: false)
        p1HealthBar.tintColor = UIColor.green
        p2HealthBar.setProgress(1, animated: false)
        p2HealthBar.tintColor = UIColor.green
    }
    
    @IBAction func attackOnePressed(_ sender: Any) {
        navigationItem.hidesBackButton = true
        if (myScene.attack(1)) {
            p1HealthBar.setProgress(myScene.getPlayerHp(0)/CreatureModel.shared.getHP(myScene.player1Name), animated: true)
            p2HealthBar.setProgress(myScene.getPlayerHp(1)/CreatureModel.shared.getHP(myScene.player2Name), animated: true)
        }
        else {
            p1HealthBar.setProgress(myScene.getPlayerHp(0)/CreatureModel.shared.getHP(myScene.player1Name), animated: true)
            p2HealthBar.setProgress(myScene.getPlayerHp(1)/CreatureModel.shared.getHP(myScene.player2Name), animated: true)
            navigationItem.hidesBackButton = false
            attackOne.isEnabled = false
            attackTwo.isEnabled = false
        }
        if (myScene.getPlayerHp(0) <= CreatureModel.shared.getHP(myScene.player1Name)) {
            p1HealthBar.tintColor = UIColor.blue
        }
        if (myScene.getPlayerHp(1) <= CreatureModel.shared.getHP(myScene.player2Name)) {
            p2HealthBar.tintColor = UIColor.blue
        }
    }
    
    @IBAction func attackTwoPressed(_ sender: Any) {
        navigationItem.hidesBackButton = true
        if (myScene.attack(2)) {
            p1HealthBar.setProgress(myScene.getPlayerHp(0)/CreatureModel.shared.getHP(myScene.player1Name), animated: true)
            p2HealthBar.setProgress(myScene.getPlayerHp(1)/CreatureModel.shared.getHP(myScene.player2Name), animated: true)
        }
        else {
            p1HealthBar.setProgress(myScene.getPlayerHp(0)/CreatureModel.shared.getHP(myScene.player1Name), animated: true)
            p2HealthBar.setProgress(myScene.getPlayerHp(1)/CreatureModel.shared.getHP(myScene.player2Name), animated: true)
            navigationItem.hidesBackButton = false
            attackOne.isEnabled = false
            attackTwo.isEnabled = false
        }
        if (myScene.getPlayerHp(0) <= CreatureModel.shared.getHP(myScene.player1Name)) {
            p1HealthBar.tintColor = UIColor.blue
        }
        else {
            p1HealthBar.tintColor = UIColor.green
        }
        if (myScene.getPlayerHp(1) <= CreatureModel.shared.getHP(myScene.player2Name)) {
            p2HealthBar.tintColor = UIColor.blue
        }
        else {
            p1HealthBar.tintColor = UIColor.green
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

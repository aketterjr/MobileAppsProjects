//
//  BattleScene.swift
//  MonsterTrainer
//
//  Created by loaner on 12/11/23.
//

import UIKit
import SpriteKit

class BattleScene: SKScene, SKPhysicsContactDelegate {
    static var attacking:Bool = false
    
    // setting the player icons
    let player1 = SKSpriteNode()
    let player2 = SKSpriteNode()
    
    // setting the different attack icons
    var drillPeck = SKShapeNode()
    var proteinShake = SKShapeNode()
    var bite = SKShapeNode()
    var hydrate = SKShapeNode()
    var fireBlast = SKShapeNode()
    var concentrate = SKShapeNode()
    
    var drillPeck1 = SKShapeNode()
    var proteinShake1 = SKShapeNode()
    var bite1 = SKShapeNode()
    var hydrate1 = SKShapeNode()
    var fireBlast1 = SKShapeNode()
    var concentrate1 = SKShapeNode()
    
    var player1Name:String = "Unknown"
    var player2Name:String = "Unknown"
    
    static var playerHps:[Float] = [0,0]
    static var playerSpAttacks:[Float] = [0,0]
    static var playerAttacks:[Float] = [0,0]
    static var playerDefs:[Float] = [0,0]
    static var playerSpeeds:[Float] = [0,0]
    static var alive:[Bool] = [true, true]
    
    
    
    override func didMove(to view: SKView) {
        addPlayerMonster(0, 1)
        addPlayerMonster(1, 2)
    }
    
    
    
    func addPlayerMonster(_ option: Int,_ playerNum: Int){
        var tmpName:String = "Unknown"
        var player = SKShapeNode()
        if (option == 0) {
            player = SKShapeNode(rectOf: CGSize(width: 250, height: 250))
            player.fillColor = UIColor.white
            player.fillTexture = SKTexture(image: CreatureModel.shared.getCurrentMonsterSprite())
            tmpName = CreatureModel.shared.getCurrentMonsterName()
        }
        // used for picking a cpu
        else {
            player = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
            player.fillColor = UIColor.white
            let tmpRand = Int.random(in: 0...2)
            if (tmpRand == 0) {
                player.fillTexture = SKTexture(image: CreatureModel.shared.creatures["cloocloo"]!.sprite)
                tmpName = "cloocloo"
            }
            else if (tmpRand == 1) {
                player.fillTexture = SKTexture(image: CreatureModel.shared.creatures["snapjaw"]!.sprite)
                tmpName = "snapjaw"
            }
            else if (tmpRand == 2) {
                player.fillTexture = SKTexture(image: CreatureModel.shared.creatures["pyrax"]!.sprite)
                tmpName = "pyrax"
            }
        }
        
        if (playerNum == 1) {
            player1Name = tmpName
            player.position = CGPoint(x: size.width * 0.4, y: size.height * 0.3)
        }
        else if (playerNum == 2) {
            player2Name = tmpName
            player.position = CGPoint(x: size.width * 0.8, y: size.height * 0.8)
        }
        
        self.addChild(player)
        addAttackIcons()
    }
    
    
    
    func addAttackIcons() {
        drillPeck = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        drillPeck.fillColor = UIColor.white
        drillPeck.fillTexture = SKTexture(image: UIImage(named: "DrillPeck")!)
        drillPeck.position = CGPoint(x: size.width * 0.4, y: size.height * 0.5)
        drillPeck.isHidden = true
        self.addChild(drillPeck)
        
        proteinShake = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        proteinShake.fillColor = UIColor.white
        proteinShake.fillTexture = SKTexture(image: UIImage(named: "ProteinShake")!)
        proteinShake.position = CGPoint(x: size.width * 0.4, y: size.height * 0.5)
        proteinShake.isHidden = true
        self.addChild(proteinShake)
        
        bite = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        bite.fillColor = UIColor.white
        bite.fillTexture = SKTexture(image: UIImage(named: "Bite")!)
        bite.position = CGPoint(x: size.width * 0.4, y: size.height * 0.5)
        bite.isHidden = true
        self.addChild(bite)
        
        hydrate = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        hydrate.fillColor = UIColor.white
        hydrate.fillTexture = SKTexture(image: UIImage(named: "Hydrate")!)
        hydrate.position = CGPoint(x: size.width * 0.4, y: size.height * 0.5)
        hydrate.isHidden = true
        self.addChild(hydrate)
        
        fireBlast = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        fireBlast.fillColor = UIColor.white
        fireBlast.fillTexture = SKTexture(image: UIImage(named: "FireBlast")!)
        fireBlast.position = CGPoint(x: size.width * 0.4, y: size.height * 0.5)
        fireBlast.isHidden = true
        self.addChild(fireBlast)
        
        concentrate = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        concentrate.fillColor = UIColor.white
        concentrate.fillTexture = SKTexture(image: UIImage(named: "Concentrate")!)
        concentrate.position = CGPoint(x: size.width * 0.4, y: size.height * 0.5)
        concentrate.isHidden = true
        self.addChild(concentrate)
        
        
        
        drillPeck1 = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        drillPeck1.fillColor = UIColor.white
        drillPeck1.fillTexture = SKTexture(image: UIImage(named: "DrillPeck")!)
        drillPeck1.position = CGPoint(x: size.width * 0.7, y: size.height * 0.6)
        drillPeck1.isHidden = true
        self.addChild(drillPeck1)
        
        proteinShake1 = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        proteinShake1.fillColor = UIColor.white
        proteinShake1.fillTexture = SKTexture(image: UIImage(named: "ProteinShake")!)
        proteinShake1.position = CGPoint(x: size.width * 0.7, y: size.height * 0.6)
        proteinShake1.isHidden = true
        self.addChild(proteinShake1)
        
        bite1 = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        bite1.fillColor = UIColor.white
        bite1.fillTexture = SKTexture(image: UIImage(named: "Bite")!)
        bite1.position = CGPoint(x: size.width * 0.7, y: size.height * 0.6)
        bite1.isHidden = true
        self.addChild(bite1)
        
        hydrate1 = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        hydrate1.fillColor = UIColor.white
        hydrate1.fillTexture = SKTexture(image: UIImage(named: "Hydrate")!)
        hydrate1.position = CGPoint(x: size.width * 0.7, y: size.height * 0.6)
        hydrate1.isHidden = true
        self.addChild(hydrate1)
        
        fireBlast1 = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        fireBlast1.fillColor = UIColor.white
        fireBlast1.fillTexture = SKTexture(image: UIImage(named: "FireBlast")!)
        fireBlast1.position = CGPoint(x: size.width * 0.7, y: size.height * 0.6)
        fireBlast1.isHidden = true
        self.addChild(fireBlast1)
        
        concentrate1 = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        concentrate1.fillColor = UIColor.white
        concentrate1.fillTexture = SKTexture(image: UIImage(named: "Concentrate")!)
        concentrate1.position = CGPoint(x: size.width * 0.7, y: size.height * 0.6)
        concentrate1.isHidden = true
        self.addChild(concentrate1)
    }
    
    
    
    func attack(_ attack: Int)-> Bool{
        let random = Int.random(in: 1...2)
        // on the first loop, get the player hp's
        if (!BattleScene.attacking) {
            BattleScene.playerHps[0] = CreatureModel.shared.getHP(player1Name)
            BattleScene.playerHps[1] = CreatureModel.shared.getHP(player2Name)
            BattleScene.playerSpAttacks[0] = CreatureModel.shared.getSpAtk(player1Name)
            BattleScene.playerSpAttacks[1] = CreatureModel.shared.getSpAtk(player2Name)
            BattleScene.playerAttacks[0] = CreatureModel.shared.getAtk(player1Name)
            BattleScene.playerAttacks[1] = CreatureModel.shared.getAtk(player2Name)
        }
        BattleScene.attacking = true
        let order = getAttackOrder()
        
        // attack 2 moves first
        if (attack == 2) {
            if (player1Name == "pyrax") {
                BattleScene.playerSpAttacks[0] += CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player1Name)]!/2
                animationTwoP1("Concentrate")
            }
            else if (player1Name == "cloocloo"){
                BattleScene.playerAttacks[0] += CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player1Name)]!/2
                animationTwoP1("ProteinShake")
            }
            else if (player1Name == "snapjaw") {
                BattleScene.playerHps[0] += CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player1Name)]!/2
                animationTwoP1("Hydrate")
            }
        }
        if (random == 2) {
            if (player2Name == "pyrax") {
                BattleScene.playerSpAttacks[1] += CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player2Name)]!/2
                animationTwoP2("Concentrate")
            }
            else if (player2Name == "cloocloo"){
                BattleScene.playerAttacks[1] += CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player2Name)]!/2
                animationTwoP2("ProteinShake")
            }
            else if (player2Name == "snapjaw") {
                BattleScene.playerHps[1] += CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player2Name)]!/2
                animationTwoP2("Hydrate")
            }
        }
        
        // attack 1 moves second
        if (order[0] == 1 && attack == 1) {
            if (player1Name == "pyrax") {
                BattleScene.playerHps[1] -= CreatureModel.shared.attacks[CreatureModel.shared.getAttackOne(player1Name)]! * (BattleScene.playerSpAttacks[0]/150)
                animationOneP1("FireBlast")
            }
            else {
                BattleScene.playerHps[1] -= CreatureModel.shared.attacks[CreatureModel.shared.getAttackOne(player1Name)]! * (BattleScene.playerAttacks[0]/150)
                if (player1Name == "cloocloo") {
                    animationOneP1("DrillPeck")
                }
                else {
                    animationOneP1("Bite")
                }
            }
            if (BattleScene.playerHps[1] <= 0) {
                BattleScene.alive[1] = false
                BattleScene.attacking = false
                return BattleScene.attacking
            }
        }
        if (order[0] == 2 && random == 1) {
            if (player2Name == "pyrax") {
                BattleScene.playerHps[0] -= CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player2Name)]! * (BattleScene.playerSpAttacks[1]/150)
                animationOneP2("FireBlast")
            }
            else {
                BattleScene.playerHps[0] -= CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player2Name)]! * (BattleScene.playerAttacks[1]/150)
                if (player2Name == "cloocloo") {
                    animationOneP2("DrillPeck")
                }
                else {
                    animationOneP2("Bite")
                }
            }
            if (BattleScene.playerHps[0] <= 0) {
                BattleScene.alive[0] = false
                BattleScene.attacking = false
                return BattleScene.attacking
            }
        }
        if (order[1] == 1 && attack == 1) {
            if (player1Name == "pyrax") {
                BattleScene.playerHps[1] -= CreatureModel.shared.attacks[CreatureModel.shared.getAttackOne(player1Name)]! * (BattleScene.playerSpAttacks[0]/150)
                animationOneP1("FireBlast")
            }
            else {
                BattleScene.playerHps[1] -= CreatureModel.shared.attacks[CreatureModel.shared.getAttackOne(player1Name)]! * (BattleScene.playerAttacks[0]/150)
                if (player1Name == "cloocloo") {
                    animationOneP1("DrillPeck")
                }
                else {
                    animationOneP1("Bite")
                }
            }
            if (BattleScene.playerHps[1] <= 0) {
                BattleScene.alive[1] = false
                BattleScene.attacking = false
                return BattleScene.attacking
            }
        }
        if (order[1] == 2 && random == 1) {
            if (player2Name == "pyrax") {
                BattleScene.playerHps[0] -= CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player2Name)]! * (BattleScene.playerSpAttacks[1]/150)
                animationOneP2("FireBlast")
            }
            else {
                BattleScene.playerHps[0] -= CreatureModel.shared.attacks[CreatureModel.shared.getAttackTwo(player2Name)]! * (BattleScene.playerAttacks[1]/150)
                if (player2Name == "cloocloo") {
                    animationOneP2("DrillPeck")
                }
                else {
                    animationOneP2("Bite")
                }
            }
            if (BattleScene.playerHps[0] <= 0) {
                BattleScene.alive[0] = false
                BattleScene.attacking = false
                return BattleScene.attacking
            }
        }
        return BattleScene.attacking
    }
    
    
    func animationOneP1(_ attack: String) {
        let dX = 30
        let dY = 50
        let moveAction = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(dY), duration: 0.5)
        if (attack == "DrillPeck") {
            drillPeck.isHidden = false
            drillPeck.run(moveAction, completion: {self.drillPeck.isHidden = true;self.drillPeck.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.5)})
        }
        if (attack == "Bite") {
            bite.isHidden = false
            bite.run(moveAction, completion: {self.bite.isHidden = true;self.bite.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.5)})
        }
        if (attack == "FireBlast") {
            fireBlast.isHidden = false
            fireBlast.run(moveAction, completion: {self.fireBlast.isHidden = true; self.fireBlast.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.5)})        }
    }
    
    
    func animationTwoP1(_ attack: String) {
        let dX = 0
        let dY = 20
        let moveAction = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(dY), duration: 0.5)
        if (attack == "ProteinShake") {
            proteinShake.isHidden = false
            proteinShake.run(moveAction, completion: {self.proteinShake.isHidden = true;self.proteinShake.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.5)})
        }
        if (attack == "Hydrate") {
            hydrate.isHidden = false
            hydrate.run(moveAction, completion: {self.hydrate.isHidden = true;self.hydrate.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.5)})
        }
        if (attack == "Concentrate") {
            concentrate.isHidden = false
            concentrate.run(moveAction, completion: {self.concentrate.isHidden = true;self.concentrate.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.5)})
        }
    }
    
    
    func animationOneP2(_ attack: String) {
        let dX = 10
        let dY = -20
        let moveAction = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(dY), duration: 0.5)
        if (attack == "DrillPeck") {
            drillPeck1.isHidden = false
            drillPeck1.run(moveAction, completion: {self.drillPeck1.isHidden = true; self.drillPeck1.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.6)})
        }
        if (attack == "Bite") {
            bite1.isHidden = false
            bite1.run(moveAction, completion: {self.bite1.isHidden = true; self.bite1.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.6)})
        }
        if (attack == "FireBlast") {
            fireBlast1.isHidden = false
            fireBlast1.run(moveAction, completion: {self.fireBlast1.isHidden = true; self.fireBlast1.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.6)})
        }
    }
    
    
    
    func animationTwoP2(_ attack: String) {
        let dX = 0
        let dY = 10
        let moveAction = SKAction.moveBy(x: CGFloat(dX), y: CGFloat(dY), duration: 0.5)
        if (attack == "ProteinShake") {
            proteinShake1.isHidden = false
            proteinShake1.run(moveAction, completion: {self.proteinShake1.isHidden = true;self.proteinShake1.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.6)})
        }
        if (attack == "Hydrate") {
            hydrate1.isHidden = false
            hydrate1.run(moveAction, completion: {self.hydrate1.isHidden = true;self.hydrate1.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.6)})
        }
        if (attack == "Concentrate") {
            concentrate1.isHidden = false
            concentrate1.run(moveAction, completion: {self.concentrate1.isHidden = true;self.concentrate1.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.6)})
        }
    }
    
    
    func getPlayerHp(_ playerNum: Int)->Float {
        return BattleScene.playerHps[playerNum]
    }
    
    
    
    func getAlive(_ playerNum: Int)->Bool {
        return BattleScene.alive[playerNum]
    }
    
    
    
    func getAttackOrder()-> [Int] {
        var order: [Int] = [0,0]
        let speedOrder: [Int: Float] = [1: CreatureModel.shared.getSpeed(player1Name), 2: CreatureModel.shared.getSpeed(player2Name)]
        
        let sortedSpeed = speedOrder.sorted(by: >)
        for intIndex in 0..<sortedSpeed.count {
            let index = sortedSpeed.index(sortedSpeed.startIndex, offsetBy: intIndex)
            order[intIndex] = Array(speedOrder.keys)[index]
        }
        return order
    }
}

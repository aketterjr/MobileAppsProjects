//
//  CreatureModel.swift
//  MonsterTrainer
//
//  Created by loaner on 12/10/23.
//

import UIKit

class CreatureModel: NSObject {
    // Making a singleton class to keep track of what creatures the player has unlocked and all of their stats
    static let shared = CreatureModel()
    // a variable to let the menu view controller know when the user has selected a starter (to prevent it from showing the starter selection screen again)
    var selected:Bool = false
    // a dictionary that contains all of the creatures to be easily accessed
    var creatures:[String: Creature] = [:]
    
    // a variable to hold the creature the user has selected to be their monster
    var currentMonster:Creature = Creature(hp: 0, spAttack: 0, phAttack: 0, def: 0, speed: 0, lvl: 0, xp: 0, levelXP: 0, sprite: UIImage(named: "Unknown")!, actionSprite: UIImage(named: "Unknown")!, unlocked: false, seen: false, attack1: "", attack2: "")
    var currentMonsterName:String = "Unknown"
    // a variable to hold the creature the user has selected to view their stats
    var statsMonster:Creature = Creature(hp: 0, spAttack: 0, phAttack: 0, def: 0, speed: 0, lvl: 0, xp: 0, levelXP: 0, sprite: UIImage(named: "Unknown")!, actionSprite: UIImage(named: "Unknown")!, unlocked: false, seen: false, attack1: "", attack2: "")
    var statsMonsterName:String = "Unknown"
    var attacks:[String: Float] = ["StabPeck": 30, "Bite": 25, "FireBlast": 40, "ProteinShake": 25, "Hydrate": 40, "Concentrate": 30]
    
    // using a struct to hold the data for each creature
    struct Creature {
        var hp:Float
        var spAttack:Float
        var phAttack:Float
        var def:Float
        var speed:Float
        var lvl:Float
        var xp:Float
        var levelXP:Float
        var sprite:UIImage
        var actionSprite:UIImage
        var unlocked:Bool
        var seen:Bool
        var attack1:String
        var attack2:String
    }
    
    // Adding all of the creatures in the game into a dictionary and assigning each to their name
    func setUpCreatures() {
        creatures = [
                    "cloocloo": Creature(hp: 110, spAttack: 10, phAttack: 70, def: 5, speed: 120, lvl: 1, xp: 0, levelXP: 3, sprite: UIImage(named: "ClooCloo")!, actionSprite: UIImage(named: "ClooClooAction")!, unlocked: false, seen: true, attack1: "StabPeck",attack2: "ProteinShake"),
    
                     "snapjaw": Creature(hp: 60, spAttack: 30, phAttack: 100, def: 70, speed: 50, lvl: 1, xp: 0, levelXP: 3, sprite: UIImage(named: "SnapJaw")!, actionSprite: UIImage(named: "SnapJawAction")!, unlocked: false, seen: true, attack1: "Bite", attack2: "Hydrate"),
                     
                     "pyrax": Creature(hp: 80, spAttack: 100, phAttack: 20, def: 5, speed: 75, lvl: 1, xp: 0, levelXP: 3, sprite: UIImage(named: "Pyrax")!, actionSprite: UIImage(named: "PyraxAction")!, unlocked: false, seen: true, attack1: "FireBlast", attack2: "Concentrate")
                    ]
    }
    
    // MARK: =====Getters and Setters=====
    func getUnlocked(_ name:String)->Bool {
        return creatures[name]!.unlocked
    }
    
    func getSeen(_ name:String)->Bool {
        return creatures[name]!.seen
    }
    
    func getAttackOne(_ name:String)->String {
        return creatures[name]!.attack1
    }

    func getAttackTwo(_ name:String)->String {
        return creatures[name]!.attack2
    }
    
    func getSelected()-> Bool {
        return selected
    }
    
    func getEffectiveness(_ name:String)-> Float{
        return attacks[name]!
    }
    
    func setSelected(_ state: Bool) {
        selected = state
    }
    
    func setCurrentMonster(_ name: String) {
        currentMonster = creatures[name]!
        currentMonsterName = name
    }
    
    func getCurrentMonsterName()->String {
        return currentMonsterName
    }
    
    func getCurrentMonsterSprite()->UIImage {
        return currentMonster.sprite
    }
    
    func setStatsMonster(_  name: String) {
        statsMonster = creatures[name]!
        statsMonsterName = name
    }
    
    func getStatsMonsterName()-> String {
        return statsMonsterName
    }
    
    func getHP(_ name: String)->Float {
        return creatures[name]!.hp
    }
    
    func getSpAtk(_ name: String)->Float {
        return creatures[name]!.spAttack
    }
    
    func getAtk(_ name: String)->Float {
        return creatures[name]!.phAttack
    }
    
    func getDef(_ name: String)->Float {
        return creatures[name]!.def
    }
    
    func getSpeed(_ name: String)->Float {
        return creatures[name]!.speed
    }
    
    func getLvlXp(_ name: String)->Float {
        return creatures[name]!.levelXP
    }
    
    func getXp(_ name: String)->Float {
        return creatures[name]!.xp
    }
    
    func getActionSprite(_ name: String)->UIImage {
        return creatures[name]!.actionSprite
    }
    
    func getSprite(_ name: String)->UIImage {
        return creatures[name]!.sprite
    }
    
    func getLvl(_ name: String)->Float {
        return creatures[name]!.lvl
    }
    
    func getCurrentMonsterActionSprite()->UIImage {
        return currentMonster.actionSprite
    }
    
    func getCreatureUnlock(_ name: String)->Bool {
        return creatures[name]!.unlocked
    }
    
    func setCreatureUnlock(name: String, status: Bool) {
        creatures[name]?.unlocked = status
    }
}

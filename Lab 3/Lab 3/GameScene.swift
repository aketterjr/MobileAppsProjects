//
//  GameScene.swift
//  Lab 3
//
//  Created by loaner on 10/15/23.
//
// MARK: =====Sources Used=====
// Pachinko Ball png https://www.pngwing.com/en/free-png-djyub

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: =====Raw Motion Functions=====
    let motion = CMMotionManager()
    // getting motion updates from CMMotion manger
    func startMotionUpdates(){
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 0.1
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion)
        }
    }
    
    // setting up the gravity in the game,
    // the gravity is constant in the y direction so the pachinko balls will always fall downwards, but the user can still tilt the screen in the x direction to change the path of the pachinko balls
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            self.physicsWorld.gravity = CGVector(dx: CGFloat(9.8 * gravity.x), dy: CGFloat(-9.8))
        }
    }
    
    
    
    //MARK: =====View Hierarchy Functions=====
    //the goal that the user is trying to get their pachinko balls to hit
    let goalBlock = SKSpriteNode()
    let scoreLabel = SKLabelNode(fontNamed: "Superclarendon-BlackItalic")
    // displaying the amount of balls the user has left to play with
    let currencyLabel = SKLabelNode(fontNamed: "Superclarendon-BlackItalic")
    var score:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
    }
    // the number of balls the user has which is determined by their step goal and their steps from yesterday
    var balls:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.currencyLabel.text = "Balls: \(newValue)"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        // start motion for gravity
        self.startMotionUpdates()
        
        // make the barriers for the ball
        self.addBarriers()
        
        // add some pegs to the board
        self.addPegAtPoint(CGPoint(x: size.width * 0.1, y: size.height * 0.25))
        self.addPegAtPoint(CGPoint(x: size.width * 0.9, y: size.height * 0.25))
        self.addPegAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.25))
        self.addPegAtPoint(CGPoint(x: size.width * 0.33, y: size.height * 0.5))
        self.addPegAtPoint(CGPoint(x: size.width * 0.66, y: size.height * 0.5))
        self.addPegAtPoint(CGPoint(x: size.width * 0.1, y: size.height * 0.75))
        self.addPegAtPoint(CGPoint(x: size.width * 0.9, y: size.height * 0.75))
        self.addPegAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.75))
        
        // add a goal block
        self.addGoalBlockAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.025))
        
        if CurrencyModel.shared.getCurrency() > 0
        {
            self.addPachinkoBall()
        }
        
        //adding the labels
        self.addLabels()
        
        //initialize the score to zero
        self.score = 0
        
        //initalize the ball count to the amount of steps the user got over their goal yesterday
        self.balls = Int(CurrencyModel.shared.getCurrency())
    }
    

    
    // MARK: =====Create Sprites Functions=====
    func addLabels(){
        //adding a label to let the user know how many balls they have left to play
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.magenta
        scoreLabel.position = CGPoint(x: frame.maxX * 0.8, y: frame.maxY * 0.9)
        
        currencyLabel.text = "Balls: 0"
        currencyLabel.fontSize = 20
        currencyLabel.fontColor = SKColor.systemIndigo
        currencyLabel.position = CGPoint(x: frame.maxX * 0.2, y: frame.maxY * 0.9)
        
        addChild(scoreLabel)
        addChild(currencyLabel)
    }
    
    func addPachinkoBall(){
        //let ballA = SKSpriteNode(imageNamed: "Ball") // pachinko ball
        let ballA = SKShapeNode(circleOfRadius: 12)
        ballA.fillColor = UIColor.white
        ballA.fillTexture = SKTexture(imageNamed: "Ball")
        
        //ballA.size = CGSize(width:size.width * 0.05, height: size.height * 0.025)
        // spawn a ball in a random x position but at a set height
        ballA.position = CGPoint(x: size.width * random(min: CGFloat(0.1), max: CGFloat(0.9)), y: size.height * 0.95)
        
        //ballA.physicsBody = SKPhysicsBody(rectangleOf: ballA.size)
        ballA.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        ballA.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        ballA.physicsBody?.isDynamic = true
        ballA.physicsBody?.contactTestBitMask = 0x00000001
        ballA.physicsBody?.collisionBitMask = 0x00000001
        ballA.physicsBody?.categoryBitMask = 0x00000001
        
        self.addChild(ballA)
    }
    
    //adding the goal block so that the user has to try and get to
    func addGoalBlockAtPoint(_ point:CGPoint){
        
        //setting up the goal block where the user tries to land their balls
        goalBlock.color = UIColor.red
        goalBlock.size = CGSize(width: size.width * 0.17, height: size.height * 0.05)
        goalBlock.position = point
        
        goalBlock.physicsBody = SKPhysicsBody(rectangleOf:goalBlock.size)
        goalBlock.physicsBody?.contactTestBitMask = 0x00000001
        goalBlock.physicsBody?.collisionBitMask = 0x00000001
        goalBlock.physicsBody?.categoryBitMask = 0x00000001
        goalBlock.physicsBody?.isDynamic = true
        goalBlock.physicsBody?.pinned = true
        goalBlock.physicsBody?.allowsRotation = false
        
        self.addChild(goalBlock)
    }
    
    //adding pegs that will bump the user's balls out of the way as its falling
    func addPegAtPoint(_ point:CGPoint){
        //making the pegs cirlces of radius 10
        let peg = SKShapeNode(circleOfRadius: 10)
        
        peg.position = point
        
        //giving the pegs properties
        peg.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        peg.fillColor = UIColor.black
        peg.physicsBody?.isDynamic = true
        peg.physicsBody?.pinned = true
        peg.physicsBody?.allowsRotation = false
        
        self.addChild(peg)
    }
    
    //setting up the barriers for the sides of the game board but leaving the bottom open so the balls can fall off the screen
    func addBarriers(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        let bar1 = SKSpriteNode()
        let bar2 = SKSpriteNode()
        
        left.size = CGSize(width: size.width * 0.05, height: size.height)
        left.position = CGPoint(x: 0, y: size.height * 0.5)
        
        right.size = CGSize(width: size.width * 0.05, height:size.height)
        right.position = CGPoint(x: size.width, y: size.height * 0.5)
        
        top.size = CGSize(width: size.width, height: size.height * 0.05)
        top.position = CGPoint(x: size.width * 0.5, y: size.height * 0.95)
        
        bar1.size = CGSize(width: size.width * 0.025, height: size.height * 0.1)
        bar1.position = CGPoint(x: size.width * 0.4, y: size.height * 0.05)
        
        bar2.size = CGSize(width: size.width * 0.025, height: size.height * 0.1)
        bar2.position = CGPoint(x: size.width * 0.6, y: size.height * 0.05)
        
        
        for obj in [left, right, top, bar1, bar2]{
            obj.color = UIColor.cyan
            obj.physicsBody = SKPhysicsBody(rectangleOf: obj.size)
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
    }
    
    
    
    // MARK: =====Delegate Functions=====
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if balls > 0
        {
            self.addPachinkoBall()
            balls -= 1
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // if the pachinko ball hit the goal, increment the score and delete it
        if contact.bodyA.node == goalBlock || contact.bodyB.node == goalBlock { self.score += 1 }
        if contact.bodyA.node == goalBlock { contact.bodyB.node?.removeFromParent() }
        else if contact.bodyB.node == goalBlock{ contact.bodyA.node?.removeFromParent() }
    }
    
    // MARK: =====Utility Functions=====
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(Int.max))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}

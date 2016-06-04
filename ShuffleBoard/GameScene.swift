//
//  GameScene.swift
//  ShuffleBoard
//
//  Created by Chris Zhang on 2016-06-03.
//  Copyright (c) 2016 Chris Zhang. All rights reserved.
//

import SpriteKit


//setting bit number to each node
struct physicsCategory {
    static let player1 : UInt32 = 0x1 << 1
    static let player2 : UInt32 = 0x1 << 2
    static let ball : UInt32 = 0x1 << 3
    static let gate1 : UInt32 = 0x1 << 4
    static let gate2 : UInt32 = 0x1 << 5
}

let player1 = SKSpriteNode(imageNamed: "player1")
let player2 = SKSpriteNode(imageNamed: "player2")
let ball = SKSpriteNode(imageNamed: "ball")
var touchingPlayer1 : Bool = false
var touchingPlayer2 : Bool = false
var location = CGPoint(x: 0, y: 0)
var scored : Bool = false
let gate1 = SKSpriteNode(imageNamed: "Gate1")
let gate2 = SKSpriteNode(imageNamed: "Gate2")
var player1Score : Int = 0
var player2Score : Int = 0
let scoreLabel1 = SKLabelNode()
let scoreLabel2 = SKLabelNode()
var touchPoint1: CGPoint = CGPoint()
var touchPoint2: CGPoint = CGPoint()
let winGameoverLabel = SKLabelNode()
let loseGameoverLabel = SKLabelNode()
var restartButton1 = SKSpriteNode()
var restartButton2 = SKSpriteNode()
var gameOver = Bool()
var readyRestart1 = Bool()
var readyRestart2 = Bool()


class GameScene: SKScene ,SKPhysicsContactDelegate{
    
    
    func createScene() {
        self.physicsWorld.contactDelegate = self
        let worldBorder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = worldBorder
        self.view!.multipleTouchEnabled = true
        
        player1.position = CGPoint(x: self.frame.width / 2, y: CGRectGetMidY(self.frame) / 2)
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.frame.height / 2 - 7)
        player1.setScale(2)
        player1.physicsBody?.affectedByGravity = false
        player1.physicsBody?.allowsRotation = false
        player1.physicsBody?.categoryBitMask = physicsCategory.player1
        //player1.physicsBody?.collisionBitMask = physicsCategory.ball | physicsCategory.player2
        //player1.physicsBody?.contactTestBitMask = physicsCategory.ball | physicsCategory.player2
        self.addChild(player1)
        
        
        player2.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4 * 3)
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.frame.height / 2 - 7)
        player2.setScale(2)
        //player2.physicsBody?.restitution = 0.1
        player2.physicsBody?.affectedByGravity = false
        player2.physicsBody?.allowsRotation = false
        player2.physicsBody?.categoryBitMask = physicsCategory.player2
        //player2.physicsBody?.collisionBitMask = physicsCategory.ball | physicsCategory.player1
        //player2.physicsBody?.contactTestBitMask = physicsCategory.ball | physicsCategory.player1
        self.addChild(player2)
        
        ball.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 7)
        ball.setScale(0.5)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height/2)
        ball.physicsBody?.restitution = 0.5
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.categoryBitMask = physicsCategory.ball
        //ball.physicsBody?.collisionBitMask = physicsCategory.player1 | physicsCategory.player2
        //ball.physicsBody?.contactTestBitMask = physicsCategory.gate1 | physicsCategory.gate2
        self.addChild(ball)
        
        gate1.setScale(2)
        gate1.position = CGPoint(x: self.frame.width / 2, y: 10)
        gate1.physicsBody = SKPhysicsBody(rectangleOfSize: gate1.frame.size)
        gate1.physicsBody?.affectedByGravity = false
        gate1.physicsBody?.dynamic = false
        gate1.physicsBody?.categoryBitMask = physicsCategory.gate1
        gate1.physicsBody?.contactTestBitMask = physicsCategory.ball
        self.addChild(gate1)
        
        gate2.setScale(2)
        gate2.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 10)
        gate2.physicsBody = SKPhysicsBody(rectangleOfSize: gate2.frame.size)
        gate2.physicsBody?.affectedByGravity = false
        gate2.physicsBody?.dynamic = false
        gate2.physicsBody?.categoryBitMask = physicsCategory.gate2
        gate2.physicsBody?.contactTestBitMask = physicsCategory.ball
        self.addChild(gate2)
        
        scoreLabel1.zRotation = CGFloat(M_PI)
        scoreLabel1.position = CGPoint(x: self.frame.width/5, y: self.frame.height / 2 + 30)
        scoreLabel1.zPosition = 4
        scoreLabel1.text = "\(player1Score)"//converting int to string
        scoreLabel1.fontColor = SKColor.redColor()
        scoreLabel1.fontName = "Arial"
        scoreLabel1.fontSize = 60
        self.addChild(scoreLabel1)
        
        scoreLabel2.position = CGPoint(x: self.frame.width/5*4, y: self.frame.height / 2 - 10)
        scoreLabel2.zPosition = 4
        scoreLabel2.text = "\(player2Score)"//converting int to string
        scoreLabel2.fontColor = SKColor.blueColor()
        scoreLabel2.fontName = "Arial"
        scoreLabel2.fontSize = 60
        self.addChild(scoreLabel2)
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        createScene()

    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == physicsCategory.ball && secondBody.categoryBitMask == physicsCategory.gate1 || firstBody.categoryBitMask == physicsCategory.gate1 && secondBody.categoryBitMask == physicsCategory.ball {
            if scored != true && player2Score < 11 {
                player1Score += 1
            }
            scored = true
            scoreLabel1.removeFromParent()
            scoreLabel1.text = "\(player1Score)"
            self.addChild(scoreLabel1)
            if player1Score == 11 {
                player2WinEndScene()
                createButton()
                gameOver = true
            }
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player2.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        else if firstBody.categoryBitMask == physicsCategory.ball && secondBody.categoryBitMask == physicsCategory.gate2 || firstBody.categoryBitMask == physicsCategory.gate2 && secondBody.categoryBitMask == physicsCategory.ball {
            if scored != true && player2Score < 11 {
                player2Score += 1
            }
            scored = true
            scoreLabel2.removeFromParent()
            scoreLabel2.text = "\(player2Score)"
            self.addChild(scoreLabel2)
            if player2Score == 11 {
                player1WinEndScene()
                createButton()
                gameOver = true
            }

            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player2.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
    }
    
    func player2WinEndScene() {
        winGameoverLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/4)
        winGameoverLabel.zPosition = 7
        winGameoverLabel.text = "You Lost:("
        winGameoverLabel.fontSize = 70
        winGameoverLabel.fontName = "Arial"
        winGameoverLabel.fontColor = SKColor.whiteColor()
        winGameoverLabel.removeFromParent()
        winGameoverLabel.setScale(0)
        self.addChild(winGameoverLabel)
        winGameoverLabel.runAction(SKAction.scaleTo(1.0, duration: 0.4))
        
        loseGameoverLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/4*3)
        loseGameoverLabel.zRotation = CGFloat(M_PI)
        loseGameoverLabel.zPosition = 7
        loseGameoverLabel.text = "You Won:)"
        loseGameoverLabel.fontSize = 70
        loseGameoverLabel.fontName = "Arial"
        loseGameoverLabel.fontColor = SKColor.whiteColor()
        loseGameoverLabel.removeFromParent()
        loseGameoverLabel.setScale(0)
        self.addChild(loseGameoverLabel)
        loseGameoverLabel.runAction(SKAction.scaleTo(1.0, duration: 0.4))
    }
    
    func player1WinEndScene() {
        winGameoverLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/4)
        winGameoverLabel.zPosition = 7
        winGameoverLabel.text = "You Win:)"
        winGameoverLabel.fontSize = 70
        winGameoverLabel.fontName = "Arial"
        winGameoverLabel.fontColor = SKColor.whiteColor()
        winGameoverLabel.removeFromParent()
        winGameoverLabel.setScale(0)
        self.addChild(winGameoverLabel)
        winGameoverLabel.runAction(SKAction.scaleTo(1.0, duration: 0.4))
        
        loseGameoverLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/4*3)
        loseGameoverLabel.zRotation = CGFloat(M_PI)
        loseGameoverLabel.zPosition = 7
        loseGameoverLabel.text = "You Lost:("
        loseGameoverLabel.fontSize = 70
        loseGameoverLabel.fontName = "Arial"
        loseGameoverLabel.fontColor = SKColor.whiteColor()
        loseGameoverLabel.removeFromParent()
        loseGameoverLabel.setScale(0)
        self.addChild(loseGameoverLabel)
        loseGameoverLabel.runAction(SKAction.scaleTo(1.0, duration: 0.4))
    }
    
    func createButton() {
        restartButton1 = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 120, height: 100))
        restartButton1.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4 - 100)
        restartButton1.zPosition = 5
        restartButton1.setScale(0)
        self.addChild(restartButton1)
        restartButton1.runAction(SKAction.scaleTo(1.0, duration: 0.4))
        
        restartButton2 = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 120, height: 100))
        restartButton2.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4 * 3 + 100)
        restartButton2.zPosition = 5
        restartButton2.setScale(0)
        self.addChild(restartButton2)

        restartButton1.runAction(SKAction.scaleTo(1.0, duration: 0.4))
        restartButton2.runAction(SKAction.scaleTo(1.0, duration: 0.4))

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if scored == true && gameOver == false{
            self.removeAllChildren()
            createScene()
            scored = false
        }
        //let touch = touches.first as! UITouch?
        for t in touches {
            let touch = t as UITouch
            let location = touch.locationInNode(self)
        //print(location)
        //print("!!!! \(player1.position.x),\(player1.position.x)")
        if player1.frame.contains(location) && gameOver == false{
            touchPoint1 = location
            touchingPlayer1 = true
        }
        if player2.frame.contains(location) && gameOver == false {
            touchPoint2 = location
            touchingPlayer2 = true
        }
        if gameOver == true {
            if restartButton1.frame.contains(location) {
                readyRestart1 = true
            }
            if restartButton2.frame.contains(location) {
                readyRestart2 = true
            }
            if readyRestart2 == true && readyRestart1 == true {
                restartGame()
            }
        }
        }
    }
    
    func restartGame() {
        player1Score = 0
        player2Score = 0
        gameOver = false
        readyRestart1 = false
        readyRestart2 = false
        self.removeAllChildren()
        createScene()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for t in touches {
            let touch = t as UITouch
            let location = touch.locationInNode(self)
            if player1.frame.contains(location) && gameOver == false{
                touchPoint1 = location
            }
            if player2.frame.contains(location) && gameOver == false{
                touchPoint2 = location
            }
            
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchingPlayer1 = false
        touchingPlayer2 = false
    }
    
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if touchingPlayer1 {
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: touchPoint1.x - player1.position.x, dy: touchPoint1.y - player1.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            player1.physicsBody!.velocity=velocity
        }
        if touchingPlayer2 {
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: touchPoint2.x - player2.position.x, dy: touchPoint2.y - player2.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            player2.physicsBody!.velocity=velocity
        }
    }
}



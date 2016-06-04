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




class GameScene: SKScene ,SKPhysicsContactDelegate{
    
    
    func createScene() {
        self.physicsWorld.contactDelegate = self
        let worldBorder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = worldBorder
        
        player1.position = CGPoint(x: self.frame.width / 2, y: CGRectGetMidY(self.frame) / 2)
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.frame.height / 2 - 7)
        player1.setScale(2)
        //player1.physicsBody?.restitution = 0.1
        player1.physicsBody?.affectedByGravity = false
        player1.physicsBody?.allowsRotation = false
        //player1.physicsBody?.dynamic = true
        player1.physicsBody?.categoryBitMask = physicsCategory.player1
        player1.physicsBody?.collisionBitMask = physicsCategory.ball
        player1.physicsBody?.contactTestBitMask = physicsCategory.ball | physicsCategory.player2
        self.addChild(player1)
        
        
        player2.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4 * 3)
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.frame.height / 2 - 7)
        player2.setScale(2)
        //player2.physicsBody?.restitution = 0.1
        player2.physicsBody?.affectedByGravity = false
        player2.physicsBody?.allowsRotation = false
        //player2.physicsBody?.dynamic = true
        player2.physicsBody?.categoryBitMask = physicsCategory.player2
        player2.physicsBody?.collisionBitMask = physicsCategory.ball
        player2.physicsBody?.contactTestBitMask = physicsCategory.ball | physicsCategory.player1
        self.addChild(player2)
        
        ball.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        ball.setScale(0.5)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height/2)
        ball.physicsBody?.restitution = 0.5
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.categoryBitMask = physicsCategory.ball
        ball.physicsBody?.collisionBitMask = physicsCategory.player1 | physicsCategory.player2
        ball.physicsBody?.contactTestBitMask = physicsCategory.player1 | physicsCategory.player2 | physicsCategory.gate1 | physicsCategory.gate2
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
            player1Score += 1
            scored = true
            scoreLabel1.removeFromParent()
            scoreLabel1.text = "\(player1Score)"
            self.addChild(scoreLabel1)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.scene?.speed = 0
        }
        
        else if firstBody.categoryBitMask == physicsCategory.ball && secondBody.categoryBitMask == physicsCategory.gate2 || firstBody.categoryBitMask == physicsCategory.gate2 && secondBody.categoryBitMask == physicsCategory.ball {
            scored = true
            player2Score += 1
            scoreLabel2.removeFromParent()
            scoreLabel2.text = "\(player2Score)"
            self.addChild(scoreLabel2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.scene?.speed = 0
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            if player1.containsPoint(location) && scored == false {
                player1.position = location
            }
            
            if player2.containsPoint(location) && scored == false {
                player2.position = location
            }

        }
        if scored == true {
            self.removeAllChildren()
            createScene()
            scored = false
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //scene would freeze when scored
        if scored == false {
            for touch in (touches as! Set<UITouch>) {
                location = touch.locationInNode(self)
                if player1.containsPoint(location) && scored == false {
                    player1.position = location
                    touchingPlayer1 = true
                }
            
                if player2.containsPoint(location) && scored == false {
                    player2.position = location
                    touchingPlayer2 = true
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchingPlayer1 = false
        touchingPlayer2 = false
        player1.physicsBody!.velocity = CGVectorMake(0, 0)
        player2.physicsBody?.velocity = CGVectorMake(0, 0)
        
    }
    
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if touchingPlayer1 {
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: location.x - player1.position.x, dy: location.y - player1.position.y)
            let velocity = CGVector(dx: distance.dx/dt * 20, dy: distance.dy/dt * 20)
            player1.physicsBody!.velocity=velocity
        }
        if touchingPlayer2 {
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: location.x - player2.position.x, dy: location.y - player2.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            player2.physicsBody!.velocity=velocity
        }
    }
}



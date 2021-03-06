//
//  GameScene.swift
//  Project11
//
//  Created by Prachanda Muni Bajracharya on 2/24/21.
//  Copyright © 2021 Prachanda Muni Bajracharya. All rights reserved.
//

// As with UIKit, it's easy enough to store a variable pointing at specific nodes in your scene for when you want to make something happen, and there are lots of times when that's the right solution.
// But for general use, Apple recommends assigning names to your nodes, then checking the name to see what node it is.

// Now for our shortcut: we're going to tell all the ball nodes to set their contactTestBitMask property to be equal to their collisionBitMask. Two bitmasks, with confusingly similar names but quite different jobs.
// The collisionBitMask bitmask means "which nodes should I bump into?" By default, it's set to everything, which is why our ball are already hitting each other and the bouncers. The contactTestBitMask bitmask means "which collisions do you want to know about?" and by default it's set to nothing. So by setting contactTestBitMask to the value of collisionBitMask we're saying, "tell me about every collision."
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var remainingBallsLabel: SKLabelNode!
    var remainingBalls = 5 {
        didSet {
            remainingBallsLabel.text = "Balls Left: \(remainingBalls)"
            
//            if remainingBalls == 0 {
//                // Delay a code
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
//                    [weak self] in
//                   // Code you want to be delayed
//                    if self?.remainingBalls == 0 {
//                        self?.tryAgainLabel.isHidden = false
//                    }
//                }
//            }
        }
    }
    
    var tryAgainLabel: SKLabelNode!
    var showTryAgain: Bool = false {
        didSet {
            if showTryAgain {
                tryAgainLabel.isHidden = false
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        remainingBallsLabel = SKLabelNode(fontNamed: "Chalkduster")
        remainingBallsLabel.text = "Balls Left: \(remainingBalls)"
        remainingBallsLabel.horizontalAlignmentMode = .center
        remainingBallsLabel.position = CGPoint(x: 512, y: 700)
        addChild(remainingBallsLabel)
        
        tryAgainLabel = SKLabelNode(fontNamed: "Chalkduster")
        tryAgainLabel.text = "Try Again!"
        tryAgainLabel.fontSize = 48
        tryAgainLabel.horizontalAlignmentMode = .center
        tryAgainLabel.position = CGPoint(x: 512, y: 384)
        tryAgainLabel.isHidden = true
        addChild(tryAgainLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // assign the current scene to be the physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    // First, we're going to use a new property on nodes called zRotation. When creating the background image, we gave it a Z position, which adjusts its depth on the screen, front to back. If you imagine sticking a skewer through the Z position – i.e., going directly into your screen – and through a node, then you can imagine Z rotation: it rotates a node on the screen as if it had been skewered straight through the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            print("obj \(objects)")
            
            if objects.contains(tryAgainLabel) {
                remainingBalls = 5
                score = 0
                tryAgainLabel.isHidden = true
            } else if objects.contains(editLabel) {
                // editingMode = !editingMode
                editingMode.toggle()
            } else {
                if editingMode {
                    // create a box
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    box.name = "box"
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: size)
                    box.physicsBody?.isDynamic = false
                    
                    addChild(box)
                } else if location.y > 550 && remainingBalls > 0 {
                    // create a ball
                    let ballImages = ["ballRed", "ballCyan", "ballYellow", "ballBlue", "ballGreen", "ballGrey", "ballPurple"]
                    let ball = SKSpriteNode(imageNamed: ballImages.randomElement()!)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    // Restitution affects the 'bounciness' of a physicsBody
                    ball.physicsBody?.restitution = 0.4
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                    
                    remainingBalls -= 1
                }
            }
        }
    }
    
    func  makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        let slotBase: SKSpriteNode
        let slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        // Yes CGFloat is yet another way of representing decimal numbers, just like Double and Float. Behind the scenes, CGFloat can be either a Double or a Float depending on the device your code runs on. Swift also has Double.pi and Float.pi for when you need it at different precisions.
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            remainingBalls += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "box" {
            destroyObject(object: object)
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func destroyObject(object: SKNode) {
        object.removeFromParent()
    }
    
    // Before I move on, I want to return to my philosophical question from earlier: “did the ball hit the slot, did the slot hit the ball, or did both happen?” That last case won’t happen all the time, but it will happen sometimes, and it’s important to take it into account.
    // If SpriteKit reports a collision twice – i.e. “ball hit slot and slot hit ball” – then we have a problem.
    // To solve this, we’re going to rewrite the didBegin() method to be clearer and safer: we’ll use guard to ensure both bodyA and bodyB have nodes attached. If either of them don’t then this is a ghost collision and we can bail out immediately.
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {
            return
        }
        guard let nodeB = contact.bodyB.node else {
            return
        }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    override func didFinishUpdate() {
        guard let _ = scene?.childNode(withName: "ball") else {
            if remainingBalls == 0 {
                showTryAgain = true
            }
            return
        }
    }
}

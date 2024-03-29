//
//  SlingShot.swift
//  MarbleBoom
//
//  Created by Stine Richvoldsen on 1/22/15.
//  Copyright (c) 2015 superrunt. All rights reserved.
//

import SpriteKit

class SlingShotNode: SKSpriteNode {
    
    let kBallRadius:CGFloat = 20.0
    let kCircleAngle = CGFloat(M_PI)*2
    
    var parentScene: SKScene = SKScene()
    var slingPostNode = SKShapeNode()
//    var shooterNode = SKShapeNode()
    var shooterNode = SKSpriteNode()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init () {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init? (scene: SKScene) {
        
        self.init(color: SKColor.clearColor(), size: scene.size)
        if !(scene.size.width != 0) { // trying to make sure the scene is initialized
            return nil
        }
        parentScene = scene
        
        slingPostNode = setUpSlingPost()
        addChild(slingPostNode)
        shooterNode = setUpShooter()
        addChild(shooterNode)
    }
    
    func addSpring() {
        addSpringBetween(slingPostNode, shooter: shooterNode)
    }
    
    func resetShooterAndSpring() {
        shooterNode = setUpShooter()
        addChild(shooterNode)
        addSpringBetween(slingPostNode, shooter: shooterNode)
    }
    
    private func addSpringBetween(post: SKShapeNode, shooter: SKSpriteNode) -> SKPhysicsJointSpring {
        let spring = SKPhysicsJointSpring.jointWithBodyA(post.physicsBody, bodyB: shooter.physicsBody, anchorA: post.position, anchorB: shooter.position)
        spring.frequency = 1.0;
        parentScene.physicsWorld.addJoint(spring)
        
        return spring
    }
    
//    private func setUpShooter(path: CGPath=CGPathCreateMutable(), color: SKColor=SKColor.blueColor()) -> SKShapeNode {
    private func setUpShooter(path: CGPath=CGPathCreateMutable(), color: SKColor=SKColor.blueColor()) -> SKSpriteNode {
        
//        let shooter = CGPathIsEmpty(path) ? SKShapeNode(path: CGPathCreateWithEllipseInRect(CGRectMake(0.0, 0.0, kBallRadius*2, kBallRadius*2), nil), centered: true) : SKShapeNode(path: path)
        let shooter = SKSpriteNode(imageNamed: TargetType.random().spriteName)
        
//        shooter.fillColor = color
//        shooter.strokeColor = color
//        shooter.glowWidth = 0.5
        shooter.position = CGPointMake(size.width/2, size.height*0.2)
//        shooter.physicsBody = SKPhysicsBody(circleOfRadius: kBallRadius) // TODO: change to be same size as sprite
        shooter.physicsBody = SKPhysicsBody(rectangleOfSize: shooter.frame.size)
        shooter.physicsBody?.mass = 1.0
        shooter.physicsBody?.categoryBitMask = GameBitmask.categoryShooters.rawValue
        shooter.physicsBody?.collisionBitMask = GameBitmask.categoryTargets.rawValue | GameBitmask.categoryWalls.rawValue
        shooter.physicsBody?.restitution = 0.3
        shooter.name = NodeNames.shooterDefault.rawValue
        
        return shooter
    }
    
    private func setUpSlingPost() -> SKShapeNode {
        let post = SKShapeNode(path: CGPathCreateWithEllipseInRect(CGRectMake(0.0, 0.0, 1.0, 1.0), nil), centered: true)
        post.fillColor = SKColor.clearColor()
        post.strokeColor = SKColor.clearColor()
        post.position = CGPointMake(size.width/2, size.height*0.3)
        post.physicsBody = SKPhysicsBody(circleOfRadius: kBallRadius/10)
        post.physicsBody?.categoryBitMask = GameBitmask.categoryInvisibles.rawValue
        // Give the post a near-infinite mass so it won't move
        post.physicsBody?.mass = 1000000
        post.physicsBody?.affectedByGravity = false
        post.name = NodeNames.slingPostDefault.rawValue
        
        return post
    }

//
//    func setUpTargets() {
//        let magneticField = SKFieldNode.magneticField();
//        magneticField.physicsBody = SKPhysicsBody(circleOfRadius: 80)
//        //        let magneticField = SKFieldNode.dragField();
//        //        magneticField.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, self.frame.size.height*0.6), center: CGPointMake(self.frame.width/2, self.frame.height*0.9))
//        //        magneticField.physicsBody?.charge = 30.0
//        magneticField.categoryBitMask = categoryMagneticField
//        //        magneticField.physicsBody?.categoryBitMask = categoryInvisibles
//        magneticField.physicsBody?.affectedByGravity = false
//        //        magneticField.strength = 1.0
//        //        magneticField.physicsBody?.mass = 1000000
//        //        magneticField.region = SKRegion(path: CGPathCreateWithRect(CGRectMake(40.0, 40.0, self.frame.width, self.frame.height*0.21), nil))
//        //        magneticField.position = CGPointMake(self.frame.width/2, self.frame.height*0.8)
//        magneticField.position = CGPointMake(100, 100)
//        //        magneticField.minimumRadius = 200.0
//        magneticField.enabled = true
//        
//        self.addChild(magneticField)
//        
//        for index in 0...40 {
//            var target = SKShapeNode(path: CGPathCreateWithEllipseInRect(CGRectMake(0.0, 0.0, 60.0, 60.0), nil), centered: true)
//            let idx = Int(arc4random_uniform(3))
//            let color = randomColors[idx]
//            target.fillColor = color
//            target.strokeColor = color
//            if (index == 0) {
//                target.position = CGPointMake(self.frame.width*0.5, self.frame.height*1.0)
//            } else {
//                let multiplier = CGFloat(arc4random_uniform(10))/100.0
//                target.position = CGPointMake(self.frame.width*multiplier, self.frame.height*1.0)
//            }
//            target.physicsBody = SKPhysicsBody(circleOfRadius: kBallRadius)
//            target.physicsBody?.charge = 40.0
//            target.physicsBody?.categoryBitMask = categoryTargets
//            target.physicsBody?.collisionBitMask = categoryShooters | categoryTargets | categoryWalls
//            target.physicsBody?.fieldBitMask = categoryMagneticField
//            self.addChild(target)
//        }
//    }
//    
//
}


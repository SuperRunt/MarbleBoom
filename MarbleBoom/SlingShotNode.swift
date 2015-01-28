//
//  SlingShot.swift
//  MarbleBoom
//
//  Created by Stine Richvoldsen on 1/22/15.
//  Copyright (c) 2015 superrunt. All rights reserved.
//

import SpriteKit

class SlingShotNode: SKSpriteNode {
    
    let kBallRadius:CGFloat = 30.0
    let kCircleAngle = CGFloat(M_PI)*2
    
    var parentScene: SKScene = SKScene()
    var slingPostNode = SKShapeNode()
    var shooterNode = SKShapeNode()
    
    var slingAction = SKAction()

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
//        position = CGPointMake(-size.width/2, 0.0)
        
        slingPostNode = setUpSlingPost()
        addChild(slingPostNode)
        shooterNode = setUpShooter()
        addChild(shooterNode)
        // TODO: bad form to change the parent's physicsworld here. need to change
        let springSequence = [SKAction.waitForDuration(0.1), SKAction.runBlock({self.parentScene.physicsWorld.removeAllJoints()})]
        slingAction = SKAction.sequence(springSequence)

    }
    
    
    
    func setUpShooter(path: CGPath=CGPathCreateMutable(), color: SKColor=SKColor.blueColor()) -> SKShapeNode {
        
        let shooter = CGPathIsEmpty(path) ? SKShapeNode(path: CGPathCreateWithEllipseInRect(CGRectMake(0.0, 0.0, 60.0, 60.0), nil), centered: true) : SKShapeNode(path: path)
        
        shooter.fillColor = color
        shooter.strokeColor = color
        shooter.glowWidth = 0.5
        shooter.position = CGPointMake(0.0, -size.height*0.2)
        shooter.physicsBody = SKPhysicsBody(circleOfRadius: kBallRadius) // TODO: change to be same size as sprite
        shooter.physicsBody?.mass = 1.0
        shooter.physicsBody?.categoryBitMask = GameBitmask.categoryShooters.rawValue
        shooter.physicsBody?.collisionBitMask = GameBitmask.categoryTargets.rawValue | GameBitmask.categoryWalls.rawValue
        shooter.physicsBody?.restitution = 0.3
        shooter.name = "shooter"
        
        return shooter
    }
    
    func setUpSlingPost() -> SKShapeNode {
        let post = SKShapeNode(path: CGPathCreateWithEllipseInRect(CGRectMake(0.0, 0.0, 60.0, 60.0), nil), centered: true)
        post.fillColor = SKColor.redColor()
        post.strokeColor = SKColor.clearColor()
        post.position = CGPointMake(0.0, -size.height*0.1)
        post.physicsBody = SKPhysicsBody(circleOfRadius: kBallRadius)
        post.physicsBody?.categoryBitMask = GameBitmask.categoryInvisibles.rawValue
        // Give the post a near-infinite mass so it won't move
        post.physicsBody?.mass = 1000000
        post.physicsBody?.affectedByGravity = false
        post.name = "slingPost"
        
        return post
    }
    
    func addJoint(positionA: CGPoint, positionB: CGPoint) {
        // Connect shooter with post via a spring
//        let positionA = convertPoint(slingPostNode.position, fromNode: parentScene)
//        let positionB = convertPoint(shooterNode.position, fromNode: parentScene)
        
        let spring = SKPhysicsJointSpring.jointWithBodyA(slingPostNode.physicsBody, bodyB: shooterNode.physicsBody, anchorA: positionA, anchorB: positionB)
        spring.damping = 0.2;
        spring.frequency = 1.0;
        parentScene.physicsWorld.addJoint(spring)
    }


    
//    override func didMoveToView(view: SKView) {
//        /* Setup your scene here */
//        
//        // collision boundaries
//        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
//        self.physicsBody?.affectedByGravity = false
//        
//        // sling action
//        let springSequence = [SKAction.waitForDuration(0.1), SKAction.runBlock({self.physicsWorld.removeAllJoints()})]
//        slingAction = SKAction.sequence(springSequence)
//        
//        // set shooter position TODO: change how this is done
//        shooterInitialPosition = CGPointMake(self.frame.width/2, self.frame.height*0.3)
//
//        // Create an invisible post to anchor the square to
//        self.setUpSling()
//        
//        // shooter node
//        self.setUpShooter()
//        
//        // Connect shooter with post via a spring
//        let spring = SKPhysicsJointSpring.jointWithBodyA(slingPost.physicsBody, bodyB: shooterNode.physicsBody, anchorA: slingPost.position, anchorB: shooterNode.position)
//        spring.damping = 0.2;
//        spring.frequency = 1.0;
//        self.physicsWorld.addJoint(spring)
//
//        self.setUpTargets()
//        
//        // Lower gravity from default {0.0, -9.8} to allow the
//        // ball to be slung farther
//        self.physicsWorld.gravity = CGVectorMake(0.0, -6.0);
//    }
//    
//
//    func setUpSling() {
//        slingPost.fillColor = SKColor.clearColor()
//        slingPost.strokeColor = SKColor.clearColor()
//        slingPost.position = CGPointMake(self.frame.width*0.5, self.frame.height*0.3)
//        slingPost.physicsBody = SKPhysicsBody(circleOfRadius: kBallRadius)
//        slingPost.physicsBody?.categoryBitMask = categoryInvisibles
//        slingPost.name = "slingPost"
//        // Give the field a near-infinite mass so it won't move
//        slingPost.physicsBody?.mass = 1000000
//        slingPost.physicsBody?.affectedByGravity = false
//        
//        self.addChild(slingPost)
//    }
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
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            selectNodeForTouch(location)
//        }
//    }
//    
//    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//        let touch = touches.anyObject()
//        let positionInScene = touch?.locationInNode(self)
//        let previousPosition = touch?.previousLocationInNode(self)
//        let translation = CGPointMake(positionInScene!.x - previousPosition!.x, positionInScene!.y - previousPosition!.y)
//        _selectedNode.position = CGPointMake(positionInScene!.x + translation.x, positionInScene!.y + translation.y)
//    }
//    
//    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        //        square.runAction(SKAction.repeatActionForever(slingAction))
//    }
//    
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
//    
//    override func didSimulatePhysics() {
//        self.enumerateChildNodesWithName("post", usingBlock: {
//            node, stop in
//            if ( node.position.y < 0 ) {
//                node.removeFromParent()
//            }
//        })
//        self.enumerateChildNodesWithName("shooter", usingBlock: {
//            node, stop in
//            if ( node.position.y == 0 ) {
//                node.removeFromParent()
//            }
//            // spring lets go of ball as it passes the slingpost
//            if ( node.position.y > self.slingPost.position.y ) {
//                self.runAction(self.slingAction)
//            }
//        })
//    }
//    
//    private func selectNodeForTouch(touchLocation: CGPoint) {
//        let touchedNode = self.nodeAtPoint(touchLocation)
//        if ( _selectedNode != touchedNode ) {
//            _selectedNode.removeAllActions()
//            _selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
//            _selectedNode = touchedNode as SKShapeNode
//            
//            if ( touchedNode.name == "square" ) {
//                let sequence = SKAction.sequence([
//                    SKAction.rotateToAngle(-2.0, duration: 0.1),
//                    SKAction.rotateToAngle(0.0, duration: 0.1),
//                    SKAction.rotateToAngle(2.0, duration: 0.1),
//                    SKAction.rotateToAngle(0.0, duration: 0.1)
//                    ])
//                _selectedNode.runAction(sequence)
//            }
//        }
//    }
}


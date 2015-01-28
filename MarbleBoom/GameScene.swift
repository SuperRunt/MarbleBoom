//
//  GameScene.swift
//  MarbleBoom
//
//  Created by Stine Richvoldsen on 1/8/15.
//  Copyright (c) 2015 superrunt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var level: Level!
    var shooterInitialPosition: CGPoint!
    
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    
    var gameLayer = SKNode()
    var targetsLayer = SKNode()
    var slingShotLayer: SlingShotNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
//        let background = SKSpriteNode(imageNamed: "Background")
//        addChild(background)
        
        addCollisionBoundaries()
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: 0)
        
        targetsLayer.position = layerPosition
        gameLayer.addChild(targetsLayer)
        
        slingShotLayer = SlingShotNode(scene: self)
        gameLayer.addChild(slingShotLayer!)
        let postPos = slingShotLayer!.slingPostNode.position
        let shooterPos = slingShotLayer!.shooterNode.position

//        slingShotLayer?.addJoint(postPos, positionB: shooterPos)
        
//        // Connect shooter with post via a spring
        let positionA = slingShotLayer!.slingPostNode.position
        let positionB = slingShotLayer!.shooterNode.position
        let spring = SKPhysicsJointSpring.jointWithBodyA(slingShotLayer?.slingPostNode.physicsBody, bodyB: slingShotLayer?.shooterNode.physicsBody, anchorA: convertPoint(positionA, toNode: self), anchorB: convertPoint(positionB, toNode: self))
        spring.damping = 0.2;
        spring.frequency = 1.0;
        physicsWorld.addJoint(spring)
        
        // Lower gravity from default {0.0, -9.8} to allow the
        // ball to be slung farther TODO: move to levels? somewhere else....
        self.physicsWorld.gravity = CGVectorMake(0.0, -6.0);
        
    }
    
    func addCollisionBoundaries() {
        // frame collision boundaries
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.affectedByGravity = false
    }
    
    func addSpritesForTargets(targets: Set<Target>) {
        for target in targets {
            let sprite = SKSpriteNode(imageNamed: target.targetType.spriteName)
            sprite.position = pointForColumn(target.column, row:target.row)
            target.sprite = sprite
            sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
            sprite.physicsBody?.categoryBitMask = GameBitmask.categoryTargets.rawValue
            sprite.physicsBody?.collisionBitMask = GameBitmask.categoryWalls.rawValue | GameBitmask.categoryShooters.rawValue
            sprite.physicsBody?.affectedByGravity = false
            targetsLayer.addChild(sprite)
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column)*TileWidth + TileWidth/2, y: CGFloat(row)*TileHeight + TileHeight/2)
    }
}

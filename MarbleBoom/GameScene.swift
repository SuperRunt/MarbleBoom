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
    var slingAction = SKAction()
    
    private var _selectedNode = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
        addCollisionBoundaries()
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(x: 0.0+TileWidth/3, y: size.height-CGFloat(NumRows)*TileHeight)
        targetsLayer.position = layerPosition
        gameLayer.addChild(targetsLayer)
        
        // TODO: add conditional depending on level settings
        addSlingShot()
        
        // Lower gravity from default {0.0, -9.8} to allow the
        // ball to be slung farther TODO: move to levels? somewhere else....
        self.physicsWorld.gravity = CGVectorMake(0.0, -6.0);
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            selectNodeForTouch(location)
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject()
        let positionInScene = touch?.locationInNode(self)
        let previousPosition = touch?.previousLocationInNode(self)
        let translation = CGPointMake(positionInScene!.x - previousPosition!.x, positionInScene!.y - previousPosition!.y)
        _selectedNode.position = CGPointMake(positionInScene!.x + translation.x, positionInScene!.y + translation.y)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        //        square.runAction(SKAction.repeatActionForever(slingAction))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func didSimulatePhysics() {
        slingShotLayer?.enumerateChildNodesWithName("slingPost", usingBlock: {
            node, stop in
            if ( node.position.y < 0 ) {
                node.removeFromParent()
            }
        })
        slingShotLayer?.enumerateChildNodesWithName("shooter", usingBlock: {
            node, stop in
            if ( node.position.y == 0 ) {
                node.removeFromParent()
            }
            // spring lets go of ball as it passes the slingpost
            let postPos = self.slingShotLayer!.slingPostNode.position
            if ( node.position.y > postPos.y ) {
                self.runAction(self.slingAction)
            }
        })
    }
    
    func addSlingShot() {
        slingShotLayer = SlingShotNode(scene: self)
        gameLayer.addChild(slingShotLayer!)
        
        let springSequence = [SKAction.waitForDuration(0.1), SKAction.runBlock({self.physicsWorld.removeAllJoints()})]
        slingAction = SKAction.sequence(springSequence)
        
        slingShotLayer?.addSpring()
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
    
    private func selectNodeForTouch(touchLocation: CGPoint) {
        let touchedNode = self.nodeAtPoint(touchLocation)
        if ( _selectedNode != touchedNode ) {
            _selectedNode.removeAllActions()
            _selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
            _selectedNode = touchedNode as SKShapeNode
            
            if ( touchedNode.name == "square" ) {
                let sequence = SKAction.sequence([
                    SKAction.rotateToAngle(-2.0, duration: 0.1),
                    SKAction.rotateToAngle(0.0, duration: 0.1),
                    SKAction.rotateToAngle(2.0, duration: 0.1),
                    SKAction.rotateToAngle(0.0, duration: 0.1)
                    ])
                _selectedNode.runAction(sequence)
            }
        }
    }
    
    private func addCollisionBoundaries() {
        // frame collision boundaries
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.affectedByGravity = false
    }
    
    private func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column)*TileWidth + TileWidth/2, y: CGFloat(row)*TileHeight + TileHeight/2)
    }
}

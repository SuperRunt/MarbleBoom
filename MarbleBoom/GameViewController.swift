//
//  GameViewController.swift
//  MarbleBoom
//
//  Created by Stine Richvoldsen on 1/8/15.
//  Copyright (c) 2015 superrunt. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var level: Level!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true

        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        level = Level()
        scene.level = level
        // Present the scene.
        skView.presentScene(scene)
        
        // start the game
        startGame()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func startGame() {
        shuffle()
    }
    
    func shuffle() {
        let newTargets = level.shuffle()
        scene.addSpritesForTargets(newTargets)
    }
}

// category bitmask
enum GameBitmask: UInt32 {
    case categoryShooters =       0
    case categoryTargets =       1
    case categoryWalls =         2
    case categoryInvisibles =    3
    case categoryMagneticField = 4
}

// node names
enum NodeNames: String {
    case shooterDefault =   "shooter"
    case shooterLaunched =  "shooterLaunched"
    case slingPostDefault = "slingPost"
    
}

//extension SKNode {
//    class func unarchiveFromFile(file : NSString) -> SKNode? {
//        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
//            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
//            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//
//            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
//            archiver.finishDecoding()
//            return scene
//        } else {
//            return nil
//        }
//    }
//}

//extension SKScene {
//    class func unarchiveFromFile(file : NSString) -> SKNode? {
//        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
//            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
//            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//
//            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKScene
//            scene.size = GameKitHelper.sharedGameKitHelper().getRootViewController().view.frame.size
//            archiver.finishDecoding()
//            return scene
//        } else {
//            return nil
//        }
//    }
//}


//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
//
//            // Detect the screensize
//            var sizeRect = UIScreen.mainScreen().applicationFrame
//            var width = sizeRect.size.width * UIScreen.mainScreen().scale
//            var height = sizeRect.size.height * UIScreen.mainScreen().scale
//
//            // Scene should be shown in fullscreen mode
//            let scene = GameScene(size: CGSizeMake(width, height))
//
//            // Configure the view.
//            let skView = self.view as SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsPhysics = true
//
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .AspectFill
//
//            skView.presentScene(scene)
//        }
//    }

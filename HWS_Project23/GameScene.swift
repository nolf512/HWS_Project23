//
//  GameScene.swift
//  HWS_Project23
//
//  Created by J on 2021/05/04.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var score = 0 {
        didSet {
            scoreLabel.text = "score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
    }
    
}

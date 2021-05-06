//
//  GameScene.swift
//  HWS_Project23
//
//  Created by J on 2021/05/04.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var score = 0 {
        didSet {
            gameScore.text = "score: \(score)"
        }
    }

    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    var activeSlicePoints = [CGPoint]()
    
    var isSwooshSoundActive = false
    
    override func didMove(to view: SKView) {
        
        //背景
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //物理関連
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
    }
    
    
    func createScore(){
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    func createLives(){
        //sliceLifeイメージを３つ配置
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices(){
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    //画面のタッチ開始
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            //playSwooshSound()
        }
        
    }
    
    //画面のタッチ開始
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        //activeSlicePoints配列内の要素を全て削除
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        //タッチ位置を取得
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        //スライスシェイプに現在アタッチされているアクションをすべて削除
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        //アルファ値1に設定し完全に表示
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
        
    }
    
    func redrawActiveSlice(){
        
        //activeSlicePointsが二点未満だったら処理を終了
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        //activeSlicePointsを12以内にする
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        //線を引く
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1..<activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        //スライス形状のパスを更新し線の幅と色などのデザインを使用して描画
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
        
    }
    
    func playSwooshSound(){
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound){[weak self] in
            self?.isSwooshSoundActive = false
        }
        
    }
    
}

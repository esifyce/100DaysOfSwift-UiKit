//
//  GameScene.swift
//  66.Day.Project(16-18)-Milestone
//
//  Created by Sabir Myrzaev on 07.12.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Variable
    var backroundShoot: SKSpriteNode!
    var target: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    var checkTarget = 9
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var timer = 60 {
        didSet {
            timerLabel.text = "Timer: \(timer)"
        }
    }
    
    // MARK: - didMove
    override func didMove(to view: SKView) {
        
        createBackground()
        
        for i in 0..<3 {
            if i == 0 {
                for _ in 0...2 {
                    createTarget()
                    target.setScale(0.2)
                    let moveLeft = SKAction.moveBy(x: frame.width - target.position.x - 40, y: 0, duration: 2)
                    let sequence = SKAction.sequence([moveLeft, moveLeft.reversed()])
                    target.run(SKAction.repeatForever(sequence))
                }
            }
            if i == 1 {
                for _ in 0...2 {
                    createTarget()
                    target.setScale(0.4)
                    let moveLeft = SKAction.moveBy(x: frame.width - target.position.x - 40, y: 0, duration: 2)
                    let sequence = SKAction.sequence([moveLeft, moveLeft.reversed()])
                    target.run(SKAction.repeatForever(sequence))
                }
            }
            if i == 2 {
                for _ in 0...2 {
                    createTarget()
                    target.setScale(0.5)
                    let moveLeft = SKAction.moveBy(x: frame.width - target.position.x - 40, y: 0, duration: 2)
                    let sequence = SKAction.sequence([moveLeft, moveLeft.reversed()])
                    target.run(SKAction.repeatForever(sequence))
                }
            }
            
        }
        
        createScore()
        createTimer()
    }
    
    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        if timer == 0 {
            gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.text = "GAME OVER"
            gameOverLabel.fontSize = 120
            for child in self.children {
                if child.name == "target" {
                    child.removeFromParent()
                }
            }
            gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(gameOverLabel)
        }
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "target" {
                touchedNode.removeFromParent()
                checkTarget -= 1
                score += 20
                
                if let explosion = SKEmitterNode(fileNamed: "explosion") {
                    explosion.position = touchedNode.position
                    addChild(explosion)
                }
                
                if checkTarget == 0 {
                    gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
                    gameOverLabel.text = "VICTORY"
                    gameOverLabel.fontSize = 120
                    gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
                    addChild(gameOverLabel)
                    timerLabel.removeAllActions()
                }
            }
        }
    }
    // MARK: - Create Node
    func createBackground() {
        backroundShoot = SKSpriteNode(imageNamed: "shootBase")
        backroundShoot.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        backroundShoot.blendMode = .replace
        backroundShoot.zPosition = -1
        backroundShoot.setScale(2)
        addChild(backroundShoot)
    }
    
    func createTarget() {
        target = SKSpriteNode(imageNamed: "target1")
        target.position = CGPoint(x: Int.random(in: 30...700), y: Int.random(in: 30...700))
        target.name = "target"
        addChild(target)
        target.zPosition = 2
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
    }
    
    func createTimer() {
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.text = "Timer: \(timer)"
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: 200, y: 700)
        addChild(timerLabel)
        
        let timerWait = SKAction.wait(forDuration: 1)
        let timerRun = SKAction.run { [weak self] in
            self?.timer -= 1
            self?.timerLabel.text = "Timer: \(self?.timer ?? 0)"
        }
        timerLabel.run(SKAction.repeat(SKAction.sequence([timerRun,timerWait]), count: 60))
    }
}


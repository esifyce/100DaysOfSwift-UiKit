//
//  GameScene.swift
//  62.Day-Project17-SpaceRace
//
//  Created by Sabir Myrzaev on 07.12.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var sprite: SKSpriteNode!
    var newGameLabel: SKSpriteNode!
    var gameOverLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var hintLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var isTouched = false
    var isStarted = false
    var buttonActivated = false
    var wasContact = false
    var gameTimer: Timer?
    
    var spawnInterval = 0.35
    var enemies = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        createPlayer()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        scoreLabel.zPosition = 2
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) { [weak self] in
            self?.gameTimer = Timer.scheduledTimer(timeInterval: self!.spawnInterval, target: self!, selector: #selector(self?.createEnemy), userInfo: nil, repeats: true)
            
            self?.isStarted = true
            
            self?.hintLabel = SKLabelNode(fontNamed: "Chalkduster")
            self?.hintLabel.text = "GRAB THE SHIP AND AVOID THE DEBRIS!"
            self?.hintLabel.position = CGPoint(x: 512, y: 140)
            self?.hintLabel.horizontalAlignmentMode = .center
            self?.hintLabel.fontSize = 30
            self!.addChild(self!.hintLabel)
            self?.hintLabel.zPosition = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) { [weak self] in
            self?.hintLabel.run(SKAction.fadeAlpha(to: 0, duration: 2))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if wasContact == false {
            player.removeFromParent()
            
            let explosion = SKEmitterNode(fileNamed: "explosion")!
            explosion.position = player.position
            addChild(explosion)
            
            isGameOver = true
            gameTimer?.invalidate()
            
            gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.text = "GAME OVER"
            gameOverLabel.position = CGPoint(x: 512, y: 384)
            gameOverLabel.horizontalAlignmentMode = .center
            gameOverLabel.fontSize = 48
            addChild(gameOverLabel)
            gameOverLabel.zPosition = 2
            
            newGameLabel = SKSpriteNode(imageNamed: "newGameBtn")
            newGameLabel.position = CGPoint(x: 512, y: 340)
            newGameLabel.setScale(0.5)
            addChild(newGameLabel)
            newGameLabel.zPosition = 2
            wasContact = true
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    // MARK: - Touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        if isTouched == true && isStarted == true {
            player.position = location
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node == player {
                isTouched = true
            }
            
            if node == newGameLabel {
                buttonActivated = true
                node.run(SKAction.scale(by: 0.8, duration: 0.1))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node == player {
                isTouched = false
                print("lifted finger")
            }
        }
        
        if buttonActivated == true {
            newGameLabel.run(SKAction.scale(to: 0.5, duration: 0.1))
            UIView.animate(withDuration: 1, delay: 0, options: []) {
                self.view?.alpha = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                UIView.animate(withDuration: 1,delay: 0.5) {
                    self?.view?.alpha = 1
                }
                self?.reloadScene()
            }
        }
    }
    // MARK: - Create
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        sprite.setScale(0.5)
        addChild(sprite)
        enemies += 1
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -430, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        sprite.name = "sprite"
        
        if enemies > 0 && enemies % 20 == 0 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: spawnInterval - 0.1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        player.setScale(0.9)
        player.name = "player"
        addChild(player)
    }
   // MARK: - Reload Scene
    func reloadScene() {
        if let view = self.view {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

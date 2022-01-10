//
//  GameScene.swift
//  70.Day-Project20-FireworksNight
//
//  Created by Sabir Myrzaev on 08.01.2022.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameOverLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var comboLabel: SKLabelNode!
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    var launchGame = 0
    
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                if fireworks.count == 0 {
                    launchGame += 1
                }
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
        if launchGame == 5 {
            gameTimer?.invalidate()
            createGameOverLabel()
        }
    }
    // MARK: - Explode
    // method boom firework
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                // destroy with firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
            createComboLabel()
        case 3:
            score += 1500
            createComboLabel()
        case 4:
            score += 2500
            createComboLabel()
        default:
            score += 4000
            createComboLabel()
        }
    }
    // MARK: - Create Label
    func createGameOverLabel() {
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GameOver"
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.fontSize = 48
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
    }
    
    func createComboLabel() {
        comboLabel = SKLabelNode(fontNamed: "Chalkduster")
        comboLabel.text = "WOOOOW"
        comboLabel.position = CGPoint(x: 512, y: 384)
        comboLabel.horizontalAlignmentMode = .center
        comboLabel.fontSize = 48
        comboLabel.zPosition = 1
        addChild(comboLabel)
        
        let move = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
        let fade = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let wait = SKAction.wait(forDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let comboSequence = SKAction.sequence([wait, remove])
        
        comboLabel.run(move)
        comboLabel.run(fade)
        comboLabel.run(comboSequence)
    }
}

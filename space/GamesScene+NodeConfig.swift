//
//  Elements.swift
//  space
//
//  Created by Kamila Kusainova on 26.06.17.
//  Copyright © 2017 sdu. All rights reserved.
//

import Foundation
import SpriteKit


struct bitMask {
    static  let player : UInt32 = 1
    static  let wall : UInt32 = 2
}

enum RowType: Int{
    case one, two, three, four, five, six
}

extension GameScene {
    
    func setupWorldPhysics() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func moveBackground(){
        let move = SKAction.moveBy(x: 0, y: -screenHeight, duration: 5)
        let replace = SKAction.moveBy(x: 0, y: screenHeight, duration: 0)
        let moveForever = SKAction.repeatForever(SKAction.sequence([move,replace]))
        for i in 0...3 {
            background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "GameWall")))
            background.size = CGSize(width: screenWidth, height: screenHeight)
            background.position = CGPoint(x: screenWidth / 2 , y: screenHeight * CGFloat(i))
            background.run(moveForever)
            background.zPosition = -1
            addChild(background)
        }
    }
    
    func createPlayer(){
        player = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Rocket")))
        player.position = CGPoint(x: screenWidth / 2, y: screenHeight / 3)
        player.name = "player"
        player.size = CGSize(width: screenWidth / 5.35, height: screenHeight / 4.3)
        player.zPosition = 1
        player.speed = 10
        player.physicsBody?.isDynamic = true
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: screenWidth / 8, height: screenHeight / 7.75))
        player.physicsBody?.categoryBitMask = bitMask.player
        player.physicsBody?.collisionBitMask = bitMask.player
        player.physicsBody?.contactTestBitMask = bitMask.wall
        
        playerEmitter = SKEmitterNode(fileNamed: "spark.sks")!
        playerEmitter.position = CGPoint(x: screenWidth / 150, y:screenHeight / -27)
        playerEmitter.zPosition = 1
        playerEmitter.isHidden = true
        player.addChild(playerEmitter)
        
        boomEmitter = SKEmitterNode(fileNamed: "MyParticle.sks")!
        boomEmitter.position = CGPoint(x: screenWidth / 6, y:screenHeight / 2)
        boomEmitter.zPosition = 2
        boomEmitter.isHidden = true
//        player.addChild(boomEmitter)
        
        self.addChild(player)
    }
    
    func createWall() -> SKSpriteNode {
        var textures = [SKTexture]()
        textures.append(SKTexture(image: #imageLiteral(resourceName: "red")))
        textures.append(SKTexture(image: #imageLiteral(resourceName: "blue")))
        let rand = Int(arc4random_uniform(UInt32(textures.count)))
        let texture = textures[rand] as SKTexture
        
        let   wall = SKSpriteNode(texture: texture)
        wall.name = "wall"
        wall.position = CGPoint(x: 0, y: screenHeight / 0.78)
        wall.zPosition = 1
        wall.size = CGSize(width: screenWidth / 2.2, height: screenHeight / 10.2)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody = SKPhysicsBody(circleOfRadius: screenHeight / 33.35)
        wall.physicsBody?.categoryBitMask = bitMask.wall
        wall.physicsBody?.collisionBitMask = 0
        
        let rotate = SKAction.rotate(byAngle: .pi / 4, duration: 1)
        let foreverRotate = SKAction.repeatForever(rotate)
        wall.run(foreverRotate)
        return wall
    }
    
    func addMovement(wall :SKSpriteNode){
        if state == .play{
            var actionArray = [SKAction]()
            actionArray.append(SKAction.move(to: CGPoint(x: wall.position.x, y: -wall.size.height), duration: TimeInterval(i)))
            actionArray.append(SKAction.removeFromParent())
            wall.run(SKAction.sequence(actionArray))
        }
            if i <= 0 {
                state = .end
            }
    }
    
    func addRow(type: RowType){
        let wall1 = createWall()
        let wall2 = createWall()
        let wall3 = createWall()
        let wall4 = createWall()
        let wall5 = createWall()
        
        switch type {
        case .one:
            wall1.position = CGPoint(x: screenWidth / 9, y: wall1.position.y)
            wall2.position = CGPoint(x: screenWidth / 4, y: wall2.position.y)
            wall3.position = CGPoint(x: screenWidth / 1.5, y: wall3.position.y)
            wall4.position = CGPoint(x: screenWidth / 1.25 , y: wall4.position.y)
            wall5.position = CGPoint(x: screenWidth / 1.07, y: wall5.position.y)
            [wall1,wall2, wall3,wall4,wall5].forEach {
                addChild($0)}
            break
        case .two:
            wall1.position = CGPoint(x: screenWidth / 2.5, y: wall1.position.y)
            wall2.position = CGPoint(x: screenWidth / 9, y: wall2.position.y)
            wall3.position = CGPoint(x: screenWidth / 4, y: wall3.position.y)
            wall4.position = CGPoint(x: screenWidth / 1.8, y: wall4.position.y)
            wall5.position = CGPoint(x: screenWidth / 1.1, y: wall5.position.y)
            [wall1,wall2,wall3,wall4,wall5].forEach {
                addChild($0)}
            break
        case .three:
            wall1.position = CGPoint(x: screenWidth / 1.95, y: wall1.position.y)
            wall2.position = CGPoint(x: screenWidth / 1.25, y: wall2.position.y)
            wall3.position = CGPoint(x: screenWidth / 1.07 , y: wall3.position.y)
            [wall1,wall2,wall3].forEach {
                addChild($0)}
            break
        case .four:
            wall1.position = CGPoint(x: screenWidth / 1.5, y: wall1.position.y)
            wall2.position = CGPoint(x: screenWidth / 2, y: wall2.position.y)
            wall3.position = CGPoint(x: screenWidth / 3, y: wall3.position.y)
            [wall1,wall2,wall3].forEach {
                addChild($0)}
            break
        case .five:
            wall1.position = CGPoint(x: screenWidth / 3, y: wall1.position.y)
            wall2.position = CGPoint(x: screenWidth / 2, y: wall2.position.y)
            wall3.position = CGPoint(x: screenWidth / 1.07, y: wall3.position.y)
            wall4.position = CGPoint(x: screenWidth / 1.25 , y: wall4.position.y)
            [wall1,wall2,wall3,wall4].forEach {
                addChild($0)}
            break
        case .six:
            wall1.position = CGPoint(x: screenWidth / 5, y: wall1.position.y)
            wall2.position = CGPoint(x: screenWidth / 2, y: wall2.position.y)
            wall3.position = CGPoint(x: screenWidth / 1.25, y: wall3.position.y)
            [wall1,wall2,wall3].forEach {
                addChild($0)}
            break
        }
        addMovement(wall: wall1)
        addMovement(wall: wall2)
        addMovement(wall: wall3)
        addMovement(wall: wall4)
        addMovement(wall: wall5)
    }
    
    func createHUD(){
        scoreLabel = SKLabelNode(fontNamed: "Ubuntu")
        scoreLabel.fontSize = screenWidth / 9.375
        scoreLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scoreLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 1.1)
        scoreLabel.name = "scoreLabel"
        scoreLabel.text = "0"
        scoreLabel.zPosition = 2
        scoreLabel.isHidden = true
        addChild(scoreLabel)
        
        pauseButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "pause")))
        pauseButton.position = CGPoint(x: screenWidth / 1.1, y: screenHeight / 1.1 + 20)
        pauseButton.zPosition = 2
        pauseButton.size = CGSize(width: screenWidth / 9.37, height: screenHeight / 16.67)
        pauseButton.name = "pauseButton"
        pauseButton.isHidden = true
        addChild(pauseButton)
    }
    
    func hideHUD() {
        scoreLabel.isHidden = true
        pauseButton.isHidden = true
    }
    
    func showHUD() {
        scoreLabel.isHidden = false
        pauseButton.isHidden = false
    }
    
    func addTutorial(){
        let toRight = SKAction.moveBy(x: screenWidth, y: 0, duration: 2.0)
        let toLeft = SKAction.moveBy(x: -screenWidth, y: 0, duration: 2.0)
        let repeatForever = SKAction.repeatForever(SKAction.sequence([toRight,toLeft]))
        swipeSprite = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "finger-swipe")))
        swipeSprite.size = CGSize(width: screenWidth / 5, height: screenHeight / 8.9)
        swipeSprite.position = CGPoint(x: 0, y: 70)
        swipeSprite.isHidden = false
        swipeSprite.run(repeatForever)
        addChild(swipeSprite)
    }
    
    func removeTutorial() {
        swipeSprite.removeAllActions()
        swipeSprite.removeFromParent()
    }
}

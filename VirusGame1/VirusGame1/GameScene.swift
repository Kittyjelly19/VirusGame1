//
//  GameScene.swift
//  VirusGame1
//
//  Created by SYMES, BETHAN (Student) on 13/12/2020.
//  Copyright © 2020 SYMES, BETHAN (Student). All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{

    var player:SKSpriteNode!
    var virus:SKSpriteNode!
    var sanitizerBlob:SKSpriteNode!
    var scoreText:SKLabelNode!
    var healthText:SKLabelNode!
    var gameTimerHandle:Timer!
    var virusVariants = ["virus", "virus2"]
    
    
    
    
    var score: Int = 0
    {
        //Updates the score text with the current score value.
        didSet
        {
            scoreText.text = "Score: \(score)"
        }
    }
    
    var health: Int = 100
    {
        didSet
        {
            healthText.text = "Health: \(health)"
        }
    }
    override func didMove(to view: SKView)
    {
        InitScene()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
       
        
    }
    //Properties that allow for each category to have a unique ID to detect collisions.
    let virusCat:UInt32 = 0x1 << 1
    let sanitizerBlobCat:UInt32 = 0x1 << 0
    let playerCat:UInt32 = 0x1 << 2
   
    
    //Initial scene render function.
    func InitScene()
       {
        
        
        //Set background colour of game.
        backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 80/255, alpha: 1.0)
        
        //Spawn scene components
        SpawnPlayer()
        DisplayScore()
        DisplayHealth()
        gameTimerHandle = Timer.scheduledTimer(timeInterval: 1.25, target: self, selector: #selector(SpawnVirus), userInfo: nil, repeats: true)
    }
    
    //Spawn virus function.
    @objc func SpawnVirus()
    {
        virusVariants = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: virusVariants) as! [String]
        let virus = SKSpriteNode(imageNamed: virusVariants[0])
        let randVirusPos = GKRandomDistribution(lowestValue: 20, highestValue: 400)
        let position = CGFloat(randVirusPos.nextInt())
        virus.position = CGPoint(x: position, y: self.frame.size.height + virus.size.height)
        virus.size = CGSize(width: 100, height: 100)
        //virus.position = CGPoint(x: frame.midX, y: frame.maxY - virus.size.height)
       
       
        virus.physicsBody = SKPhysicsBody(circleOfRadius: virus.size.width / 2)
        virus.physicsBody?.isDynamic = true
        
        
        virus.physicsBody?.categoryBitMask = virusCat
        virus.physicsBody?.contactTestBitMask = sanitizerBlobCat
       
        virus.physicsBody?.collisionBitMask = 0
       
        
        self.addChild(virus)
        
        let movementDur:TimeInterval = 8.0
        var movementArray = [SKAction]()
        
        //if(virus.position.x >= frame.maxX) //|| virus.position.x >= frame.minX)
       // {
            //movementArray.append(SKAction.applyImpulse(CGVector(dx:50, dy:50), duration: 2))
       // }
        //movementArray.append(SKAction.applyImpulse(CGVector(dx: 50, dy: 50), duration: 3))
        movementArray.append(SKAction.move(to: CGPoint(x: position, y: -virus.size.height), duration: movementDur))
        movementArray.append(SKAction.removeFromParent())
        
        virus.run(SKAction.sequence(movementArray))
        
    }
    
    //Spawn player function
    func SpawnPlayer()
    {
        //Adding player to scene
        player = SKSpriteNode(imageNamed: "bottle")
        player.position = CGPoint(x: frame.midX, y: frame.minY + player.size.height)
        player.size = CGSize(width:100, height:150)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = playerCat
        player.physicsBody?.contactTestBitMask = virusCat
         player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.collisionBitMask = 0
        
        self.addChild(player)
        self.physicsWorld.contactDelegate = self
    }
    
    //Display Score function
    func DisplayScore()
    {
        scoreText = SKLabelNode(text: "Score: 0")
        scoreText.position = CGPoint(x:100, y:self.frame.size.height - 100)
        scoreText.fontSize = 40
        scoreText.fontColor = UIColor.magenta
        score = 0
        self.addChild(scoreText)
    }
    
    func DisplayHealth()
    {
        healthText = SKLabelNode(text: "Score: 0")
        healthText.position = CGPoint(x:300, y:self.frame.size.height - 100)
        healthText.fontSize = 40
        healthText.fontColor = UIColor.green
        health = 100
        self.addChild(healthText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        ShootSanitizer()
    }
    func ShootSanitizer()
    {
        sanitizerBlob = SKSpriteNode(imageNamed: "sanitizerBlob")
        sanitizerBlob.size = CGSize(width: 75, height:75)
        sanitizerBlob.position = player.position
        sanitizerBlob.position.y  += 5
        
        sanitizerBlob.physicsBody = SKPhysicsBody(circleOfRadius: sanitizerBlob.size.width / 2)
        sanitizerBlob.physicsBody?.isDynamic = true
        
        sanitizerBlob.physicsBody?.categoryBitMask = sanitizerBlobCat
        sanitizerBlob.physicsBody?.contactTestBitMask = virusCat
        sanitizerBlob.physicsBody?.collisionBitMask = 0
        
        sanitizerBlob.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(sanitizerBlob)
        
        let movementDur:TimeInterval = 0.3
        var movementArray = [SKAction]()
        
    
        movementArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: movementDur))
        movementArray.append(SKAction.removeFromParent())
        
        sanitizerBlob.run(SKAction.sequence(movementArray))
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //Checks collision between virus and sanitizer blob.
       if (firstBody.categoryBitMask & sanitizerBlobCat) != 0 && (secondBody.categoryBitMask & virusCat) != 0
       {
            blob_virusCollision(sanitizerBlob: firstBody.node as! SKSpriteNode, virus: secondBody.node as! SKSpriteNode)
        }
        
        if(firstBody.categoryBitMask & virusCat) != 0 && (secondBody.categoryBitMask & playerCat) != 0
        {
            virus_playerCollision(virus: firstBody.node as! SKSpriteNode , player: secondBody.node as! SKSpriteNode)
        }
    }
    
    func virus_playerCollision (virus:SKSpriteNode, player:SKSpriteNode)
    {
        virus.removeFromParent()
        health -= 5
    }
    func blob_virusCollision (sanitizerBlob:SKSpriteNode, virus:SKSpriteNode)
    {
    sanitizerBlob.removeFromParent()
    virus.removeFromParent()
        score += 10
    }
}


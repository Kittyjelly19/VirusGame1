//
//  GameScene.swift
//  VirusGame1
//
//  Created by SYMES, BETHAN (Student) on 13/12/2020.
//  Copyright © 2020 SYMES, BETHAN (Student). All rights reserved.
//

import CoreMotion
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
    var lastPosTouched: CGPoint?
    var gameWallL: SKShapeNode!
    var gameWallR: SKShapeNode!
    var motionHandle: CMMotionManager?
    
    
    
    
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
        //Updates the health text with the current health value.
        didSet
        {
            healthText.text = "Health: \(health)"
        }
    }
   
    
    override func didMove(to view: SKView)
    {
        InitScene()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
       motionHandle = CMMotionManager()
        motionHandle?.startAccelerometerUpdates()
        
    }
    
    //Properties that allow for each category to have a unique ID to detect collisions.
    let virusCat:UInt32 = 0x1 << 1
    let sanitizerBlobCat:UInt32 = 0x1 << 0
    let playerCat:UInt32 = 0x1 << 2
    let LwallCat:UInt32 = 0x1 << 3
    let RwallCat:UInt32 = 0x1 << 4
    
    
    //Initial scene render function.
    func InitScene()
       {
        
        
        //Set background colour of game.
        backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 80/255, alpha: 1.0)
        
        
        //Spawn scene components
        SetPlayerBounds()
        SpawnPlayer()
        DisplayScore()
        DisplayHealth()
        
        gameTimerHandle = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SpawnVirus), userInfo: nil, repeats: true)
    }
    
    //Function to create bounds preventing player from leaving the screen.
    func SetPlayerBounds()
    {
        //Screen left
        let gameWallL = SKShapeNode(rectOf: CGSize(width: 10, height: frame.size.height))
        gameWallL.fillColor = SKColor(red: 45/255, green: 100/255, blue: 80/255, alpha: 0.0)
        gameWallL.strokeColor = SKColor(red: 45/255, green: 100/255, blue: 80/255, alpha: 0.0)
        gameWallL.position = CGPoint(x: frame.minX, y: frame.midY)
        gameWallL.zPosition = 1
        gameWallL.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: frame.size.height))
        gameWallL.physicsBody?.categoryBitMask = LwallCat
        gameWallL.physicsBody?.contactTestBitMask = playerCat
        gameWallL.physicsBody?.isDynamic = false
        addChild(gameWallL)
        
        //Screen right
        let gameWallR = SKShapeNode(rectOf: CGSize(width: 10, height: frame.size.height))
        gameWallR.fillColor = SKColor(red: 45/255, green: 100/255, blue: 80/255, alpha: 0.0)
        gameWallR.strokeColor = SKColor(red: 45/255, green: 100/255, blue: 80/255, alpha: 0.0)
        gameWallR.position = CGPoint(x: frame.maxX, y: frame.midY)
        gameWallR.zPosition = 1
        gameWallR.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: frame.size.height))
        gameWallR.physicsBody?.categoryBitMask = RwallCat
        gameWallR.physicsBody?.contactTestBitMask = playerCat
        gameWallR.physicsBody?.isDynamic = false
        addChild(gameWallR)
    }
    
    
    //Spawn virus function.
    @objc func SpawnVirus()
    {
        virusVariants = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: virusVariants) as! [String]
        let virus = SKSpriteNode(imageNamed: virusVariants[0])
        let randVirusPos = GKRandomDistribution(lowestValue: 0, highestValue: Int(frame.width))
        let position = CGFloat(randVirusPos.nextInt())
        virus.zPosition = 1
        virus.position = CGPoint(x: position, y: frame.size.height + virus.size.width)
        virus.size = CGSize(width: 100, height: 100)
       
        virus.physicsBody = SKPhysicsBody(circleOfRadius: virus.size.width / 2)
        virus.physicsBody?.isDynamic = true
        
        virus.physicsBody?.categoryBitMask = virusCat
        virus.physicsBody?.contactTestBitMask = sanitizerBlobCat
        virus.physicsBody?.collisionBitMask = 0
       
        self.addChild(virus)
        
        let movementDur:TimeInterval = 4.0
        var movementArray = [SKAction]()
        
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
        player.zPosition = 1
        player.size = CGSize(width: 100, height: 150)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(player.size.width / 2))
        player.physicsBody?.allowsRotation = false
       
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = playerCat
        player.physicsBody?.contactTestBitMask = virusCat
        player.physicsBody?.usesPreciseCollisionDetection = true
                    
        
        self.addChild(player)
        self.physicsWorld.contactDelegate = self
    }
    
    //Display Score function
    func DisplayScore()
    {
        scoreText = SKLabelNode(text: "Score: 0")
        scoreText.position = CGPoint(x:self.frame.size.width / 3.45, y:self.frame.size.height - 100)
        scoreText.fontSize = 40
        scoreText.fontColor = UIColor.systemTeal
        score = 0
        self.addChild(scoreText)
    }
    
    
    //Display health function
    func DisplayHealth()
    {
        healthText = SKLabelNode(text: "Score: 0")
        healthText.position = CGPoint (x:self.frame.size.width / 1.35, y:self.frame.size.height - 100)
        healthText.fontSize = 40
        healthText.fontColor = UIColor.green
        health = 100
        self.addChild(healthText)
    }
    
    //Spawn and shoot sanitizer
    func ShootSanitizer()
    {
        sanitizerBlob = SKSpriteNode(imageNamed: "sanitizerBlob")
        sanitizerBlob.size = CGSize(width: 75, height:75)
        sanitizerBlob.position = player.position
        sanitizerBlob.zPosition = 0
        sanitizerBlob.position.y  += 40
        
        sanitizerBlob.physicsBody = SKPhysicsBody(circleOfRadius: sanitizerBlob.size.width / 2)
        sanitizerBlob.physicsBody?.isDynamic = true
        
        sanitizerBlob.physicsBody?.categoryBitMask = sanitizerBlobCat
        sanitizerBlob.physicsBody?.contactTestBitMask = virusCat
       
        sanitizerBlob.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(sanitizerBlob)
        
        let movementDur:TimeInterval = 0.5
        var movementArray = [SKAction]()
        
    
        movementArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: movementDur))
        movementArray.append(SKAction.removeFromParent())
        
        sanitizerBlob.run(SKAction.sequence(movementArray))
    }
    
    //Setting contact bodies.
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
        
        //Checks collision between virus and player
        if(firstBody.categoryBitMask & virusCat) != 0 && (secondBody.categoryBitMask & playerCat) != 0
        {
            virus_playerCollision(virus: firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    //What happens when player collides with virus.
    func virus_playerCollision (virus:SKSpriteNode, player:SKSpriteNode)
    {
        virus.removeFromParent()
        health -= 10
        if(health <= 0)
        {
            GameOver()
        }
    }
    
    //What happens when the sanitizer collides with a virus
    func blob_virusCollision (sanitizerBlob:SKSpriteNode, virus:SKSpriteNode)
    {
    sanitizerBlob.removeFromParent()
    virus.removeFromParent()
        score += 10
    }
   
    //Update function
    override func update(_ currentTime: TimeInterval)
    {
        //Keeps player y pos the same throughout the game.
        player.position.y = frame.minY + player.size.height
        
        //#if for running on simulator or on a device.
        #if targetEnvironment(simulator)
       
        //Use touch to replicate tilt.
        if let lastPosTouched = lastPosTouched
        {
            let diff = CGPoint(x: lastPosTouched.x - player.position.x, y: 0)
            
            
            player.physicsBody?.velocity = CGVector(dx: diff.x, dy: 0)
           
            
        }
       
        #else
        //Use accelerometer data.
       if let accelerometerData = motionHandle?.accelerometerData
        {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft && player.position.x >= self.frame.minX + player.size.width
            {
                
                player.physicsBody?.velocity = CGVector(dx: accelerometerData.acceleration.x * -500, dy: 0)
            }
            else
            {
                player.physicsBody?.velocity = CGVector(dx: accelerometerData.acceleration.x * 500, dy: 0)
            }
        }
        #endif
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //For finding touch position to simulate tilt.
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        lastPosTouched = location
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //For finding touch position to simulate tilt.
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        lastPosTouched = location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //Touch for shooting and tilt simulation.
        ShootSanitizer()
        lastPosTouched = nil
    }
    
    
    //What happens when the game is over
    func GameOver()
    {
        //Setting the score and high score for the menu and storing the vaules.
        UserDefaults.standard.set(score, forKey: "YourScore")
        if score > UserDefaults.standard.integer(forKey: "HighScore")
        {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
}


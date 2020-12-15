//
//  GameScene.swift
//  VirusGame1
//
//  Created by SYMES, BETHAN (Student) on 13/12/2020.
//  Copyright © 2020 SYMES, BETHAN (Student). All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var player:SKSpriteNode!
    var virus:SKSpriteNode!
    var sanitizerBlob:SKSpriteNode!
    var scoreText:SKLabelNode!
    var gameTimerHandle:Timer!
    var virusVariants = ["ball", "ColorCircle"]
    
    
    
    var score: Int = 0
    {
        //Updates the score text with the current score value.
        didSet
        {
            scoreText.text = "Score: \(score)"
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
    
    
    //Initial scene render function.
    func InitScene()
       {
        
        //Set a border around the screen to prevent virus from leaving screen.
        //let border = SKPhysicsBody(edgeLoopFrom: self.frame)
       // border.friction = 0
       // border.restitution = 1
       // self.physicsBody = border
        
        //Set background colour of game.
        backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 80/255, alpha: 1.0)
        
        //Spawn scene components
        SpawnPlayer()
        DisplayScore()
        
        gameTimerHandle = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SpawnVirus), userInfo: nil, repeats: true)
    }
    
    //Spawn virus function.
    @objc func SpawnVirus()
    {
        virusVariants = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: virusVariants) as! [String]
        let virus = SKSpriteNode(imageNamed: virusVariants[0])
        let randVirusPos = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let position = CGFloat(randVirusPos.nextInt())
        virus.position = CGPoint(x: position, y: self.frame.size.height + virus.size.height)
        virus.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        //virus.position = CGPoint(x: frame.midX, y: frame.maxY - virus.size.height)
       
        virus.physicsBody = SKPhysicsBody(circleOfRadius: virus.size.width / 2)
        virus.physicsBody?.isDynamic = true
        
        virus.physicsBody?.categoryBitMask = virusCat
        virus.physicsBody?.contactTestBitMask = sanitizerBlobCat
        virus.physicsBody?.collisionBitMask = 0
        
        self.addChild(virus)
        
        let movementDur:TimeInterval = 6.0
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
        player.size = CGSize(width: frame.size.width/2.5, height: frame.size.width/2.5)
        player.position = CGPoint(x: frame.midX, y: frame.minY + player.size.height)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        ShootSanitizer()
    }
    func ShootSanitizer()
    {
        sanitizerBlob = SKSpriteNode(imageNamed: "ball")
        sanitizerBlob.size = CGSize(width: 20, height:20)
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
}

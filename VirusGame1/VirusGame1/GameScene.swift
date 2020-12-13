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
    var scoreText:SKLabelNode!
    var gameTimerHandle:Timer!
    var virusVariants = ["ball", "ColorCircle"]
    
    //Properties that allow for each category to have a unique ID to detect collisions.
    let virusCat:UInt32 = 0x1 << 1
    let sanitizerBullet:UInt32
    
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
    
    //Initial scene render function.
    func InitScene()
       {
        
        //Set a border around the screen to prevent virus from leaving screen.
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
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
         self.addChild(virus)
    }
    
    //Spawn player function
    func SpawnPlayer()
    {
        //Adding player to scene
        player = SKSpriteNode(imageNamed: "ball")
        player.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
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
}

//
//  GameScene.swift
//  VirusGame1
//
//  Created by SYMES, BETHAN (Student) on 13/12/2020.
//  Copyright © 2020 SYMES, BETHAN (Student). All rights reserved.
//

import SpriteKit


class GameScene: SKScene
{
    var player:SKSpriteNode!
    var virus:SKSpriteNode!
    var scoreText:SKLabelNode!
    
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
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
         backgroundColor = UIColor(red: 44/255, green: 40/255, blue: 80/255, alpha: 1.0)
        
        SpawnPlayer()
        SpawnVirus()
        
    }
    
    //Spawn virus function.
    func SpawnVirus()
    {
        virus = SKSpriteNode(imageNamed: "ball")
        virus.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        virus.position = CGPoint(x: frame.midX, y: frame.maxY - virus.size.height)
       
        let ballcol = SKPhysicsBody(circleOfRadius: virus.size.width)
        self.physicsBody = ballcol
        virus.physicsBody?.applyImpulse(CGVector(dx:0, dy: -20))
         self.addChild(virus)
    }
    func SpawnPlayer()
    {
        //Adding player to scene
        player = SKSpriteNode(imageNamed: "ball")
        player.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        player.position = CGPoint(x: frame.midX, y: frame.minY + player.size.height)
        self.addChild(player)
    }
}

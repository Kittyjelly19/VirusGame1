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
    
    override func didMove(to view: SKView)
    {
        InitScene()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
       
        
    }
    //Initial scene render function.
    func InitScene()
       {
        
        backgroundColor = UIColor(red: 44/255, green: 40/255, blue: 80/255, alpha: 1.0)
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        //Adding player to scene
        player = SKSpriteNode(imageNamed: "ball")
        player.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        player.position = CGPoint(x: frame.midX, y: frame.minY + player.size.height)
        self.addChild(player)
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
}

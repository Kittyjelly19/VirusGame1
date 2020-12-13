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
    
    override func didMove(to view: SKView)
    {
        initScene()
       
        
    }
       func initScene()
       {
        
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        player = SKSpriteNode(imageNamed: "ball")
        player.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
               player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
               self.addChild(player)
        
    }
        
}

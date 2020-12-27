//
//  MenuScene.swift
//  VirusGame1
//
//  Created by SYMES, BETHAN (Student) on 27/12/2020.
//  Copyright © 2020 SYMES, BETHAN (Student). All rights reserved.
//
import SpriteKit
//import UIKit

class MenuScene: SKScene
{
    var virusImage: SKSpriteNode!
    var virusGameText: SKLabelNode!
    var playGameText: SKLabelNode!
    var highScoreText: SKLabelNode!
    var yourScoreText: SKLabelNode!
    
    override func didMove(to view: SKView)
    {
        InitMenu()
    }
    
    func InitMenu()
    {
        backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 80/255, alpha: 1.0)
        DisplayGameNameandImage()
        DisplayHighScore()
        DisplayYourScore()
        DisplayPlayGameLabel()
    }
    func DisplayHighScore()
    {
        highScoreText = SKLabelNode(text:"High Score:" + "\(UserDefaults.standard.integer(forKey: "HighScore"))")
        highScoreText.position = CGPoint(x: self.frame.maxX / 2, y: self.frame.maxY / 1.1)
        highScoreText.fontSize = 40
        highScoreText.fontColor = UIColor.magenta
        addChild(highScoreText)
    }
    func DisplayYourScore()
    {
        yourScoreText = SKLabelNode(text:"Your Score:" + "\(UserDefaults.standard.integer(forKey: "YourScore"))")
        yourScoreText.position = CGPoint(x: self.frame.maxX / 2, y: self.frame.maxY / 1.25)
        yourScoreText.fontSize = 40
        yourScoreText.fontColor = UIColor.magenta
        addChild(yourScoreText)
    }
    func DisplayPlayGameLabel()
    {
        virusGameText = SKLabelNode(text:"Tap Screen To Play!")
        virusGameText.position = CGPoint(x: self.frame.maxX / 2, y: self.frame.maxY / 2.5)
        virusGameText.fontSize = 40
        virusGameText.fontColor = UIColor.green
        addChild(virusGameText)
    }
    func DisplayGameNameandImage()
    {
        virusImage = SKSpriteNode(imageNamed: "virus")
        virusImage.size = CGSize(width: 200, height: 200)
        virusImage.position = CGPoint(x: self.frame.maxX / 2, y: self.frame.maxY / 1.5)
        addChild(virusImage)
        
        virusGameText = SKLabelNode(text:"The Virus Game")
        virusGameText.position = CGPoint(x: self.frame.maxX / 2, y: self.frame.maxY / 2)
        virusGameText.fontSize = 40
        virusGameText.fontColor = UIColor.magenta
        addChild(virusGameText)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
}

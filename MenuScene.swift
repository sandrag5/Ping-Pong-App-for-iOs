//
//  MenuScene.swift
//  Ping Pong Game
//
//  Created by Sandra GS on 30/04/2018.
//  Copyright © 2018 Sandra GS. All rights reserved.
//


import SpriteKit                //Framework to create 2D games

class MenuScene: SKScene {
    
    //Scene elements
    var hs0:SKLabelNode!
    var hs1:SKLabelNode!
    var hs2:SKLabelNode!
    var velBallSel:SKLabelNode!
    
    //High scores variables
    var firstHighSc:Int=0
    var secondHighSc:Int=0
    var thirdHighSc:Int=0
    
    //System saved values
    let firstHsDef = UserDefaults.standard
    let secondHsDef = UserDefaults.standard
    let thirdHsDef = UserDefaults.standard
    
    //Config variables
    var selVel:Int=0 //Velocity of the ball
    var gameSel:Int=0  //Difficulty of the game

    override func didMove(to view: SKView) {
        //Called after the view controller is added/removed from a container view controller
        
        // Get nodes from the MenuScene and store them
        velBallSel = self.childNode(withName: "velBallSel") as! SKLabelNode
        
        hs0 = self.childNode(withName: "hs0") as! SKLabelNode
        hs1 = self.childNode(withName: "hs1") as! SKLabelNode
        hs2 = self.childNode(withName: "hs2") as! SKLabelNode
        
        velBallSel.text = "normal"  //Default text
        
        //Initialize variables with the last saved values (if not null)
        if(firstHsDef.value(forKey: "firstHS") != nil) {
            firstHighSc = firstHsDef.value(forKey: "firstHS") as! Int
            hs0.text = "USER   \(firstHighSc) - 3   CPU"
        }
        
        if(secondHsDef.value(forKey: "secondHS") != nil) {
            secondHighSc = secondHsDef.value(forKey: "secondHS") as! Int
            hs1.text = "USER   \(secondHighSc) - 3   CPU"
        }
        
        if(thirdHsDef.value(forKey: "thirdHS") != nil) {
            thirdHighSc = thirdHsDef.value(forKey: "thirdHS") as! Int
            hs2.text = "USER   \(thirdHighSc) - 3   CPU"
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Represent the touches for the starting event - only one touch -
        
        let touch = touches.first   //One touch received
        
        if let location = touch?.location(in: self) {   //Location of the touch
            
            let nodesArray = self.nodes(at: location)   //Nodes from Scene
            
            
            if nodesArray.first?.name == "easyButton" {
                //If "easy" is clicked
                
                gameSel=0
                startGame(levelSelected: gameSel, velocitySelected: selVel)
                
            } else if nodesArray.first?.name == "normalButton" {
                //If "normal" is clicked
                
                gameSel=1
                startGame(levelSelected: gameSel, velocitySelected: selVel)
                
            } else if nodesArray.first?.name == "hardButton"{
                //If "hard" is clicked
                
                gameSel=3
                startGame(levelSelected: gameSel, velocitySelected: selVel)
                
            } else if nodesArray.first?.name == "velBallSel" {
                //If the velocity is clicked
                changeVelocity()
                
            }
            
        }
        
    }
    
    
    func startGame(levelSelected:Int, velocitySelected:Int){
        //Start the game for a level and a ball velocity selected by the user
        
        //Play sound
        self.run(SKAction.playSoundFileNamed("clicked.mp3", waitForCompletion: false))
        
        //Change to GameScene
        if let gameScene = GameScene(fileNamed: "GameScene"){
            
            //Scale the scene to fit
            gameScene.scaleMode = .aspectFill
            
            //Initialize these variables in "gameScene" with their actual values
            gameScene.selVel=self.selVel
            gameScene.gameSel=self.gameSel
            
            //Present GameScene
            self.view?.presentScene(gameScene)
        }
    }
    
    
    func changeVelocity() {
        //To change the velocity of the ball
        
        if velBallSel.text == "low"
        {
            selVel=0 //Normal velocity
            
            //Play sound when change the velocity
            self.run(SKAction.playSoundFileNamed("clicked.mp3", waitForCompletion: false))
            velBallSel.text = "normal"
        }
        else if velBallSel.text == "fast"
        {
            selVel=1 //Low velocity
            
            //Play sound when change the velocity
            self.run(SKAction.playSoundFileNamed("clicked.mp3", waitForCompletion: false))
            velBallSel.text = "low"
        }
        else
        {
            selVel=2 //Fast velocity
            
            //Play sound when change the velocity
            self.run(SKAction.playSoundFileNamed("clicked.mp3", waitForCompletion: false))
            velBallSel.text = "fast"
        }
    }

}

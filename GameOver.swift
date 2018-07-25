//
//  GameOver.swift
//  Ping Pong Game
//
//  Created by Sandra GS on 01/05/2018.
//  Copyright © 2018 Sandra GS. All rights reserved.
//

import SpriteKit                //Framework to create 2D games

class GameOver: SKScene {
    
    //Score variables
    var usScore:Int=0
    var cpuScore:Int=0
    
    //High scores variables
    var firstHighSc:Int=0
    var secondHighSc:Int=0
    var thirdHighSc:Int=0
    
    var highScoresUs = [Int]()

    //Variables for the scene elements
    var finalScore:SKLabelNode!
    var playAgain:SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        //Called after the view controller is added/removed from a container view controller
        
        // Get nodes from the GameOver scene and store them
        finalScore = self.childNode(withName: "finalScore") as! SKLabelNode
        playAgain = self.childNode(withName: "playAgain") as! SKLabelNode
        
        //Set the text of the label
        finalScore.text = "USER   \(usScore) - \(cpuScore)   CPU"
        
        //Compare this final score with the top 3 high scores
        compHighScores(userScore: usScore)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Represent the touches for the starting event - only one touch -
        
        for touch in touches {  //For the touch received
            
            let location = touch.location(in: self) //Location of the touch
            let nodesArray = self.nodes(at: location) //Nodes from Scene
            
            //If "Play Again" buttom is clicked
            if nodesArray.first?.name == "playAgain" {
                //Change to MenuScene
                if let menuScene = MenuScene(fileNamed: "MenuScene"){
                    //Fit the scene to the screen
                    menuScene.scaleMode = .aspectFill
                    //Present the scene with the crossfade transition
                    self.view?.presentScene(menuScene)
                }
            }
            
        }
    }
    
    
    func compHighScores(userScore:Int) {
        //To compare the final score with the top 3 high scores and save the best 3 in the App data
        
        //To control the comparison
        var searchEnd:Bool = false
        
        //To save the values in the system
        let firstHsDef = UserDefaults.standard
        let secondHsDef = UserDefaults.standard
        let thirdHsDef = UserDefaults.standard
        
        //Initialize variables with the last saved values (if not null)
        
        if(firstHsDef.value(forKey: "firstHS") != nil) {
            firstHighSc = firstHsDef.value(forKey: "firstHS") as! Int
        }
        
        if(secondHsDef.value(forKey: "secondHS") != nil) {
            secondHighSc = secondHsDef.value(forKey: "secondHS") as! Int
        }
        
        if(thirdHsDef.value(forKey: "thirdHS") != nil) {
            thirdHighSc = thirdHsDef.value(forKey: "thirdHS") as! Int
        }
        
        //If search has no ended, compare the score with the top 3 scores
        if(searchEnd == false && usScore > firstHighSc)
        {
            //If it's higher than the 1st one
            searchEnd = true    //End search
            
            //Move the high scores
            thirdHighSc = secondHighSc
            secondHighSc = firstHighSc
            //Save the actual score in the 1st position
            firstHighSc = usScore
        }
        else if (searchEnd == false && usScore > secondHighSc)
        {
            //If it's higher than the second score
            searchEnd = true //End search
            
            thirdHighSc = secondHighSc //Move score to the 3rd position
            secondHighSc = usScore  //Save score in the 2nd position
        }
        else if (searchEnd == false && usScore > thirdHighSc)
        {
            searchEnd = true //End search
            
            thirdHighSc = usScore //Save score in the 3rd position
        }
        else
        {
            //If it's not higher than any of the top 3 scores, end search
            searchEnd = true
        }
        
        //Set the new values
        firstHsDef.set(firstHighSc, forKey: "firstHS")
        secondHsDef.set(secondHighSc, forKey: "secondHS")
        thirdHsDef.set(thirdHighSc, forKey: "thirdHS")
        
        //Synchronize values
        firstHsDef.synchronize()
        secondHsDef.synchronize()
        thirdHsDef.synchronize()
        
    }

    
}

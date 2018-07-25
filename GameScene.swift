//
//  GameScene.swift
//  Ping Pong Game
//
//  Created by Sandra GS on 30/04/2018.
//  Copyright © 2018 Sandra GS. All rights reserved.
//

import SpriteKit       //Framework to create 2D games
import GameplayKit     //Collection to design game architecture

class GameScene: SKScene {
    
    
    //Game elements (scene elements)
    var ball:SKSpriteNode! //Moving ball
    var cpu:SKSpriteNode! //CPU moving paddle
    var user:SKSpriteNode! //User moving paddle
    
    
    //Points label
    var userPoints:SKLabelNode!
    
    //Score variables
    var usScore:Int = 0 { //User
        didSet {
            //Print value every time it's modified
            userPoints.text = "Points: \(usScore)"
        }
    }
    var cpuScore:Int = 0 //CPU
    
    
    var selVel:Int=0 //Velocity Selected in Menu
    var gameSel:Int=0 //Game Selected in Menu
    
    override func didMove(to view: SKView) {
        //Called after the view controller is added/removed from a container view controller
        
        // Get nodes from the GameScene and store them
        userPoints = self.childNode(withName: "userPoints") as! SKLabelNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        cpu = self.childNode(withName: "cpuPaddle") as! SKSpriteNode
        user = self.childNode(withName: "userPaddle") as! SKSpriteNode
        
        // The game starts when the balls starts to move at the velocity user selected in Menu
        startGame(selectedVel: selVel)
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Represent the touches for the starting event - only one touch -
        
        for touch in touches{                       //For the touch received
            
            let location = touch.location(in: self) //Location of the touch
            
            //Move paddle on the x coordinate of the location with 0.1 delay
            user.run(SKAction.moveTo(x: location.x, duration: 0.1))
            
        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Represent the touches whose values changed - for one touch -
        //Same as touchesBegan
        
        for touch in touches{
            let location = touch.location(in: self)
            
            user.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
        
    }
    
    
    func selectGame(gameSelected:Int){
        //Set the velocity of the CPU paddle depending on the difficulty selected by the user
        
        if gameSel == 0 {
            //Normal
            //CPU paddle moves on the x coordinate depending on the ball position with a delay
            cpu.run(SKAction.moveTo(x: ball.position.x, duration: 0.4))
        } else if gameSel == 2 {
            //Fast
            cpu.run(SKAction.moveTo(x: ball.position.x, duration: -0.2))
        } else {
            //Low
            cpu.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
        }
        
    }
    
    
    func startGame(selectedVel:Int){
        //The game starts when the ball starts to move
        
        //Creates an edge loop from the frame
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0 //Friction to 0
        border.restitution = 1 //Ideal: no energy lost
        self.physicsBody = border //Set the limit
        
        //The ball will first be impulsed to the user direction (negative impulse)
        ballVel_NegImp(selectedVel:selVel)
        
        //Apply impulse to the center of gravity of the ball in dx,dy direction
        ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Difficulty depending on the game selected by the user
        selectGame(gameSelected: gameSel)
        
        //If ball is below user position - cpu scored
        if ball.position.y <= user.position.y-30
        {
            //Update score for cpu and check if game over
            updateScore(winner: cpu)
            //Play sound file
            self.run(SKAction.playSoundFileNamed("ball.mp3", waitForCompletion: false))
        }
            //if ball is above cpu position - user scored
        else if ball.position.y >= cpu.position.y+30
        {
            //Update score for user
            updateScore(winner: user)
            //Play sound file
            self.run(SKAction.playSoundFileNamed("ball2.mp3", waitForCompletion: false))
        }
        
    }
    
    
    func updateScore(winner: SKSpriteNode){
        //Update the score for the winner of the actual round and checks if the game has to end
        
        //Each time someone scores, the ball is reseted to 0,0 position
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if winner == user  //If the user wins
        {
            //The user score is incremented by 1
            usScore+=1
            
            //The ball moves in the loser direction (positive - cpu)
            ballVel_PosImp(selectedVel: selVel)
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        }
        else if winner == cpu   //If cpu wins
        {
            //CPU score is incremented by 1
            cpuScore+=1
            
            //Check if the player has lost 3 points against the CPU to end the game
            if cpuScore == 3
            {
                //Play the game over sound
                self.run(SKAction.playSoundFileNamed("over.mp3", waitForCompletion: true))
                //Create a crossfade transition to the next scene
                let transitionGO = SKTransition.crossFade(withDuration: 0)
                //Move to gameOver scene
                if let gameOver = GameOver(fileNamed: "GameOver"){
                
                    //Initialize these variables in "gameOver" with their actual values
                    gameOver.usScore = self.usScore
                    gameOver.cpuScore = self.cpuScore
                    
                    //Fit the scene to the screen
                    gameOver.scaleMode = .aspectFill
                    
                    //Change to gameOver scene with the crossFade transition
                    self.view?.presentScene(gameOver, transition: transitionGO)
                }
                
            }
            else //if not
            {
                //The ball moves in the loser direction (negative - user)
                ballVel_NegImp(selectedVel: selVel)
                ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
            }
        }
        
    }
   
    
    func ballVel_NegImp(selectedVel:Int){
        //Move the ball at the velocity selected by the user in Menu for a negative impulse
        
        if (selVel==1) {
            //Low
            ball.physicsBody?.velocity = CGVector(dx: 200, dy: 200)
        } else if (selVel==2){
            //Fast
            ball.physicsBody?.velocity = CGVector(dx: -200, dy: -200)
        } else {
            //Normal
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
    }
    
    
    func ballVel_PosImp(selectedVel:Int){
        //Move the ball at the velocity selected by the user in Menu for a positive impulse
        
        if (selVel==1) {
            //Low
            ball.physicsBody?.velocity = CGVector(dx: -200, dy: -200)
        } else if (selVel==2){
            //Fast
            ball.physicsBody?.velocity = CGVector(dx: 200, dy: 200)
        } else {
            //Normal
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
    }
    
    
}

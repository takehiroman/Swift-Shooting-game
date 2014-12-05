//
//  GameScene.swift
//  swiftsimplegame
//
//  Created by zakimoto on 2014/12/05.
//  Copyright (c) 2014年 津崎 豪宏. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
		
		let sprite = SKSpriteNode(imageNamed:"Spaceship")
		
		sprite.xScale = 0.5
		sprite.yScale = 0.5
		sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
		
		self.addChild(sprite)
            }
	
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
			
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

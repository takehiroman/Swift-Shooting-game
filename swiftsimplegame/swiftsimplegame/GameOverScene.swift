//
//  GameOverScene.swift
//  swiftsimplegame
//
//  Created by zakimoto on 2014/12/12.
//  Copyright (c) 2014年 津崎 豪宏. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
	
	override func didMoveToView(view: SKView) {
		
		// スコアとハイスコアをユーザデフォルトから取っておく。
		let ud = NSUserDefaults.standardUserDefaults()
		var score = ud.integerForKey("score")
		var hi_score = ud.integerForKey("hi_score")
		
		// スコアを表示
		let scoreLabel = SKLabelNode(fontNamed:"Copperplate")
		scoreLabel.text = "SCORE:\(score)";
		scoreLabel.fontSize = 72;
		scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
		self.addChild(scoreLabel)
		
		
		// スコアがハイスコアを上回ったら、ハイスコアを更新！
		if score > hi_score {
			ud.setInteger(score, forKey: "hi_score")
			hi_score = score
		}
		
		// ハイスコアを表示。
		let hiLabel = SKLabelNode(fontNamed:"Copperplate")
		hiLabel.text = "過去最高得点:\(hi_score)";
		hiLabel.fontSize = 36;
		hiLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-100);
		self.addChild(hiLabel)
		
		// 戻るための「Back」ラベルを作成。
		let backLabel = SKLabelNode(fontNamed: "Copperplate")
		backLabel.text = "Back"
		backLabel.fontSize = 36
		backLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 200)
		backLabel.name = "Back"
		self.addChild(backLabel)
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		
		let touch: AnyObject = touches.anyObject()!
		let location = touch.locationInNode(self)
		let touchedNode = self.nodeAtPoint(location)
		
		if (touchedNode.name != nil) {
			if touchedNode.name == "Back" {
				
				let newScene = GameScene(size: self.scene.size)
				newScene.scaleMode = SKSceneScaleMode.AspectFill
				self.view.presentScene(newScene)
			}
		}
	}
	override func update(currentTime: CFTimeInterval) {}
}

//
//  GameScene.swift
//  swiftsimplegame
//
//  Created by zakimoto on 2014/12/05.
//  Copyright (c) 2014年 津崎 豪宏. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	//グローバル変数
	var sprite: SKSpriteNode!
	var beganPos: CGPoint!
	var startPos: CGPoint!
	var last:CFTimeInterval!
	
    override func didMoveToView(view: SKView) {
		//プレイヤーノード
		sprite = SKSpriteNode(imageNamed:"Spaceship")
		
		sprite.xScale = 0.3
		sprite.yScale = 0.3
		sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)/3);
		
		self.addChild(sprite)
		
		
		//初期座標
		startPos = CGPointMake(
			sprite.position.x,
			sprite.position.y
		)
            }
	//バレットノード
	// 赤い丸を、プレイヤーから上に向かって打ち出すメソッド
	func shoot() {
		let bullet = SKSpriteNode(imageNamed:"bullet")
		bullet.position = CGPoint(x: sprite.position.x, y: sprite.position.y + 40)
		bullet.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(40, 40))
		bullet.physicsBody?.affectedByGravity = false
		bullet.physicsBody?.velocity = CGVectorMake(0, 200)
		bullet.physicsBody?.linearDamping = 0.0
		self.addChild(bullet)
	}
	//画面にタッチした時
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
		let touch: AnyObject! = touches.anyObject()
		beganPos = touch.locationInNode(self)
		
	}
	//画面をスライドした時
	override func touchesMoved(touches: (NSSet!), withEvent event: UIEvent) {
		//変数タッチ
		let touch: AnyObject! = touches.anyObject()
		//
		var movedPos:CGPoint = touch.locationInNode(self)
		
		//移動後の座標から移動前の座標を引いた数値
		var diffPos:CGPoint = CGPointMake(
			movedPos.x - beganPos.x,
			0
		)
		sprite.position = CGPointMake(
			startPos.x + diffPos.x,
			startPos.y + diffPos.y
			
		)
	}
	//画面から指を離した時
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		
		startPos = CGPointMake(sprite.position.x, sprite.position.y)
	}
	
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
		// lastが未定義ならば、今の時間を入れる。
		if !(last != nil) {
			last = currentTime
		}
		
		// 0.5秒おきに行う処理をかく。
		if last + 1 <= currentTime {
			
			self.shoot()
			
			last = currentTime
		}
    }
}

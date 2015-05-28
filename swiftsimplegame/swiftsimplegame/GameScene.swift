//
//  GameScene.swift
//  swiftsimplegame
//
//  Created by zakimoto on 2014/12/05.
//  Copyright (c) 2014年 津崎 豪宏. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene,SKPhysicsContactDelegate {
	//グローバル変数
	var sprite: SKSpriteNode!
	var beganPos: CGPoint!
	var startPos: CGPoint!
    var width: Int!
	var scoreLabelNode = SKLabelNode();
	var score = NSInteger();
	
	// インターバルを用意する。
	var lastEnemy: CFTimeInterval!
	var lastBullet: CFTimeInterval!

	
    // カテゴリを用意しておく。
    let bulletCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
	
    override func didMoveToView(view: SKView) {
		
		// contactDelegateをselfにしておく。
		self.physicsWorld.contactDelegate = self

		
		//プレイヤーノード
		sprite = SKSpriteNode(imageNamed:"Spaceship")
		sprite.xScale = 0.3
		sprite.yScale = 0.3
		sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)/3)
		self.addChild(sprite)
		
		//初期座標
		startPos = CGPointMake(
			sprite.position.x,
			sprite.position.y
		)

		
		//スコアラベルノード
		score = 0
		scoreLabelNode = SKLabelNode(fontNamed: "Calibri")
		scoreLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), 3*self.frame.size.height/4 + 100)
		scoreLabelNode.zPosition = 50
		scoreLabelNode.text = String(score)
		self.addChild(scoreLabelNode)

		
        // 画面の幅をIntでとる。
        self.width = 300
        
        
		            }
	//バレットノード
	// 赤い丸を、プレイヤーから上に向かって打ち出すメソッド
	
	func shoot() {
		let bullet = SKSpriteNode(imageNamed:"bullet")
		bullet.position = CGPoint(x: sprite.position.x, y: sprite.position.y + 40)
		bullet.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(10, 10))
		bullet.physicsBody?.affectedByGravity = false
		bullet.physicsBody?.velocity = CGVectorMake(0, 200)
		bullet.physicsBody?.linearDamping = 0.0
		self.addChild(bullet)
        
        // カテゴリを設定する。
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = enemyCategory
	}
    //エネミーノード
    // ここで敵を発生させるメソッドを用意する。
    func createEnemy(x: UInt) {
        
        let enemy = SKSpriteNode(imageNamed:"circleNode")
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(40, 40))
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.linearDamping = 0.0
        enemy.physicsBody?.velocity = CGVectorMake(0, -120)
        
        // カテゴリを設定する。
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = bulletCategory
        
        enemy.position = CGPoint(
            x: CGFloat(x),
            y: CGRectGetMaxY(self.frame)
        )
        self.addChild(enemy)
    }
    
	//画面にタッチした時
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
		if let touch = touches.first as? UITouch{
		beganPos = touch.locationInNode(self)
		}
	}
	//画面をスライドした時
	override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
		//変数タッチ
		if let touch = touches.first as? UITouch{
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
	}
	//画面から指を離した時
	override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		
		startPos = CGPointMake(sprite.position.x, sprite.position.y)
	}
	//画面内でアップデート
    override func update(currentTime: CFTimeInterval) {
		
		if !(lastEnemy != nil){
			lastEnemy = currentTime
		}
		if !(lastBullet != nil) {
			lastBullet = currentTime
		}
		
		// 0.8秒おきに弾を発射する処理をかく。
		if lastBullet + 0.8 <= currentTime {
			self.shoot()
			lastBullet = currentTime
		}
		
		// 1秒おきに敵を落とす処理をかく。
		if lastEnemy + 1 <= currentTime {
			
			
            
            // 敵が生成されるx軸の位置をきめる。
            // センターから、「0<=乱数<=幅」なる乱数を足して、幅の半分を引く。
            var xEnemyPos: UInt! = UInt(CGRectGetMidX(self.frame))
                + UInt(arc4random_uniform(UInt32(self.width)))
                - UInt(self.width / 2)
            
            self.createEnemy(xEnemyPos)
			
			lastEnemy = currentTime
		}
		
		    }


    
    //衝突したとき。
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody, secondBody: SKPhysicsBody
        
        // firstを弾、secondを敵とする。
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 弾と敵が接したときの処理。
        if firstBody.categoryBitMask & bulletCategory != 0 &&
            secondBody.categoryBitMask & enemyCategory != 0 {
                firstBody.node?.removeFromParent()
                secondBody.node?.removeFromParent()
				score++
				scoreLabelNode.text = String(score)

				
        }
    }
}

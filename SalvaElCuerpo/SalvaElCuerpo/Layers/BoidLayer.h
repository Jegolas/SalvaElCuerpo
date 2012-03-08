//
//  BoidLayer.h
//
//  Created by Jon on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"
#import "Boid.h"
//#import "BodyInfo.h"


@interface BoidLayer : CCLayerColor {
	Boid* _flockEnemyPointer; // This is a cheap style linked list
	Boid* _flockPlayerPointer; // This is a cheap style linked list
	CCSpriteBatchNode* _sheet;
	CGPoint _currentTouch;
@public
	CCSpriteBatchNode* _playerSheet;
}
@property(nonatomic, retain) Boid* _flockEnemyPointer;
@property(nonatomic, retain) Boid* _flockPlayerPointer;
@property(nonatomic, assign) CCSpriteBatchNode* _sheet;
@property(nonatomic, assign) CCSpriteBatchNode* _playerSheet;
@property(nonatomic, assign) CGPoint _currentTouch;
-(id)CreateBoids:(int) BoidCount;
-(void) CreateBoidPlayers:(b2World *) world PlayerNumbers:(int) playerNumbers;
-(void) CreateEnemyPlayers:(b2World *) world PlayerNumbers:(int) playerNumbers;
-(void) UpdateBoids;
-(void) UpdateBoids: (CGPoint) location;
-(void) UpdateBoidsMenu;
@end

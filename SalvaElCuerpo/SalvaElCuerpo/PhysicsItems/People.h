//
//  People.h
//  SalvaElCuerpo
//
//  Created by Jon on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "BodyInfo.h"

@interface People : CCSprite
{
    b2Body*	_body;
    CCSpriteBatchNode* _batch1;
}

@property(nonatomic, assign) b2Body* body;
@property(nonatomic, assign) CCSpriteBatchNode* batch1;

-(void)CreatePerson:(b2World *) world  spawnPoint:(CGPoint) spawnPoint;
//-(id) initWithWorld:(b2World *) world spawnPoint:(CGPoint) spawnPoint : (CCSpriteBatchNode*)spriteBatch:(NSString*)spriteFrameName;
//-(id) spriteWithSpriteFrameName:(NSString*)spriteFrameName;
-(void)update;
@end

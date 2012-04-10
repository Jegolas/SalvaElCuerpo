//
//  BananaBoat.h
//  SalvaElCuerpo
//
//  Created by Jon on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "BodyInfo.h"
#import "Constants.h"

@interface BananaBoat : CCSprite
{
    b2Body*	_body;
    CCSpriteBatchNode* _batch1;
}

@property(nonatomic, assign) b2Body* body;
@property(nonatomic, assign) CCSpriteBatchNode* batch1;

-(void)CreateBBoat:(b2World *) world  spawnPoint:(CGPoint) spawnPoint;
-(void)update;

@end

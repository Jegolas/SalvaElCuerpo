//
//  GameLayer.h
//  SalvaElCuerpo
//
//  Created by Jon on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "BoidLayer.h"

@interface GameLayer : CCLayer
{
    float sw;
    float sh;
    BoidLayer* boidLayer;
}

@property(nonatomic, assign) CCSpriteBatchNode* _playerSheet;
- (void)loadLevel;
- (void)update;
@end

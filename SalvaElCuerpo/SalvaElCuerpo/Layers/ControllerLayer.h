//
//  ControllerLayer.h
//  SalvaElCuerpo
//
//  Created by Jon on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SneakyPad.h"
#import "cocos2d.h"
#import "Box2D.h"


@interface ControllerLayer : CCLayer {
	CCSprite *pauseButton;
    SneakyPad * leftJoystick;
	SneakyPad * rightJoystick;
    float sw;
    float sh;
    CCLabelTTF *debugLabel;
    CCSpriteBatchNode *batch1;
    CCSprite *menuButton;
    b2Body *ground;
    
@public
	CCSprite* bodysprite;
    b2RevoluteJoint* timon_joint;
    b2PrismaticJoint* power_lever;
}

@property (nonatomic, readonly) SneakyPad *leftJoystick;
@property (nonatomic, readonly) SneakyPad *rightJoystick;
@property (nonatomic, assign) CCLabelTTF *debugLabel;
@property (nonatomic, assign) CCSpriteBatchNode *batch1;
@property (nonatomic, assign) b2World *world;

- (void)showPopupMenu;
-(void)GeneratePControls;

@end
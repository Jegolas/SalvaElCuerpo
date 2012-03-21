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

@interface ControllerLayer : CCLayer {
	CCSprite *pauseButton;
    SneakyPad * leftJoystick;
	SneakyPad * rightJoystick;
    float sw;
    float sh;
    CCLabelTTF *debugLabel;
    CCSpriteBatchNode *batch1;
    CCSprite *menuButton;
@public
	CCSprite* bodysprite;
}

@property (nonatomic, readonly) SneakyPad *leftJoystick;
@property (nonatomic, readonly) SneakyPad *rightJoystick;
@property (nonatomic, assign) CCLabelTTF *debugLabel;
@property (nonatomic, assign) CCSpriteBatchNode *batch1;

- (void)showPopupMenu;

@end
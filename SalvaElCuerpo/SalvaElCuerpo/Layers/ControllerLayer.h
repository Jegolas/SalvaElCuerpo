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
@public
	SneakyPad * leftJoystick;
	SneakyPad * rightJoystick;
	CCSprite* bodysprite;
}

@end
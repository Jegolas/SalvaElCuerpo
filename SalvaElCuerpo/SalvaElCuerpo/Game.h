//
//  Game.h
//
//  Created by Jon on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ControllerLayer.h"
#import "BoidLayer.h"
#import "GameLayer.h"
#import "WorldLayer.h"

@interface Game : CCLayer {
	float levelHeight;
	BOOL gameInProgress;
	int currentLevel;
	int nextLevel;
    float sw;
    float sh;
	CCSprite *starIcon;
	CCLabelBMFont *starsCollectedLabel;
	CCSprite *menuButton;
    ControllerLayer* controllerLayer;
    GameLayer* gameLayer;
    WorldLayer* worldLayer;
}
+ (CCScene*)scene;



@end

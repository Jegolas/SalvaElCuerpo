/*
 * Climbers
 * https://github.com/haqu/climbers
 *
 * Copyright (c) 2011 Sergey Tikhonov
 *
 */

#import "cocos2d.h"
#import "ControllerLayer.h"

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
}
+ (CCScene*)scene;

@end

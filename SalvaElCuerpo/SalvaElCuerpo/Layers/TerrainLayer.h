//
//  TerrainLayer.h
//  SalvaElCuerpo
//
//  Created by Jonathan Guindin on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface TerrainLayer : CCLayer
{
    CCSprite * _background;
    CGPoint *_bodyPosition;
}

@property(nonatomic, assign) CGPoint *bodyPosition;

- (void)update:(ccTime)dt position:(CGPoint) bposition;

@end

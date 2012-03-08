//
//  GameLayer.h
//  SalvaElCuerpo
//
//  Created by Jon on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "BoidLayer.h"
#import "Vessel.h"
#import "SneakyPad.h"
#import "TerrainLayer.h"

@interface GameLayer : CCLayer
{
    float sw;
    float sh;
    BoidLayer* boidLayer;
    Vessel* vessel;
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    CCLabelTTF *debugLabel;
@public    
    CGPoint cameraOffset;
    b2World* world;
    CGPoint *bodyPosition;
}

@property(nonatomic, assign) CCSpriteBatchNode* _playerSheet;
@property(nonatomic, assign) SneakyPad *leftJoystick;
@property(nonatomic, assign) SneakyPad *rightJoystick;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

@property (nonatomic, retain) TerrainLayer *terrain;

- (void)loadLevel;
- (void)update:(ccTime)dt;
- (void)updateCamera;
- (void)updateWorld: (ccTime)dt;
@end

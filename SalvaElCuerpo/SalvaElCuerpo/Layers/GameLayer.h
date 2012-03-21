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
#import "People.h"

@interface GameLayer : CCLayer
{
    float sw;
    float sh;
    BoidLayer* boidLayer;
    Vessel* vessel;
    People* person;
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    CCSprite *snapFeedback;
    CCSpriteBatchNode *batch1;
@public    
    CGPoint cameraOffset;
    b2World* world;
    CGPoint *bodyPosition;
}

@property(nonatomic, assign) CCSpriteBatchNode* _playerSheet;
@property(nonatomic, assign) SneakyPad *leftJoystick;
@property(nonatomic, assign) SneakyPad *rightJoystick;
@property(nonatomic, assign) CCLabelTTF *debugLabel;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCSpriteBatchNode *batch1;
@property (nonatomic, retain) TerrainLayer *terrain;

- (void)loadLevel;
- (void)update:(ccTime)dt;
- (void)updateCamera;
- (void)updateWorld: (ccTime)dt;
-(void)GeneratePeople:(CGPoint) spawnPoint;

@end

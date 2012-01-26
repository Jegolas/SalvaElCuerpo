//
//  GameLayer.mm
//  SalvaElCuerpo
//
//  Created by Jon on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

@interface GameLayer()
- (void)loadLevel;
-(void)update;
@end

@implementation GameLayer

@synthesize _playerSheet;

- (id)init {
	if((self = [super init])) {
        
        self.isTouchEnabled = YES;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		sw = screenSize.width;
		sh = screenSize.height;
        
        boidLayer = [BoidLayer alloc];
        
        self._playerSheet = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
		[self addChild:_playerSheet z:1 tag:0];
        
		boidLayer->_playerSheet = self._playerSheet;

        //self.scale = 0.5;
    }
    
    return self;
}

- (void)loadLevel {
	CCLOG(@"Loading Level");
    
	[boidLayer CreateBoidPlayers:nil PlayerNumbers:10];
	
	[self addChild:boidLayer z:-7 tag:5];//z:3 tag:5
}

- (void)update{
    
    //Update the state of the Boids
	if (boidLayer != nil)[boidLayer UpdateBoids];
}

@end

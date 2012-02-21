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
-(void)update:(ccTime)dt;
-(void)updateWorld:(ccTime)dt;
-(void)GenerateVessel;

@end

@implementation GameLayer

#define PTM_RATIO 32 // This is for the physics implementation.

@synthesize _playerSheet;
@synthesize leftJoystick;
@synthesize rightJoystick;

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
    cameraOffset = CGPointZero;
    self.position = CGPointZero;
    
    // Generate the vessel if there is none present
    if (vessel == Nil)
    {
        [self GenerateVessel];
    }
}

- (void)updateCamera {
    //	NSLog(@"self.position = (%f, %f)",self.position.x,self.position.y);
    //NSLog(@"self.position = (%f, %f)",cameraOffset.x,cameraOffset.y);
	//id move = [CCMoveTo actionWithDuration:2 position:ccpNeg(cameraOffset)];
	//id ease = [CCEaseInOut actionWithAction:move rate:2];
	//[self runAction:ease];
    //[self.camera setCenterX:cameraOffset.x centerY:-cameraOffset.y centerZ:0];
    //[self.camera setEyeX:cameraOffset.x eyeY:-cameraOffset.y eyeZ:10];
    
    //[self runAction:[CCFollow actionWithTarget:worldLayer]];
    //CGPoint *point = new CGPoint();
    //point->x = cameraOffset.x;
    //point->y = cameraOffset.y;
    //point->x = worldLayer->bodyPosition->x;
    //point->y = worldLayer->bodyPosition->y;
    
    //[super setPosition:*point];
    //[self runAction:[CCFollow actionWithTarget: worldBoundary:CGRectMake(0,0,1050,350)]];
}

- (void)update:(ccTime)dt {
    
    //Update the state of the Boids
	if (boidLayer != nil)[boidLayer UpdateBoids];
    if (world != nil)[self updateWorld:dt];
}

-(void)updateWorld:(ccTime)dt
{
    int32 velocityIterations = 3;
    int32 positionIterrations = 2;
    float timon_rotation = 0.0;
    float power_lever = 0.0;
    
    if (world != Nil){
        world->Step(dt, velocityIterations, positionIterrations);
        
        // Loop through the world objects and find the main body
        // This body needs to have it's position stored at all times so we know where it is
        
        for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
        {
            BodyInfo* myActor = (BodyInfo*)b->GetUserData();
            if (myActor != Nil){
                if (myActor->bodyType == MainBody)
                {
                    bodyPosition = new CGPoint();
                    // Get the body location
                    b2Vec2 bpos = b->GetPosition();
                    
                    //NSLog(@"x=%f, y=%f",b->GetPosition().x*PTM_RATIO, b->GetPosition().y*PTM_RATIO );
                    CGPoint relativePoint = ccp(((-bpos.x*PTM_RATIO)+250.0), ((-bpos.y*PTM_RATIO)+140));
                    bodyPosition->x = relativePoint.x;
                    bodyPosition->y = relativePoint.y;
                    // No need to look further
                    [self setPosition:relativePoint];
                    break;
                }
            }
        }
    }
    
    // Controllers
    if (leftJoystick != Nil)
    {
        CGPoint scaledVelocity = ccpMult(leftJoystick.velocity, 520.0f); //240.0.  The higher the number, the higher the angle here
        timon_rotation = scaledVelocity.x*dt;
        //NSLog(@"velo x:%f  velo y:%f ", leftJoystick.velocity.x, leftJoystick.velocity.y);
    }
    if (rightJoystick != Nil)
    {
        CGPoint scaledVelocity = ccpMult(rightJoystick.velocity, 520.0f); //240.0
        power_lever = scaledVelocity.y*dt;
    }

    // Update the vessel if present
    if (vessel != Nil){
        [vessel updateVessel:timon_rotation :power_lever];
    }

}

-(void) GenerateVessel
{
    CGPoint sp;
    sp.x = 5.0f;
    sp.y = 5.0f;
    
    vessel = [[Vessel alloc] CreateVessel:world spawnPoint:sp];
    CCLOG(@"Finished loading vessel");
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
}

@end

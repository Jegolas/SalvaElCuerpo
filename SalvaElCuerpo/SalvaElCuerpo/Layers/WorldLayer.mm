//
//  WorldLayer.mm
//  SalvaElCuerpo
//
//  Created by Jon on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldLayer.h"

@implementation WorldLayer

#define PTM_RATIO 32 // This is for the physics implementation.

@synthesize world;

- (id)init {
	self = [super init];
	if (self != nil) {
        // Generates the world
        [self CreateWorld];
    }
 
    return self;
}

// Create the World here
-(void) CreateWorld
{
    // Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.1f, 0.1f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = true;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity, doSleep);
	
	world->SetContinuousPhysics(true);
	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	//flags += b2DebugDraw::e_jointBit;
	//flags += b2DebugDraw::e_aabbBit;
	//flags += b2DebugDraw::e_pairBit;
	//		flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);	

}

-(void) GenerateVessel
{
    CGPoint sp;
    sp.x = 5.0f;
    sp.y = 5.0f;
    
    vessel = [[Vessel alloc] CreateVessel:world spawnPoint:sp];
    CCLOG(@"Finished loading vessel");
}

-(void) update: (ccTime)dt{
    int32 velocityIterations = 3;
    int32 positionIterrations = 2;
    
    if (world != Nil){
        world->Step(dt, velocityIterations, positionIterrations);
    }
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

- (void) dealloc
{
	// Remove all my objects
	[super dealloc];
	NSLog(@"Dealloc-ed everything in World Layer");
}


@end

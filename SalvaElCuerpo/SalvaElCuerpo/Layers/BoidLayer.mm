//
//  BoidLayer.mm
//
//  Created by Jon on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoidLayer.h"


@implementation BoidLayer
#define PTM_RATIO 32

@synthesize _flockEnemyPointer;
@synthesize _flockPlayerPointer;
@synthesize _currentTouch;
@synthesize _sheet;
@synthesize _playerSheet;

-(id)init
{
	self = [super init];
	if (self != nil) {
		CCLOG(@"Initialized Boid Layer");
	}
	return self;
}

-(void)CreateEnemyPlayers:(b2World *)world PlayerNumbers:(int) enemyNumbers
{
	_flockEnemyPointer = [Boid spriteWithSpriteFrameName:@"slider.png"];
	Boid* previousBoid = _flockEnemyPointer;
	Boid *boid = _flockEnemyPointer;
	
	
	// Create as many as we pass in
	for (int i = 0; i < enemyNumbers; i++) 
	{
		// Create a linked list
		// The first one has no previous.
		if(i != 0)
		{
			boid = [Boid spriteWithSpriteFrameName:@"slider.png"];
			//boid = [Boid spriteWithBatchNode:_sheet rect: boidRect];
			previousBoid->_next = boid; // special case for the first one
		}
		
		previousBoid = boid;
		
		// Initialize behavior properties for this boid
		boid.doRotation = YES;
		boid.edgeBehavior = EDGE_BOUNCE;
		[boid setSpeedMax:2.0f withRandomRangeOf:1.5f andSteeringForceMax:0.75f withRandomRangeOf:0.25f];
		[boid setWanderingRadius: 10.0f lookAheadDistance: 40.0f andMaxTurningAngle:0.2f];
		//[boid setEdgeBehavior: CCRANDOM_0_1() < 0.9 ? EDGE_WRAP : EDGE_BOUNCE];
		//[boid setEdgeBehavior: EDGE_BOUNCE];
		
		// Cocos properties
		//[boid setScale: 0.2 + CCRANDOM_0_1()];
		[boid setScale: 0.5];
		//[boid setPos: ccp(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height )];
		[boid setPos: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 480.0f )];
		// Body
		b2CircleShape shape;
		shape.m_radius = 0.3f;
		b2BodyDef bd;
		bd.type = b2_dynamicBody;
		
//		BodyInfo * bi = [[BodyInfo alloc] init];
//		bi->bodyType = Shark;
//		bi->touching = false;
//		bi->destroy = false;
//		bd.userData = bi;
		bd.position.Set((100.0f + 10.0f*i*5)/PTM_RATIO, 200.0f/PTM_RATIO);
		
		b2Body* circle = world->CreateBody(&bd);
		
		b2FixtureDef ballShapeDef;
		ballShapeDef.shape = &shape;
		ballShapeDef.density = 0.0f;
		ballShapeDef.isSensor = true;
		circle->CreateFixture(&ballShapeDef);
		boid.body = circle;
		
		
		boid.leftEdge = -100.0;
		boid.bottomEdge = -100.0;
		
		boid.topEdge = 860.0;
		boid.rightEdge = 860.0;
		
		// Color
		[_sheet addChild:boid];
	}
	
}

-(void)CreateBoidPlayers:(b2World *) world PlayerNumbers:(int) playerNumbers
{
    
	// This creates the number of players that need to get rescued
	
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	
	_flockPlayerPointer = [Boid spriteWithBatchNode:_playerSheet rect: CGRectMake(32 * idx,32 * idy,32,32)];
	Boid* previousBoid = _flockPlayerPointer;
	Boid *boid = _flockPlayerPointer;
	
	
	// Create many of them
	for (int i = 0; i < playerNumbers; i++) 
	{
		idx = (CCRANDOM_0_1() > .5 ? 0:1);
		idy = (CCRANDOM_0_1() > .5 ? 0:1);
		
		// Create a linked list
		// The first one has no previous.
		if(i != 0)
		{
			boid = [Boid spriteWithBatchNode:_playerSheet rect: CGRectMake(32 * idx,32 * idy,32,32)];
			previousBoid->_next = boid; // special case for the first one
			boid->_prev = previousBoid;
		}
		else {
			boid->_prev = nil;
		}
        
		
		previousBoid = boid;
		
		// Initialize behavior properties for this boid
		boid.doRotation = YES;
		boid.edgeBehavior = EDGE_BOUNCE;
		[boid setSpeedMax:1.5f withRandomRangeOf:1.5f andSteeringForceMax:0.75f withRandomRangeOf:0.25f];
		[boid setWanderingRadius: 10.0f lookAheadDistance: 40.0f andMaxTurningAngle:0.2f];
        
		//[boid setEdgeBehavior: CCRANDOM_0_1() < 0.9 ? EDGE_WRAP : EDGE_BOUNCE];
		//[boid setEdgeBehavior: EDGE_BOUNCE];
		
		// Cocos properties
		[boid setScale: 0.2 + CCRANDOM_0_1()];
		//[boid setPos: ccp(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height )];
		[boid setPos: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 480.0f )];
		// Body
		b2CircleShape shape;
		if (i == 0)
		{
			shape.m_radius = 1.0f;
		}
		else{
			shape.m_radius = 0.3f;
		}
		b2BodyDef bd;
		bd.type = b2_dynamicBody;
		
//		BodyInfo * bi = [[BodyInfo alloc] init];
//		bi->bodyType = Person;
//		bi->touching = false;
//		bi->destroy = false;
//		bd.userData = bi;
		bd.position.Set((100.0f + 10.0f*i*5)/PTM_RATIO, 200.0f/PTM_RATIO);
		
        if( world != nil){
            b2Body* circle = world->CreateBody(&bd);
            
            b2FixtureDef ballShapeDef;
            ballShapeDef.shape = &shape;
            ballShapeDef.density = 0.0f;
            ballShapeDef.isSensor = true;
            circle->CreateFixture(&ballShapeDef);
            boid.body = circle;
		}
		
		boid.leftEdge = 100.0;
		boid.bottomEdge = 100.0;
		
		boid.topEdge = 860.0;
		boid.rightEdge = 860.0;
		
		// Color
		[_playerSheet addChild:boid];
	}
	
}


-(id)CreateBoids:(int) BoidCount
{
	self = [super init];
	if (self != nil) {
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		CGRect boidRect = CGRectMake(0,0, 16, 16);
		
		
		self._sheet = [CCSpriteBatchNode batchNodeWithFile:@"boid.png" capacity:150];
		[self addChild:_sheet z:0 tag:0];
		
		
		_flockEnemyPointer = [Boid spriteWithBatchNode:_sheet rect: boidRect];
		Boid* previousBoid = _flockEnemyPointer;
		Boid *boid = _flockEnemyPointer;
		
		
		// Create as many as we pass in
		for (int i = 0; i < BoidCount; i++) 
		{
			// Create a linked list
			// The first one has no previous.
			if(i != 0)
			{
				boid = [Boid spriteWithBatchNode:_sheet rect: boidRect];
				previousBoid->_next = boid; // special case for the first one
			}
			
			previousBoid = boid;
			
			// Initialize behavior properties for this boid
			boid.doRotation = YES;
			boid.edgeBehavior = EDGE_BOUNCE;
			[boid setSpeedMax:2.0f withRandomRangeOf:1.5f andSteeringForceMax:0.75f withRandomRangeOf:0.25f];
			[boid setWanderingRadius: 10.0f lookAheadDistance: 40.0f andMaxTurningAngle:0.2f];
			//[boid setEdgeBehavior: CCRANDOM_0_1() < 0.9 ? EDGE_WRAP : EDGE_BOUNCE];
			//[boid setEdgeBehavior: EDGE_BOUNCE];
			
			// Cocos properties
			[boid setScale: 0.2 + CCRANDOM_0_1()];
			//[boid setPos: ccp(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height )];
			[boid setPos: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 480.0f )];
			
			boid.leftEdge = -100.0;
			boid.bottomEdge = -100.0;
			
			boid.topEdge = 860.0;
			boid.rightEdge = 860.0;
			
			// Color
			[_sheet addChild:boid];
		}
	}
	return self;
}


-(void) UpdateBoids
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	Boid* boid = _flockEnemyPointer;
	//CGPoint dude = ccp(480.0f, 480.0f);
	CGPoint dude = ccp(screenSize.height/2.0f, screenSize.width/2.0f);
	while(boid)
	{
		Boid* b = boid;
		boid = b->_next;
		[b wander: 1.19f];
		
		[b
		 flock:_flockEnemyPointer
		 withSeparationWeight:5.5f // Make this higher
		 andAlignmentWeight:1.05f // Make this low, they don't care where their neighbors are going
		 andCohesionWeight:0.5f // Make this low they don't care to be close to their neighbors
		 andSeparationDistance:5.0f //this is key
		 andAlignmentDistance:4.0f // make this zero if you really dont care going where your neighbors are
		 andCohesionDistance:1.5f // make this zero if you really dont care about staying close to one another
		 ];
		
		if (CCRANDOM_0_1() < 0.9){
			[b seek:dude usingMultiplier:0.35f];
		}
		
		[b update];
	}
    
	
	Boid* boidPlayer = _flockPlayerPointer;
	//dude = ccp(400.0f, 300.0f);
	//Boid* preBoid = _flockPlayerPointer;
	while(boidPlayer)
	{
		Boid* b = boidPlayer;
		boidPlayer = b->_next;
        
		[b wander: 1.19f];
		
		[b
		 flock:_flockPlayerPointer
		 withSeparationWeight:5.5f // Make this higher
		 andAlignmentWeight:1.05f // Make this low, they don't care where their neighbors are going
		 andCohesionWeight:0.5f // Make this low they don't care to be close to their neighbors
		 andSeparationDistance:5.0f //this is key
		 andAlignmentDistance:4.0f // make this zero if you really dont care going where your neighbors are
		 andCohesionDistance:1.5f // make this zero if you really dont care about staying close to one another
		 ];
		
		//if (CCRANDOM_0_1() < 0.9){
			[b seek:dude usingMultiplier:0.75f];
		//}
		
		[b update];
		
		if (b.body != NULL)
		{
            /*
			BodyInfo* bi = (BodyInfo*)b.body->GetUserData();
			if (bi.touching == YES)
			{
				// Remove from the list
				if (b->_prev == nil && b->_next == nil){
					// We are at the head, see if there is a next, if not, remove the pointer
					_flockPlayerPointer = nil;
				}
				else{ 
                    
				    // Fix the next node here so it knows to point to the prev node of the one
				    // we are removing
				    if(b->_next != nil){
				        b->_next->_prev = b->_prev;
						
						// Fix the head pointer removal
						if (b->_prev == nil){
							_flockPlayerPointer = b->_next;
						}
				    }
				    // Fix the previous node here so it knows to point to the next node
				    // of the one we are removing
				    if (b->_prev != nil){
				        b->_prev->_next = b->_next;
				    }
				    
				}
				
				[_playerSheet removeChild:b cleanup:YES];
				//b = nil;
				//[b dealloc];
				//b = nil;
				//[self removeChild:b cleanup:YES];
			}
            */
		}
		
	}
    
}

-(void) UpdateBoidsMenu
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
	Boid* boid = _flockEnemyPointer;
	CGPoint dude = ccp(screenSize.height/2.0f, screenSize.width/2.0f);
	
	while(boid)
	{
		Boid* b = boid;
		boid = b->_next;
		[b wander: 1.19f];
		
		[b
		 flock:_flockEnemyPointer
		 withSeparationWeight:5.5f // Make this higher
		 andAlignmentWeight:1.05f // Make this low, they don't care where their neighbors are going
		 andCohesionWeight:0.5f // Make this low they don't care to be close to their neighbors
		 andSeparationDistance:5.0f //this is key
		 andAlignmentDistance:3.0f // make this zero if you really dont care going where your neighbors are
		 andCohesionDistance:1.5f // make this zero if you really dont care about staying close to one another
		 ];
		
		if (CCRANDOM_0_1() < 0.9){
			[b seek:dude usingMultiplier:0.35f];
		}
		
		[b update];
	}
	
	
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	//UITouch *myTouch = [touches anyObject];
	CGPoint location = [[CCDirector sharedDirector] convertToGL: [touch locationInView:touch.view]];
	
	//CGPoint location = [self convertTouchToNodeSpace: touch];
	
	self._currentTouch = location;
	return YES;
}
// touch updates:
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CCLOG(@"Moving");
	self._currentTouch = [[CCDirector sharedDirector] convertToGL: [touch locationInView:touch.view]];
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	self._currentTouch = CGPointZero;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end

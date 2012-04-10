//
//  BananaBoat.mm
//  SalvaElCuerpo
//
//  Created by Jon on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BananaBoat.h"

@implementation BananaBoat

@synthesize body = _body;
@synthesize batch1 = _batch1;


#pragma mark Initialization
- (id) init
{
	self = [super init];
	if (self != nil) 
	{
	}
	return self;
}

-(void)CreateBBoat:(b2World *) world  spawnPoint:(CGPoint) spawnPoint
{
    
    // Create a person object, with a box2d circle around it
    // Body
    b2CircleShape shape;
    shape.m_radius = 0.6f;
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.position.Set(spawnPoint.x/PTM_RATIO, spawnPoint.y/PTM_RATIO);
    BodyInfo * bi = [[BodyInfo alloc] init];
    bi->bodyType = Banana;
    bi->touching = false;
    bi->destroy = false;
    bi->sprite = self;
    bd.userData = bi;
    _body = world->CreateBody(&bd);
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &shape;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 5.0f;
    ballShapeDef.restitution = 0.1;
    ballShapeDef.isSensor = false;
    //ballShapeDef.userData = self;
    _body->CreateFixture(&ballShapeDef);
    
    
}

// Update the sprite location depending on where the body is.
-(void)update
{
    self.position = ccp(_body->GetPosition().x*PTM_RATIO, _body->GetPosition().y*PTM_RATIO);
    self.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
    
}
#pragma mark Deallocation
- (void) dealloc
{
	[super dealloc];
}

@end
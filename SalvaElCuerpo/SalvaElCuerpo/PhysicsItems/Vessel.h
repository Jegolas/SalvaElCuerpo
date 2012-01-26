//
//  Vessel.h
//  SalvaElCuerpo
//
//  Created by Jon on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "BodyInfo.h"

@interface Vessel : NSObject
{
    b2Body *cart;
	b2Body* wheel1;
    b2Body* wheel2;
    
	b2RevoluteJoint* m_joint;
	b2Fixture* body_fixture;
	
@public
	b2Body *vehicle_body;
	b2Body* wheel3;
	float engineSpeed;

}

-(id) CreateVessel:(b2World *) world spawnPoint:(CGPoint) spawnPoint;

@end

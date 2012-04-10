//
//  Boat.mm
//  SalvaElCuerpo
//
//  Created by Jon on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Boat.h"

#define PTM_RATIO 32

@implementation Boat

-(id)CreateBoat: (b2World *)world
{

    self = [super init];
	if (self != nil) 
	{
    float scale = 2.0f;
    
    BodyInfo * bi = [[BodyInfo alloc] init];
    bi->bodyType = MainBody;
    b2PolygonShape shape_body;
    shape_body.SetAsBox((30.0f/PTM_RATIO)/scale, (50.0f/PTM_RATIO)/scale);
    
    b2FixtureDef fd;
    fd.shape = &shape_body;
    fd.density = 10.5f;
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.position.Set((180.0f/PTM_RATIO)/scale, (100.0f/PTM_RATIO)/scale);
    vehicle_body = world->CreateBody(&bd);
    vehicle_body->SetUserData(bi);
    body_fixture = vehicle_body->CreateFixture(&fd);
    }
    return self;
}

-(void)updateVessel: (float) timon_rotation :(float) power_lever
{
	b2Vec2 ldirection = vehicle_body->GetTransform().R.col2;
	//ldirection *= engineSpeed;
	//wheel1->ApplyForce(ldirection, wheel1->GetPosition());
	
	//float32 mspeed = (timon_rotation)/5.0f  - vehicle_body->GetAngle();
	
	// Use the power lever to power the boat
	float boat_torque = 0.5;
    //if (timon_rotation > 0.0)
    {
        vehicle_body->ApplyTorque(timon_rotation * boat_torque);
    }
	
    b2Vec2 *boat_force = new b2Vec2(0, power_lever*3.5);
    //vehicle_body->ApplyForce(<#const b2Vec2 &force#>, <#const b2Vec2 &point#>)
    
    vehicle_body->ApplyForce(*boat_force, vehicle_body->GetPosition());
    
}
@end

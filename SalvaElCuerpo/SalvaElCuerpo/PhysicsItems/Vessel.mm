//
//  Vessel.mm
//  SalvaElCuerpo
//
//  Created by Jon on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Vessel.h"

#define PTM_RATIO 32

@implementation Vessel

-(id)CreateVessel:(b2World *) world  spawnPoint:(CGPoint) spawnPoint;
{
    self = [super init];
	if (self != nil) 
	{
		BodyInfo * bi = [[BodyInfo alloc] init];
		bi->bodyType = MainBody;
		b2PolygonShape shape_body;
		shape_body.SetAsBox(30.0f/PTM_RATIO, 50.0f/PTM_RATIO);
		
		b2FixtureDef fd;
		fd.shape = &shape_body;
		fd.density = 1.5f;
		
		b2BodyDef bd;
		bd.type = b2_dynamicBody;
		bd.position.Set(180.0f/PTM_RATIO, 100.0f/PTM_RATIO);
		vehicle_body = world->CreateBody(&bd);
		vehicle_body->SetUserData(bi);
		body_fixture = vehicle_body->CreateFixture(&fd);
		//VehicleMainBody = vehicle_body;
		
		// Rest of the bodies are lighter
		fd.density = 1.5f;
		
		// Wheel 1 (this is going to be my motor wheel)
		b2PolygonShape shape_left_wheel;
		shape_left_wheel.SetAsBox(10.0f/PTM_RATIO, 15.0f/PTM_RATIO);
		fd.shape = &shape_left_wheel;
		bd.position.Set(bd.position.x/PTM_RATIO + 175.0f/PTM_RATIO, bd.position.y/PTM_RATIO + 30.0f/PTM_RATIO);
		wheel1 = world->CreateBody(&bd);
		bi = [[BodyInfo alloc] init];
		bi->bodyType = Engine;
		wheel1->SetUserData(bi);
		wheel1->CreateFixture(&fd);
		
		
		// Create the joints for the wheels
		b2RevoluteJointDef jd1;
		jd1.bodyA = vehicle_body;
		jd1.bodyB = wheel1;
		jd1.localAnchorA = vehicle_body->GetLocalPoint(bd.position);
		jd1.localAnchorB = wheel1->GetLocalPoint(bd.position);
		jd1.referenceAngle = wheel1->GetAngle() - vehicle_body->GetAngle();
		jd1.enableMotor = true;
		jd1.maxMotorTorque = 10.0f;
		jd1.motorSpeed = 10.0f;
		m_joint = (b2RevoluteJoint*)world->CreateJoint(&jd1);
		
		// Rest of the wheels are lighter
		fd.density = 0.2f;
		
		// Wheel 2
		b2PolygonShape shape_right_wheel;
		shape_right_wheel.SetAsBox(5.0f/PTM_RATIO, 10.0f/PTM_RATIO);
		fd.shape = &shape_right_wheel;
		bd.position.Set(180.0f/PTM_RATIO - 10.0f/PTM_RATIO, 100.0f/PTM_RATIO + 20.0f/PTM_RATIO);
		wheel2  = world->CreateBody(&bd);
		wheel2 ->CreateFixture(&fd);
		
		// Prismatic joint
		b2PrismaticJointDef jd2;
		jd2.bodyA = vehicle_body;
		jd2.bodyB = wheel2;
		jd2.localAnchorA = vehicle_body->GetLocalPoint(bd.position);
		jd2.localAnchorB = wheel2->GetLocalPoint(bd.position);
		jd2.referenceAngle = wheel2->GetAngle() - vehicle_body->GetAngle();
		jd2.enableLimit = true;
		jd2.lowerTranslation = 0;
		jd2.upperTranslation = 0;
		jd2.enableMotor = true;
		(b2PrismaticJoint*)world->CreateJoint(&jd2);
		
		
		// Wheel 3
		b2PolygonShape shape_middle_wheel;
		shape_middle_wheel.SetAsBox(5.0f/PTM_RATIO, 10.0f/PTM_RATIO);
		fd.shape = &shape_middle_wheel;
		bd.position.Set(180.0f/PTM_RATIO + 10.0f/PTM_RATIO, 100.0f/PTM_RATIO + 20.0f/PTM_RATIO);
		wheel3 = world->CreateBody(&bd);
		wheel3->CreateFixture(&fd);
		
		// Create prismatic joint for the wheel
		b2PrismaticJointDef jd3;
		jd3.bodyA = vehicle_body;
		jd3.bodyB = wheel3;
		jd3.localAnchorA = vehicle_body->GetLocalPoint(bd.position);
		jd3.localAnchorB = wheel3->GetLocalPoint(bd.position);
		jd3.referenceAngle = wheel3->GetAngle() - vehicle_body->GetAngle();
		jd3.enableLimit = true;
		jd3.lowerTranslation = 0;
		jd3.upperTranslation = 0;
		jd3.enableMotor = true;
		(b2PrismaticJoint*)world->CreateJoint(&jd3);
		NSLog(@"Finished running Vessel");
		
		
		{
			BodyInfo * bi = [[BodyInfo alloc] init];
			bi->bodyType = Sensor;
			
            b2PolygonShape shape_body;
            shape_body.SetAsBox(20.0/PTM_RATIO, 30.0/PTM_RATIO);
            
            b2FixtureDef fd;
			fd.shape = &shape_body;
			fd.density = 0.01f;
			fd.isSensor = true;
			
			b2BodyDef bd;
			bd.type = b2_dynamicBody;
			bd.position.Set(180.0f/PTM_RATIO+53.0f/PTM_RATIO, 100.0f/PTM_RATIO - 10.0f/PTM_RATIO);
			b2Body*  sensor1 = world->CreateBody(&bd);
			sensor1->SetUserData(bi);
			sensor1->CreateFixture(&fd);
			
			b2WeldJointDef weldDef;
			weldDef.Initialize(vehicle_body, sensor1, sensor1->GetWorldCenter());
			world->CreateJoint(&weldDef);
			
            
        }
    }
    return self;
}
@end

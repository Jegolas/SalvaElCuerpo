//
//  Boat.h
//  SalvaElCuerpo
//
//  Created by Jon on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "BodyInfo.h"

@interface Boat : NSObject
{
    b2Body *vehicle_body;
    b2Fixture* body_fixture;
}

-(void)updateVessel: (float) timon_rotation :(float) power_lever;
-(id)CreateBoat: (b2World *)world;

@end

//
//  WorldLayer.h
//  SalvaElCuerpo
//
//  Created by Jon on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Vessel.h"

@interface WorldLayer : CCLayer
{
    Vessel* vessel;
    GLESDebugDraw *m_debugDraw;
@public
	b2World* world;
}

@property (nonatomic) b2World *world;

-(void)CreateWorld;
-(void) update: (ccTime)dt;
-(void) GenerateVessel;
@end

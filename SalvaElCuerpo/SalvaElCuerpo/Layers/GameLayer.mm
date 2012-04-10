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
-(void)GeneratePeople:(CGPoint) spawnPoint;
-(void)GenerateBoat;
@end

@implementation GameLayer

#define PTM_RATIO 32 // This is for the physics implementation.

@synthesize _playerSheet;
@synthesize leftJoystick;
@synthesize rightJoystick;
@synthesize tileMap = _tileMap;
@synthesize background = _background;
@synthesize terrain = _terrain;
@synthesize debugLabel;
@synthesize batch1;
@synthesize arrowArray = _arrowArray;

- (id)init {
	if((self = [super init])) {
        
        self.isTouchEnabled = YES;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		sw = screenSize.width;
		sh = screenSize.height;
        
        boidLayer = [BoidLayer alloc];
        
        self._playerSheet = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
		[self addChild:_playerSheet z:2 tag:0];
        
		boidLayer->_playerSheet = self._playerSheet;

        //self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"FishTiles.tmx"];
        //self.background = [_tileMap layerNamed:@"MainBackgroundTransparency"];
        
        //[self addChild:_tileMap z:-1];
        
        //self.scale = 0.5;
        
        /*
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"0/100" fntFile:@"digits.fnt"];
		label.opacity = 128;
		label.position = ccp(60,sh-32);
		label.anchorPoint = ccp(0,0.5f);
		[self addChild:label z:15];
		debugLabel = [label retain];
        */
        //[NSString stringWithFormat:@"x=%f, y=%f", bodyPosition->x, bodyPosition->y]

        
        // sprite sheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
		batch1 = [[CCSpriteBatchNode alloc] initWithFile:@"sprites.png" capacity:50];
		[self addChild:batch1];
        
        // snap feedback
		snapFeedback = [[CCSprite alloc] initWithSpriteFrameName:@"snapFeedback.png"];
		[batch1 addChild:snapFeedback];
		snapFeedback.opacity = 0;
    }
    
    return self;
}

- (void)loadLevel {
	CCLOG(@"Loading Level");
    
	[boidLayer CreateBoidPlayers:nil PlayerNumbers:1];
	
	[self addChild:boidLayer z:3 tag:5];//z:3 tag:5
    cameraOffset = CGPointZero;
    self.position = CGPointZero;
    
    // Generate the vessel if there is none present
    if (vessel == Nil)
    {
        [self GenerateVessel];
    }
    
    if (person == Nil)
    {
        [self GeneratePeople:ccp(180.0f, 100.0f)];
    }
    ropeLength = sh*250/1024;
    
    ropeBatch = [CCSpriteBatchNode batchNodeWithFile:@"rope.png"];
    CGPoint p1;
    CGPoint p2;
    
    p1 = ccp(180.0*CCRANDOM_0_1(), 100.0);
    p2 = ccp(180.0*CCRANDOM_0_1(), 200.0);
    
    rope = [[VRope alloc] initWithPoints:p1 pointB:p2 spriteSheet:ropeBatch];
    
    //VRope *verletRope = [[VRope alloc] init:bodyA pointB:bodyB spriteSheet:ropeSegmentSprite];
    [self addChild:ropeBatch z:1];

    [self GenerateBanana:ccp(100.0f, 100.f)];
    
    //if (boat == Nil)
    //{
    //    [self GenerateBoat];
    //}
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
	if (boidLayer != nil)
    {
        if (bodyPosition != Nil)
        {
            [boidLayer UpdateBoids:*bodyPosition];
            //NSLog(@"Body x=%f, y=%f", bodyPosition->x, bodyPosition->y);
        }
        else{
            [boidLayer UpdateBoids];
        }
    }
    if (world != nil)[self updateWorld:dt];
}

-(void)updateWorld:(ccTime)dt
{
    int32 velocityIterations = 3;
    int32 positionIterrations = 2;
    float timon_rotation = 0.0;
    float power_lever = 0.0;
    b2Body *mainBody;
    
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
                    mainBody = b;
                    bodyPosition = new CGPoint();
                    // Get the body location
                    b2Vec2 bpos = b->GetPosition();
                    
                    //NSLog(@"x=%f, y=%f",b->GetPosition().x*PTM_RATIO, b->GetPosition().y*PTM_RATIO );
                    CGPoint relativePoint = ccp(((-bpos.x*PTM_RATIO)+250.0), ((-bpos.y*PTM_RATIO)+140));
                    //bodyPosition->x = relativePoint.x;
                    //bodyPosition->y = relativePoint.y;
                    
                    bodyPosition->x = bpos.x*PTM_RATIO;
                    bodyPosition->y = bpos.y*PTM_RATIO;
                    
                    //NSLog(@"Body x=%f, y=%f", bpos.x*PTM_RATIO, bpos.y*PTM_RATIO);
                    
                    // No need to look further
                    [self setPosition:relativePoint];
                    //break;
                }
                else if (myActor->bodyType == Person)
                {
                    // Calculate the distance between the person and the main body and if it is close, alert the user with a
                    // Random heat sensor on the location
                    
                    // Move the sprite to follow the body
                    //CCSprite *sprite;
                    //sprite = myActor.sprite;
                    //sprite.position = ccp(20.0f, 100.0f*CCRANDOM_0_1());
                    
                }
            }
        }
    }
    //[person update];
    for (People *pers in _arrowArray) {
        [pers update];
        float distance;
        distance = b2Distance(pers.body->GetWorldCenter(), mainBody->GetWorldCenter());
        //NSLog(@"Distance = %f", distance);
    }
    
    [bboat update];
    
    // Controllers
    if (leftJoystick != Nil)
    {
        CGPoint scaledVelocity = ccpMult(leftJoystick.velocity, 520.0f); //240.0.  The higher the number, the higher the angle here
        timon_rotation = scaledVelocity.x*dt;
        //NSLog(@"velo x:%f  velo y:%f ", leftJoystick.velocity.x, leftJoystick.velocity.y);
    }
    if (rightJoystick != Nil)
    {
        CGPoint scaledVelocity = ccpMult(rightJoystick.velocity, 140.0f); //240.0
        power_lever = scaledVelocity.y*dt;
    }

    // Update the vessel if present
    if (vessel != Nil){
        [vessel updateVessel:timon_rotation :power_lever];
    }
    
    if (boat != Nil)
    {
        [boat updateVessel:timon_rotation :power_lever];
    }
    if(_terrain != Nil)
    {
        [_terrain update:dt position:*bodyPosition];
    }

    // Check the boids, see if the boat is close to them, if so, add a feedback to them
    //float d = ccpDistance(bodyPosition, bodyPosition);
    
    float snapDist = sh*64.0f/1024;
    float dist = 10.0f*CCRANDOM_0_1();
    if(dist < snapDist) {
        float t = (snapDist - dist)/snapDist;
        snapFeedback.scale =  t*0.75f + 0.25f;
        snapFeedback.opacity = t*255.0f;
        snapFeedback.position = *bodyPosition;
    }

    //person.position = *bodyPosition;
    
    if (debugLabel != Nil){
        debugLabel.string = [NSString stringWithFormat:@"x=%f, y=%f", bodyPosition->x, bodyPosition->y];
    }
    
    [rope updateWithPoints:*bodyPosition pointB:bboat.position dt:dt];
	[rope updateSprites];
}

-(void) GenerateVessel
{
    CGPoint sp;
    sp.x = 5.0f;
    sp.y = 5.0f;
    
    vessel = [[Vessel alloc] CreateVessel:world spawnPoint:sp];
    CCLOG(@"Finished loading vessel");
}

-(void) GenerateBoat
{
    boat = [[Boat alloc] CreateBoat:world];
}

// Generates the people floating around
-(void)GeneratePeople:(CGPoint) spawnPoint
{
    _arrowArray = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++)
    {
        People* personArr;
        // this one works
        personArr = [People spriteWithSpriteFrameName:@"grab.png"];
        
        [personArr CreatePerson:world spawnPoint:spawnPoint];
        personArr.position = ccp(180.0*CCRANDOM_0_1(), 100.0);
        //person.opacity = 0;
        [batch1 addChild:personArr z:50];
        
        [_arrowArray addObject:personArr];
        
        //[self addChild:person z:60]; // Keep this here because this will turn on the sprite
        NSLog(@"added person");
    }
}

// Generates the banana floating around
-(void)GenerateBanana:(CGPoint) spawnPoint
{
    // this one works
    bboat = [BananaBoat spriteWithSpriteFrameName:@"starIcon.png"];
    
    [bboat CreateBBoat:world spawnPoint:spawnPoint];
    bboat.position = ccp(100.0*CCRANDOM_0_1(), 100.0);
    //person.opacity = 0;
    [batch1 addChild:bboat z:50];
    NSLog(@"added banana");
    
    //define rope joint, params: two b2bodies, two local anchor points, length of rope

//    b2RopeJointDef jd;
//    jd.bodyA=body1; //define bodies
//    jd.bodyB=body2;
//    jd.localAnchorA = b2Vec2(0,0); //define anchors
//    jd.localAnchorB = b2Vec2(0,0);
//    jd.maxLength= (body2->GetPosition() - body1->GetPosition()).Length(); //define max length of joint = current distance between bodies
//    world->CreateJoint(&jd); //create joint
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

-(void) dealloc
{
    self.tileMap = nil;
    self.background = nil;
    [snapFeedback release];
    [super dealloc];
}
@end

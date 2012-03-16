//
//  Game.m
//
//  Created by Jon on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "GameConfig.h"

#ifdef IOS
#define kFontName @"ChalkboardSE-Bold"
#else
#define kFontName @"Arial"
#endif

#define PTM_RATIO 32 // This is for the physics implementation.

#define kNumLevels 15

enum {
	kTagLabel = 1,
	kTagLabel2,
	kTagLabel3,
	kTagBottom,
	kTagTop,
	kTagWall,
	kTagFlower,
	kTagFlowerPS,
};



@interface Game()
- (void)loadLevel;
- (void)resetLevel;
- (void)sparkleAt:(CGPoint)p;
- (void)showPopupMenu;
- (void)CreateWorld;
- (void)updateUIPosition;
@end

@implementation Game


+ (CCScene*)scene {
	CCScene *scene = [CCScene node];
	[scene addChild:[Game node]];
	return scene;
}

- (id)init {
	if((self = [super init])) {
		
		self.isTouchEnabled = YES;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		sw = screenSize.width;
		sh = screenSize.height;
		
        // Create the physics world
        [self CreateWorld];

        //worldLayer = [WorldLayer node];
        //[self addChild:worldLayer z:6];
        
        gameLayer = [GameLayer node];
        [self addChild:gameLayer z:1];

        terrain = [TerrainLayer node];
        [self addChild:terrain z:-1];
        
        // Pass the physics world to the layer
        gameLayer->world = world;
        
        //gameLayer->worldLayer = worldLayer;
        
		// star counter
		//float fontSize = 12;
		CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"0/0" fntFile:@"digits.fnt"];
		label.opacity = 128;
		label.position = ccp(60,sh-32);
		label.anchorPoint = ccp(0,0.5f);
		[self addChild:label z:15];
		starsCollectedLabel = [label retain];
		
                
		// arrays
		currentLevel = 0;
		nextLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"];
		if(!nextLevel) {
			nextLevel = 1;
		}
		[self resetLevel];
		
        //Add in the controller
        controllerLayer = [ControllerLayer node];
		[self addChild:controllerLayer z:3 tag:6];
		
        
        //Pass in the controllers to the GameLayer
        gameLayer.leftJoystick = controllerLayer.leftJoystick;
        gameLayer.rightJoystick = controllerLayer.rightJoystick;
        gameLayer.debugLabel = controllerLayer.debugLabel;
        
        gameLayer.terrain = terrain;
        
        controllerLayer.batch1 = gameLayer.batch1;
        //self.scale = 0.5;
		[self schedule:@selector(update:)];
	}
	return self;
}

- (void)dealloc {
	[starIcon release];
	[starsCollectedLabel release];
	[menuButton release];
	[super dealloc];
}


- (void)loadLevel
{
    // Call the load level from the game layer
    // ** Might need to change this here for more logical calls
    [gameLayer loadLevel];
    //[worldLayer GenerateVessel];
    
    batch1 = gameLayer.batch1;
    CCSprite *sprite;
    // menu button
    sprite = [CCSprite spriteWithSpriteFrameName:@"menuButton.png"];
    sprite.position = ccp(sw-32,sh-32);
    //sprite.position = ccp(90.0, 50.0);
    [batch1 addChild:sprite z:50];
    menuButton = [sprite retain];
    //CCLOG(@"position x = %f, y=%f", sw, sh);
    
}

- (void)resetLevel {
	
	if(nextLevel != currentLevel) {
		currentLevel = nextLevel;
		if(currentLevel > kNumLevels) {
			//[[CCDirector sharedDirector] pushScene:[Intro scene]];
			return;
		}
		[self loadLevel];
	}
	
	[self removeChildByTag:kTagLabel cleanup:YES];
	[self removeChildByTag:kTagLabel2 cleanup:YES];
	[self removeChildByTag:kTagLabel3 cleanup:YES];
	
	[self removeChildByTag:kTagFlowerPS cleanup:YES];
	

	[self stopAllActions];
	self.position = CGPointZero;

	gameInProgress = YES;
}

- (void)levelFailed {
	NSLog(@"levelFailed");

	gameInProgress = NO;
	float fontSize = 32.0f;
	CCLabelTTF *label = [CCLabelTTF labelWithString:@"NO-O-O-O!" fontName:kFontName fontSize:fontSize];
	label.color = ccc3(240, 0, 0);
	label.position = ccp(sw/2, sh*7/8-self.position.y);
	label.tag = kTagLabel;
	[self addChild:label z:12];
	nextLevel = currentLevel;
}

- (void)levelCompleted {
	NSLog(@"levelCompleted");
	gameInProgress = NO;
	float fontSize = 64.0f;
	CCLabelTTF *label;
	if(currentLevel == kNumLevels) {
		label = [CCLabelTTF labelWithString:@"Yeah! You did it!" fontName:kFontName fontSize:fontSize];
		label.color = ccc3(255, 255, 255);
		label.position = ccp(sw/2, levelHeight+sh*3/8);
		label.tag = kTagLabel;
		[self addChild:label z:12];
		
		label = [CCLabelTTF labelWithString:@"Finally, you overcame all difficulties on your way. Great job!" fontName:kFontName fontSize:fontSize*3/8];
		label.color = ccc3(255, 255, 255);
		label.position = ccp(sw/2, levelHeight+sh*5/16);
		label.tag = kTagLabel2;
		[self addChild:label z:12];

		
	} else {
		label = [CCLabelTTF labelWithString:@"Well Done!" fontName:kFontName fontSize:fontSize];
		label.color = ccc3(255, 255, 255);
		label.position = ccp(sw/2, levelHeight+sh*3/8);
		label.tag = kTagLabel;
		[self addChild:label z:12];
		
		label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d completed",currentLevel] fontName:kFontName fontSize:fontSize*3/8];
		label.color = ccc3(255, 255, 255);
		label.position = ccp(sw/2, levelHeight+sh*5/16);
		label.tag = kTagLabel2;
		[self addChild:label z:12];
		
	}
	
	CCParticleSystem *ps = [CCParticleFireworks node];
	ps.texture = [[CCTextureCache sharedTextureCache] addImage:@"stars.png"];
	ps.startSize = 4;
//	ps.endSize = 10.0f;
	ps.speed = 100;
	ps.position = ccp(sw/2-sw*9/768, levelHeight+sh*65/1024);
	[self addChild:ps z:10 tag:kTagFlowerPS];
	
	nextLevel = currentLevel+1;
	if(nextLevel > kNumLevels) {
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"currentLevel"];
	} else {
		[[NSUserDefaults standardUserDefaults] setInteger:nextLevel forKey:@"currentLevel"];
	}
	
//	[self sparkleAt:ccp(384-8, levelHeight+64)];
}

- (void)update:(ccTime)dt {
	if(gameInProgress && [self numberOfRunningActions]) {
	}
//	if((hero1.position.y == 64 || hero2.position.y == 64) && cameraOffset.y > 0) {
//		cameraOffset = CGPointZero;
//		[self updateCamera];
//	}
	if(gameInProgress) {
		// standing on top

	}
    
    // When the vessel is moving, we need to move the camere position
    // Check the location of the mainbody for the vessel and move the camera accordingly
    //[gameLayer updateCamera];
    
    //Update the state of the Boids
	//if (boidLayer != nil)[boidLayer UpdateBoids];
    [gameLayer update:dt];
    /*
    [worldLayer update:dt];
    if (worldLayer->bodyPosition != nil)
    {
        gameLayer->cameraOffset.y = worldLayer->bodyPosition->y;
        gameLayer->cameraOffset.x = worldLayer->bodyPosition->x;
        [gameLayer updateCamera];
        //NSLog(@"self.position = (%f, %f)",gameLayer->cameraOffset.x,gameLayer->cameraOffset.y);
    }
    */
    [self updateUIPosition];
}

//- (void)registerWithTouchDispatcher {
//	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
//}

- (void)tapDownAt:(CGPoint)location {

	// menu button
	CGRect rect = CGRectMake(menuButton.position.x-32, menuButton.position.y-32+self.position.y, 64, 64);
	NSLog(@"tapDownAt (%f.1,%.1f)",location.x,location.y);
	NSLog(@"menuButton rect (%.1f,%.1f,%.1f,%.1f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
	if(CGRectContainsPoint(rect, location)) {
		[self showPopupMenu];
		return;
	}

	if(!gameInProgress) {
		[self resetLevel];
		return;
	}

	//lastTouchLocation = location;
	//location = ccpSub(location, self.position);
	
	//static float tapRadius = 64.0f;
	

}



#ifdef IOS
/*
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapDownAt:location];
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapMoveAt:location];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapUpAt:location];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapUpAt:location];
}
*/
#endif // IOS or MAC

- (void)sparkleAt:(CGPoint)p {
//	NSLog(@"sparkle");
	CCParticleSystem *ps = [CCParticleExplosion node];
	[self addChild:ps z:12];
	ps.texture = [[CCTextureCache sharedTextureCache] addImage:@"stars.png"];
//	ps.blendAdditive = YES;
	ps.position = p;
	ps.life = 1.0f;
	ps.lifeVar = 1.0f;
	ps.totalParticles = 60.0f;
	ps.autoRemoveOnFinish = YES;
}


- (void)updateUIPosition {
	float ny = sh-32-self.position.y;
	starIcon.position = ccp(starIcon.position.x,ny);
	starsCollectedLabel.position = ccp(starsCollectedLabel.position.x, ny);
	menuButton.position = ccp(menuButton.position.x,ny);
    //CCLOG(@"ny = %f",ny);
}

- (void)showPopupMenu {
	gameInProgress = NO;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Paused" message:nil delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Main Menu", nil];
	[alert show];
	[alert release];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 1) {
		// main menu
		//[[CCDirector sharedDirector] pushScene:[Intro scene]];
	} else {
		if([self getChildByTag:kTagLabel]) {
			// level completed or failed, nop
		} else {
			gameInProgress = YES;
		}
	}
}

#pragma Physics Initialization
// Create the World here
-(void) CreateWorld
{
    // Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	
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

@end

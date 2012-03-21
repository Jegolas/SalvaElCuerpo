//
//  ControllerLayer.mm
//  SalvaElCuerpo
//
//  Created by Jon on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ControllerLayer.h"

@implementation ControllerLayer
@synthesize leftJoystick;
@synthesize rightJoystick;
@synthesize debugLabel;
@synthesize batch1;

-(id)init{
	
	self = [super init];
	if (self != nil) {
		
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
		sw = screenSize.width;
		sh = screenSize.height;

        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = NO;
        
		// make a rect with the x/y position and width/height of the joystick
		// then create and initalize the joystick
		CGRect leftjoy = CGRectMake(0.0f, 0.0f, 128.0f, 128.0f);
		leftJoystick = [[[SneakyPad alloc] initWithRect:leftjoy] retain];
		//leftJoystick.tag = 1;
		CGRect rightJoy = CGRectMake(350.0f, 0.0f, 128.0f, 128.0f);
		rightJoystick = [[[SneakyPad alloc] initWithRect:rightJoy] retain];
		//leftJoystick.tag = 2;
        
		[self addChild:leftJoystick];
		[self addChild:rightJoystick];
		
		//[self addChild:_spriteManager z:15 tag:1];
		
		//AtlasSprite *bodysprite = [AtlasSprite spriteWithRect:CGRectMake(574, 170, 122, 80) spriteManager:_spriteManager];
		//[_spriteManager addChild:bodysprite];
		//[bodysprite setPosition:ccp(10.0, 50.0)];
		
		/*
         AtlasSprite *bodysprite = [AtlasSprite spriteWithRect:CGRectMake(574, 170, 122, 80) spriteManager:_spriteManager];
         [_spriteManager addChild:bodysprite];
         [bodysprite setPosition:ccp(10.0, 50.0)];
         [self addChild:bodysprite z:1];
         */
		// Create the pause button
		//pauseButton = [CCSprite spriteWithFile:@"Icon.png"];
		
		//[pauseButton setPosition:ccp(360.0, 250.0)];
		//[self addChild:pauseButton z:0];
		
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"dude" fontName:@"Arial" fontSize:10];
        label.color = ccc3(240, 0, 0);
        label.position = ccp(sw/2, sh*7/8-self.position.y);
        [self addChild:label z:12];
        debugLabel = [label retain];
         
        // sprite sheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
		batch1 = [[CCSpriteBatchNode alloc] initWithFile:@"sprites.png" capacity:50];
		[self addChild:batch1];
        
        CCSprite *sprite;
        // menu button
        sprite = [CCSprite spriteWithSpriteFrameName:@"menuButton.png"];
        sprite.position = ccp(sw-32,sh-32);
        //sprite.position = ccp(90.0, 50.0);
        [batch1 addChild:sprite z:50];
        menuButton = [sprite retain];

      
        // menu button
        /*
        sprite = [CCSprite spriteWithSpriteFrameName:@"grab.png"];
        //sprite.position = ccp(sw-32,sh-32);
        sprite.position = ccp(90.0, 50.0);
        [batch1 addChild:sprite z:50];
        */
        
        
        
		//[self schedule:@selector(tick:) interval:1.0f/120.0f];
	}
	return self;
}

//function to scale the velocity
-(CGPoint)scaleVelocity:(CGPoint)velocity withScale:(float)scale{
	return CGPointMake(scale * velocity.x,scale * velocity.y);
}

//function to apply a velocity to a position with delta
-(CGPoint)applyVelocity:(CGPoint)velocity toPosition:(CGPoint)position withDelta:(float)delta{
	return CGPointMake(position.x + velocity.x * delta, position.y + velocity.y * delta);
}

- (void)tapDownAt:(CGPoint)location {
    
	// menu button
	CGRect rect = CGRectMake(menuButton.position.x-32, menuButton.position.y-32+self.position.y, 64, 64);
	//NSLog(@"tapDownAt (%f.1,%.1f)",location.x,location.y);
	//NSLog(@"menuButton rect (%.1f,%.1f,%.1f,%.1f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
	if(CGRectContainsPoint(rect, location)) {
        NSLog(@"Inside the rectangle");
		[self showPopupMenu];
		//return;
	}
    
     /*
	if(!gameInProgress) {
		[self resetLevel];
		return;
	}
    */
	//lastTouchLocation = location;
	//location = ccpSub(location, self.position);
	
	//static float tapRadius = 64.0f;
	
    
}

// This menu needs to have a nice option where the user can opt to reset, main menu, etc.
- (void)showPopupMenu {
	//gameInProgress = NO;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Paused" message:nil delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Main Menu", nil];
	[alert show];
	[alert release];
}

-(void)tick:(float)delta {
	/*
     // grab the velocity from leftJoystick
     CGPoint velocity = leftJoystick.velocity;
     
     // create a velocity specific to the label
     // you can make many of these using the same initial velocity to do a parallax scrolling of sorts
     CGPoint labelVelocity = [self scaleVelocity:velocity withScale:480.0f];
     
     // apply the scaled velocity to the position over delta
     labelVelocity = [self applyVelocity:labelVelocity toPosition:helloWorldLabel.position withDelta:delta];
     
     // set the position
     helloWorldLabel.position = labelVelocity;
     */
}

//you have to set up the events for each joystick you make
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[leftJoystick touchesBegan:touches withEvent:event];
	[rightJoystick touchesBegan:touches withEvent:event];
    UITouch *touch =[touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	[self tapDownAt:location];
    /*
	// This should be pushed to it's own class like the joystick method
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	// remember to half the sprite width and height since the center point of the sprite is the absolute position
	CGRect pausetouchArea = CGRectMake(pauseButton.position.y - pauseButton.contentSize.width/2, pauseButton.position.x - pauseButton.contentSize.height/2, pauseButton.contentSize.width, pauseButton.contentSize.height);
	
    if (CGRectContainsPoint(pausetouchArea, point))
	{
		Global *global = [Global instance];
		global.game_paused = true;
	}
    */
	// End it should be...
	
	//return kEventHandled;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[leftJoystick touchesMoved:touches withEvent:event];
	[rightJoystick touchesMoved:touches withEvent:event];
	
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[leftJoystick touchesEnded:touches withEvent:event];
	[rightJoystick touchesEnded:touches withEvent:event];
    
}

- (void) dealloc
{
	// need to dealloc the joysticks here
    [menuButton release];
	[super dealloc];
	NSLog(@"Dealloc-ed controller");
}
@end

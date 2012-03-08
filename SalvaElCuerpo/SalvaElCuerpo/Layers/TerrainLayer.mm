//
//  TerrainLayer.mm
//  SalvaElCuerpo
//
//  Created by Jon on 3/7/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "TerrainLayer.h"

@implementation TerrainLayer

@synthesize bodyPosition = _bodyPosition;

-(CCSprite *)spriteWithColor:(ccColor4F)bgColor textureSize:(float)textureSize {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    
    
    // 3: Draw into the texture
    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2, textureSize/2);
    [noise visit];
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

- (ccColor4F)randomBrightColor {
    
    ccColor4B randomColor = ccColor4B(ccc4(0, 46, 184,255));
    return ccc4FFromccc4B(randomColor);
}

- (void)genBackground {
    
    [_background removeFromParentAndCleanup:YES];
    
    ccColor4F bgColor = [self randomBrightColor];
    _background = [self spriteWithColor:bgColor textureSize:512];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _background.position = ccp(winSize.width/2, winSize.height/2);
    
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [_background.texture setTexParameters:&tp];
    
    
    [self addChild:_background z:-1];
    
}

-(id) init {
    if((self=[super init])) {		        
        [self genBackground];
        self.isTouchEnabled = YES;        
    }
    //[self scheduleUpdate];
    //self.scale = 0.5;
    return self;
}

- (void)update:(ccTime)dt position:(CGPoint) bposition{
    
    float PIXELS_PER_SECOND = 600;
    
    float offset = bposition.x;
    offset += PIXELS_PER_SECOND * dt;
    
    float offsety = -1.0f*bposition.y;
    offsety += PIXELS_PER_SECOND * dt;
    
    CGSize textureSize = _background.textureRect.size;
    [_background setTextureRect:CGRectMake(offset, offsety, textureSize.width, textureSize.height)];
    //_bodyPosition = bposition;
    
    //[self setPosition:bposition];
    
}

@end

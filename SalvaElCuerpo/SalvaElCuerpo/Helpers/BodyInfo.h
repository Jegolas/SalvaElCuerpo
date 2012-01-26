//
//  BodyInfo.h
//  SalvaElCuerpo
//
//  Created by Jon on 1/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


typedef enum tagBody
{
	MainBody = 0,
	Person = 1,
	Sensor = 2,
	Engine = 3,
	Shark = 4
} Body;

@interface BodyInfo : NSObject 
{
	CGSize rect;
	id data;
	NSString * name;
	NSString * textureName;
	NSString * spriteName;
	CGPoint spriteOffset;
    
@public
	Body bodyType;
	BOOL touching;
	BOOL destroy;
    
    
}
@property(nonatomic,retain) id data;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * textureName;
@property(nonatomic,retain) NSString * spriteName;
@property CGSize rect;
@property CGPoint spriteOffset;
@property BOOL touching;
@property BOOL destroy;



@end

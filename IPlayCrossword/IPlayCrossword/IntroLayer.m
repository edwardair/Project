//
//  IntroLayer.m
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-4-29.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"

#import "TheStaticGameLayer.h"
#import "MainLayer.h"
#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{


    /*
     
     */
	[super onEnter];

	[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
//    CCScene *scene = [CCScene node];
//    [scene addChild:[TheStaticGameLayer shareGameLayer]];
//    CCScene *scene = [CCScene node];
//    [scene addChild:[MainLayer shareStaticMainLayer]];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainLayer node] withColor:ccWHITE]];
}
@end

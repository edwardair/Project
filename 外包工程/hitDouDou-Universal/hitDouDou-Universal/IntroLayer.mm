//
//  IntroLayer.m
//  hitDouDou-iPhone
//
//  Created by ZYJ on 12-9-21.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
//#import "GameLayer.h"
#import "GameMenuLayer.h"
#pragma mark - IntroLayer
#import "GameLayer.h"
#import "MenuLayer.h"
#import "WGCocos2d.h"
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

-(void) onEnter
{
    
//    [WGDecompilationPlist DecomplilationPlist:@"Game_Resources-hd.plist"];
    
    #define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	[super onEnter];
    	
    CCSprite *background = [CCSprite spriteWithFile:@"CopyRight.png"];
    background.anchorPoint = CGPointZero;

	// add the label as a child to this Layer
	[self addChild: background];
    
    [self scheduleOnce:@selector(makeTransition:) delay:2.f];

}
-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer node] withColor:ccWHITE]];
}
@end

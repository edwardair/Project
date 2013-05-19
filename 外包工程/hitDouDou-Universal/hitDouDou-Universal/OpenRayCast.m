//
//  OpenRayCast.m
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-11-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "OpenRayCast.h"
#import "GameLabel.h"
@interface OpenRayCast(){
    NSUserDefaults *defaults;
}
@end

@implementation OpenRayCast
- (id)init{
    if (self == [super init]) {
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        defaults = [NSUserDefaults standardUserDefaults];

        CCMenuItemFont * toggleOn = [CCMenuItemFont itemWithString:@"ON"];
        CCMenuItemFont * toggleOFF = [CCMenuItemFont itemWithString:@"OFF"];

        toggleOn.color = ccGREEN;
        toggleOFF.color = ccRED;
        
        CCMenuItemToggle * item = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuitem2Touched) items:toggleOn,toggleOFF, nil];
        item.position = ccp(winSize.width, 0);
        item.anchorPoint = ccp(1, 0);

        CCMenu * menu = [CCMenu menuWithItems:item, nil];
        menu.position =CGPointZero;
        [self addChild:menu];
        
        if (OPEN) {
            [item setSelectedIndex:0];
        }else [item setSelectedIndex:1];

    }
    return self;
}
- (void)subCount{
    _labelLayer.rayCastNumber -= 1;
}
- (void)menuitem2Touched{
    SETOC;
}
- (void)dealloc{
    self.labelLayer = nil;
    [super dealloc];
}
@end

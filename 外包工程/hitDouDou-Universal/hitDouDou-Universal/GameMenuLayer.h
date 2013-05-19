//
//  GameMenu.h
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-10-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol delegateGameStart;

@interface GameMenuLayer: CCLayer {
    id<delegateGameStart> delegate;
}
@property (nonatomic,assign) id<delegateGameStart> delegate;
@end

@protocol delegateGameStart
- (void)gameFirstStart;
@end
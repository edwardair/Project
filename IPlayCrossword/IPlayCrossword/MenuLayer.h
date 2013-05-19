//
//  MenuLayer.h
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-5-6.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WGCocos2d.h"

@protocol menuLayerDelegate;

@interface MenuLayer : WGLayer {
    id<menuLayerDelegate> delegate;
}
@property (nonatomic,assign) id<menuLayerDelegate> delegate;
+(id )initializeWithIndex:(int )index;
@end

@protocol menuLayerDelegate <NSObject>
@required
- (void)showXiaoChao;
- (void)showDaChao;

- (void)saveCurPuzzleWithIndex:(int )index;
- (void)submitPuzzle;
@end

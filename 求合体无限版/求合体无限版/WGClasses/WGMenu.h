//
//  WGMenuSprite.h
//  Classes
//
//  Created by ZYJ on 13-1-22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface WGMenu : CCMenu {

}

+(id) menuWithNames: (NSString *) name, ...;
- (void)setItemsPosition:(CGPoint ) p, ...;
- (void)setMenuParent:(id )parent;
- (void)setMenuParent:(id )parent z:(int )zOrder;
- (void)addTarget:(id )target selecotr:(SEL )selector;
@end

@interface WGMenuItem : CCMenuItem

//index 代表 item在CCMenu 父节点中是第几个子节点 从0开始
@property (nonatomic,assign) int index;

@end


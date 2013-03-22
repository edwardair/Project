//
//  AvtionManager.h
//  求合体无限版
//
//  Created by ZYJ on 13-3-12.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ActionManage : CCActionInterval {
    
}
+(void)preCheckActionWithArray:(NSMutableArray *)array centerPos:(CGPoint )center;
+(void)stopObjectAllActions:(NSMutableArray *)array;
+(void)removeObjectWithArray:(NSMutableArray *)array centerPos:(CGPoint )center;
@end

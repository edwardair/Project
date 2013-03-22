//
//  MyCocos2DClass.h
//  求合体无限版
//
//  Created by ZYJ on 13-3-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "WGCocos2d.h"
#import "OneObject.h"
@interface GameMainScene : WGLayer <OneObjectDelegate>{
    
}
@property (nonatomic,retain) NSMutableDictionary *worldObjectDic;
@end

//
//  WGWritePlist.h
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-4-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WGWritePlist : CCNode {
    
}
+ (void)writePlistWithObj:(NSArray *)objArray
                      key:(NSArray *)keyArray
                plistName:(NSString *)plistName;
+(NSMutableDictionary *)readPlist:(NSString *)plistName;
@end

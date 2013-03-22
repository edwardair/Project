//
//  MapShow.h
//  求合体无限版
//
//  Created by ZYJ on 13-3-13.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WGCocos2d.h"
#import "OneObject.h"

@interface MapShow : WGSprite {
    
}
@property (nonatomic,retain) NSString *mapBlockType;
@property (nonatomic,retain) NSString *mapBlockName;
//@property (nonatomic,assign) int typeOfObjOnBolck;

+(id )initWithType:(NSString *)name;
- (void)handleErgodicWithDic:(NSMutableDictionary *)dic;
@end

@interface Storage : WGSprite {
    
}
@property (nonatomic,retain) OneObject *storedObj;
@end
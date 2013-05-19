//
//  playVideo.h
//  Ten_Snow
//
//  Created by YJ Z on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WGCocos2d.h"
#define BLUE @"PblueCurtain_001.png"
#define RED @"PredCurtain_001.png"

//#import "CCLayer.h"
@interface WGPlayVideo : NSObject

//@property (nonatomic, assign) NSString *soundName;
+(void)setSoundName:(NSString *)name;
+ (void)playMovie:(NSString *)mp4FileName_
            kuang:(NSString *)coverFileName_
             text:(NSString *)textFileName_
        animation:(NSString *)aniFileName_;

@end

//
//  SBJsonResolveData.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-29.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBJsonResolveData : NSObject
@property (strong,nonatomic) NSMutableArray *meetingNameList;
@property (strong,nonatomic) NSMutableArray *meetingId;
+(SBJsonResolveData *)shareMeeting;
+(void )updateUrlData;
@end

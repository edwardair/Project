//
//  UAndDLoad.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-27.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HYName @"hy.hyname" //会议名称
#define HYAddress @"hy.hydz"//会议地址
#define HYStartTime @"hy.hystarttime"//会议开始时间
#define HYEndTime @"hy.hyendtime"//会议结束时间
#define HYZBF @"hy.hyzbf"//会议名称
#define HYXBF @"hy.hyxbf"//会议名称
//#define HYType @"hy.hyzt"//会议类型
#define HYTheme @"hy.hyzt"//会议名称
#define HYRequirments @"hy.hyxq"//会议名称

#define ModifyData @"http://192.168.8.215:8088/GZHWV/hy_huiyiAdd.action"
#define GetMeetingList @"http://192.168.8.215:8088/GZHWV/sms_resetSms"

@interface UAndDLoad : NSObject
+(NSData *)upLoad:(NSMutableDictionary *)params withURL:(NSString *)url;
+(void)test;

+ (NSData *)downLoadWithUrl:(NSString *)urlString;
@end

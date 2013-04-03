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

//HTTP Address
#define HTTP @"http://192.168.8.215:8088/GZHWV/"
//新建会议
#define Url_ModifyData [NSString stringWithFormat:@"%@%@",HTTP,@"hy_huiyiAdd.action"]
//获取所有会议名称
#define Url_GetMeetingList [NSString stringWithFormat:@"%@%@",HTTP,@"sms_resetSms"]
//获取此会议所有成员
#define Url_GetMeetingMembers(id) 	[NSString stringWithFormat:@"%@%@%d",HTTP,@"chdb_findChdbByHyId?chdb.hyid=",id]
//删除此会议中的成员
#define Url_DeleteMeetingMember [NSString stringWithFormat:@"%@%@",HTTP,@"chdb_chdbDelById.action"]
//修改此会议中的成员
#define Url_ModifyMeetingMember [NSString stringWithFormat:@"%@%@",HTTP,@"chdb_chdbUpdate.action"]
//添加此会议中的成员
#define Url_AddMeetingMember [NSString stringWithFormat:@"%@%@",HTTP,@"chdb_chdbAdd.action"]

@interface UAndDLoad : NSObject
+(NSData *)upLoad:(NSMutableDictionary *)params withURL:(NSString *)url;
+(void)test;

+ (NSData *)downLoadWithUrl:(NSString *)urlString;

+(NSData *)updateAllMeetingNames;
+ (NSData *)updateThisMeetingMembers:(int )index;
+ (void)deleteMemberWithId:(NSString *)idStr;
+ (void)addMemberWithHyid:(NSString *)idStr
                     Name:(NSString *)name
                      sex:(int )man
                      tel:(NSString *)tel
                     post:(NSString *)post;
+ (void)modifyMemberWithId:(NSString *)idStr
                      name:(NSString *)name
                       sex:(int )man
                       tel:(NSString *)tel
                      post:(NSString *)post;
@end

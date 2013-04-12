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
//登入
#define Url_LogIn [NSString stringWithFormat:@"%@%@",HTTP,@"login_toLogin.action"]

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
//获取此会议的分组情况
#define Url_GetMeetingGroups(idStr) [NSString stringWithFormat:@"%@%@%@",HTTP,@"dbfz_findDbfz?dbfz.hyid=",idStr]
//添加此会议一个分组
#define Url_AddMeetingGroup [NSString stringWithFormat:@"%@%@",HTTP,@"dbfz_dbfzAdd"]
//删除此会议一个分组
#define Url_DeleteMeetingGroup [NSString stringWithFormat:@"%@%@",HTTP,@"dbfz_dbfzDelBatch"]
//指定分组中获取分组成员
#define Url_GetGroupMembers [NSString stringWithFormat:@"%@%@",HTTP,@"dbfzcy_findFzcyByFenzuId"]
//指定分组中添加分组成员
#define Url_AddGroupMember [NSString stringWithFormat:@"%@%@",HTTP,@"dbfzcy_fzcyAdd"]
//指定分组中删除成员
#define Url_DeleteGroupMember [NSString stringWithFormat:@"%@%@",HTTP,@"dbfzcy_fzcyDel"]

//获取指定会议中所有议程
#define Url_GetMeetingAllMeetings [NSString stringWithFormat:@"%@%@",HTTP,@"yc_findYclistByHyid"]
//指定会议中添加 议程
#define Url_AddMeetingOneAgenda [NSString stringWithFormat:@"%@%@",HTTP,@"yc_addYc"]
//指定会议中 编辑指定议程 
#define Url_ModifyMeetingAgenda [NSString stringWithFormat:@"%@%@",HTTP,@"yc_updateYc"]
//指定会议中 删除指定议程
#define Url_DeleteMeetingAgenda [NSString stringWithFormat:@"%@%@",HTTP,@"yc_deleteYc"]

@interface UAndDLoad : NSObject
+(NSData *)upLoad:(NSMutableDictionary *)params withURL:(NSString *)url;
+(void)test;

+ (NSData *)downLoadWithUrl:(NSString *)urlString;

+(NSData *)logInWithAccount:(NSString *)a secret:(NSString *)s;
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
+ (NSData *)getPointMeetingGroupsWithIndex:(NSString *)idStr;
+(NSData *)addPointMeetingOneGroupWithHyid:(NSString *)hyid
                                 GroupCode:(NSString *)code
                                 GroupName:(NSString *)name
                                 GroupMark:(NSString *)mark;
+(NSData *)deletePointMeetingGroupWithId:(NSString *)idStr;
+(NSData *)getPointGroupMembersWithId:(NSString *)FenZuId;
+(NSData *)addPointGroupWithHyId:(NSString *)hyId
                         groupId:(NSString *)groupId
                        memberId:(NSString *)memberId;
+(NSData *)deletePointGroupMemberWithFZCYString:(NSString *)idStr;
+(NSData *)getPointMeetingAllMeetingsWithIndex:(NSString *)idStr;
+(NSData *)addPointMeetingOneAgendaWithHyID:(NSString *)idStr
                                       YCXX:(NSString *)ycxx;
+(NSData *)modifyPointMeetingOneAgendaWithHyID:(NSString *)idStr
                                       YCXX:(NSString *)ycxx;
+(NSData *)deletePointMeetingOneAgendaWithHyId:(NSString *)hyid
                                      AgendaId:(NSString *)agendaid;
@end

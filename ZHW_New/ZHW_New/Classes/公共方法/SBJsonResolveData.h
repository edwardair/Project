//
//  SBJsonResolveData.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-29.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CHDBName @"chdbname"
#define CHDBLxdh @"chdblxdh"
#define CHDBZw @"chdbzw"
#define CHDBXb @"chdbxb"
#define CHDBId @"id"
#define CHDBHyid @"hyid"
#define CHDBCode @"chdbcode"

#define DBFZList @"dbfzList"
#define DBFZCode @"dbfzcode"
#define DBFZName @"dbfzname"
#define DBFZCreatetime @"dbfzcreatetime"
#define DBFZRemark @"dbfzremark"

#define YCName @"ycname"
#define YCFZR @"yclxrsj"
#define YCContent @"ycjj"
#define YCStartTime @"ycstarttime"
#define YCEndTime @"ycendtime"
#define YCTel @"yclxrdh"

@interface SBJsonResolveData : NSObject
@property (strong,nonatomic) NSMutableArray *meetingNameList;
//@property (strong,nonatomic) NSMutableArray *meetingId;

@property (strong,nonatomic) NSMutableArray *thisMeetingMembers;

@property (strong,nonatomic) NSMutableArray *pointMeetingGroups;

@property (strong,nonatomic) NSMutableArray *pointGroupMembers;

@property (strong,nonatomic) NSMutableArray *agenda;

+(SBJsonResolveData *)shareMeeting;
+(NSString *)logInWithAccount:(NSString *)a secret:(NSString *)s;
+ (void)createOneNewMeetingWithParams:(NSMutableDictionary *)params;
+(void )updateAllMeetingNames;
+ (void)updateThisMeetingMembersWithIndex:(int )index;
+ (void )getMeetingMembers:(int )index;
+(BOOL )deletePoitMeetingWithIndex:(int )index;
+(BOOL )addPointMeetingWithIndex:(int )index
                           Name:(NSString *)name
                            Sex:(int )sex
                            Tel:(NSString *)tel
                           Post:(NSString *)post;
+(BOOL)modifyPointMeetingWithIndex:(int )index
                              Name:(NSString *)name
                               Sex:(int )sex
                               Tel:(NSString *)tel
                              Post:(NSString *)post;
+(void)getPointMeetingOfGroupsWithIndex:(int )index;
+ (BOOL )addPointMeetingWithIndex:(int)index
                            Code:(NSString *)code
                            Name:(NSString *)name
                            Mark:(NSString *)mark;
+ (BOOL )deletePointMeetingGroupWithIndex:(int )index;
+ (void )GetPointMeetingGroupMemberWithIndex:(int )index;
+ (BOOL )addPointMeetingGroupMemberWithMeetingIndex:(int )MI
                                        GroupIndex:(int )GI
                                       MemberIndex:(NSString *)MeI;
+ (BOOL )deletePointMeetingGroupMemberWithIndex:(int )index;
+ (void)getMeetingAllMeetingsWithIndex:(int )index;
+ (BOOL)addPointMeetingOneAgendaWithHyIndex:(int )index
                                     ycName:(NSString *)name
                                       hcJJ:(NSString *)jj
                                       info:(NSString *)info
                                        msg:(NSString *)msg
                                      ycLXR:(NSString *)lxr
                                      ycTel:(NSString *)tel
                                     bdfzId:(int )bdfzIndex;
+ (BOOL)modifyPointMeetingOneAgendaWithHyIndex:(int )index
                                   agendaIndex:(int )agendaIndex
                                     ycName:(NSString *)name
                                       hcJJ:(NSString *)jj
                                       info:(NSString *)info
                                        msg:(NSString *)msg
                                      ycLXR:(NSString *)lxr
                                      ycTel:(NSString *)tel
                                     bdfzId:(int )bdfzIndex;
+(BOOL)deletePointMeetingOneAgendaWithHyIndex:(int )hyIndex
                                  AgendaIndex:(int )agendaIndex;
@end

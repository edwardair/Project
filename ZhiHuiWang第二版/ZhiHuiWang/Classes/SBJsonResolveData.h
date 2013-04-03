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

#define DBFZList @"dbfzList"
#define DBFZCode @"dbfzcode"
#define DBFZName @"dbfzname"
#define DBFZCreatetime @"dbfzcreatetime"
#define DBFZRemark @"dbfzremark"

@interface SBJsonResolveData : NSObject
@property (strong,nonatomic) NSMutableArray *meetingNameList;
@property (strong,nonatomic) NSMutableArray *meetingId;

@property (strong,nonatomic) NSMutableArray *thisMeetingMembers;

@property (strong,nonatomic) NSMutableArray *pointMeetingGroups;

+(SBJsonResolveData *)shareMeeting;
+(void )updateAllMeetingNames;
+ (void)updateThisMeetingMembersWithIndex:(int )index;
+ (void )getMeetingMembers:(int )index;
+(void)deletePoitMeetingWithIndex:(int )index;
+(void)addPointMeetingWithIndex:(int )index
                           Name:(NSString *)name
                            Sex:(int )sex
                            Tel:(NSString *)tel
                           Post:(NSString *)post;
+(void)modifyPointMeetingWithIndex:(int )index
                              Name:(NSString *)name
                               Sex:(int )sex
                               Tel:(NSString *)tel
                              Post:(NSString *)post;
+(void)getPointMeetingOfGroupsWithIndex:(int )index;
@end

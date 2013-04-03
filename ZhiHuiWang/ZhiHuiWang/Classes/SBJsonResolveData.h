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
@interface SBJsonResolveData : NSObject
@property (strong,nonatomic) NSMutableArray *meetingNameList;
@property (strong,nonatomic) NSMutableArray *meetingId;

@property (strong,nonatomic) NSMutableArray *thisMeetingMembers;
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
@end

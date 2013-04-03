//
//  SBJsonResolveData.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-29.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "SBJsonResolveData.h"
#import "SBJson.h"
#import "UAndDLoad.h"
static SBJsonResolveData *staticSBJsonResolveData = nil;
@implementation SBJsonResolveData
@synthesize meetingNameList = _meetingNameList;
@synthesize thisMeetingMembers = _thisMeetingMembers;
+(SBJsonResolveData *)shareMeeting{
    if (!staticSBJsonResolveData) {
        staticSBJsonResolveData = [[SBJsonResolveData alloc]init];
    }
    
    return staticSBJsonResolveData;
}
//更新所有会议名称 及对应的id
+(void )updateAllMeetingNames{
    NSData *data = [UAndDLoad updateAllMeetingNames];
    [SBJsonResolveData getMeetingData:data];
}

- (NSMutableArray *)meetingNameList{
    if (!_meetingNameList) {
        _meetingNameList = [[NSMutableArray alloc]init];
    }
    return _meetingNameList;
}
- (void)setMeetingNameList:(NSMutableArray *)meetingNameList{
    [SBJsonResolveData updateAllMeetingNames];
}

- (NSMutableArray *)meetingId{
    if (!_meetingId) {
        _meetingId = [[NSMutableArray alloc]init];
    }
    return _meetingId;
}

- (NSMutableArray *)thisMeetingMembers{
    if (!_thisMeetingMembers) {
        _thisMeetingMembers = [[NSMutableArray alloc]init];
    }
    return _thisMeetingMembers;
}
- (void)setThisMeetingMembers:(NSMutableArray *)thisMeetingMembers{
    [staticSBJsonResolveData.thisMeetingMembers removeAllObjects];
    int index = [[thisMeetingMembers objectAtIndex:0] intValue];
    [SBJsonResolveData getMeetingMembers:index];
}
- (NSMutableArray *)pointMeetingGroups{
    if (!_pointMeetingGroups) {
        _pointMeetingGroups = [[NSMutableArray alloc]init];
    }
    return _pointMeetingGroups;
}
#pragma mark SBJson解析 会议名称
+ (void )getMeetingData:(NSData *)data{
    [staticSBJsonResolveData.meetingNameList removeAllObjects];
    [staticSBJsonResolveData.meetingId removeAllObjects];

    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *dic = [jsonObject objectWithString:str];
    
    NSArray *listDic = [dic objectForKey:@"hylist"];
    
    for (NSDictionary *objDic in listDic) {
        NSString *meetingName = [objDic objectForKey:@"hyname"];
        NSNumber *meetingId = [NSNumber numberWithInt:[[objDic objectForKey:@"id"] intValue]];
        [staticSBJsonResolveData.meetingNameList addObject:meetingName];
        [staticSBJsonResolveData.meetingId addObject:meetingId];

    }
}
#pragma mark  SBJson解析 会议人员
+ (void)updateThisMeetingMembersWithIndex:(int )index{
    [staticSBJsonResolveData setThisMeetingMembers:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:index]]];

}
+ (void )getMeetingMembers:(int )index{
    [staticSBJsonResolveData.thisMeetingMembers removeAllObjects];
    
    NSData *data = [UAndDLoad updateThisMeetingMembers:[[staticSBJsonResolveData.meetingId objectAtIndex:index] intValue]];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *orgDic = [jsonObject objectWithString:str];

    NSArray *firstArray = [orgDic objectForKey:@"chdbList"];
//    NSLog(@"%@",firstArray);

    for (NSDictionary *subDic in firstArray) {
        NSMutableDictionary *arrayWithDics_SubDic =
        [SBJsonResolveData memberWithName:[subDic objectForKey:CHDBName]
                                      Tel:[subDic objectForKey:CHDBLxdh]
                                     Post:[subDic objectForKey:CHDBZw]
                                      Sex:[subDic objectForKey:CHDBXb]
                                   ChdbId:[subDic objectForKey:CHDBId]
                                     Hyid:[subDic objectForKey:CHDBHyid]];
        
        [staticSBJsonResolveData.thisMeetingMembers addObject:arrayWithDics_SubDic];

    }
    
}
+ (NSMutableDictionary *)memberWithName:(NSString *)name
                                    Tel:(NSString *)tel
                                   Post:(NSString *)post
                                    Sex:(NSString *)sex
                                 ChdbId:(NSString *)chdbid
                                   Hyid:(NSString *)hyid{
    NSMutableDictionary *arrayWithDics_SubDic = [NSMutableDictionary dictionary];
    
    [arrayWithDics_SubDic setObject:name forKey:CHDBName];//名称
    [arrayWithDics_SubDic setObject:tel forKey:CHDBLxdh];//电话
    [arrayWithDics_SubDic setObject:post forKey:CHDBZw];//职位
    [arrayWithDics_SubDic setObject:[NSNumber numberWithInt:[sex intValue]] forKey:CHDBXb];//性别  1为男  0为女
    [arrayWithDics_SubDic setObject:chdbid forKey:CHDBId];//id
    [arrayWithDics_SubDic setObject:hyid forKey:CHDBHyid];//hyid
    return arrayWithDics_SubDic;
}
#pragma mark 删除 指定会议中 单个成员
+(void)deletePoitMeetingWithIndex:(int )index{
    NSString *idStr = [[staticSBJsonResolveData.thisMeetingMembers objectAtIndex:index] objectForKey:CHDBId];
    [UAndDLoad deleteMemberWithId:idStr];

    [staticSBJsonResolveData.thisMeetingMembers removeObjectAtIndex:index];
    
}
#pragma mark 增加 指定会议中 单个成员
+(void)addPointMeetingWithIndex:(int )index
                           Name:(NSString *)name
                            Sex:(int )sex
                            Tel:(NSString *)tel
                           Post:(NSString *)post{
    int hyid = [[staticSBJsonResolveData.meetingId objectAtIndex:index] intValue];
    
    NSString *idStr = [NSString stringWithFormat:@"%d",hyid];
    
    [UAndDLoad addMemberWithHyid:idStr
                            Name:name
                             sex:sex
                             tel:tel
                            post:post];
    
    [SBJsonResolveData updateThisMeetingMembersWithIndex:index];
    
}
#pragma mark 编辑 指定会议中 单个成员
+(void)modifyPointMeetingWithIndex:(int )index
                              Name:(NSString *)name
                               Sex:(int )sex
                               Tel:(NSString *)tel
                              Post:(NSString *)post{
    
    NSString *idStr = [[staticSBJsonResolveData.thisMeetingMembers objectAtIndex:index] objectForKey:CHDBId];
    NSString *hyidStr = [[staticSBJsonResolveData.thisMeetingMembers objectAtIndex:index] objectForKey:CHDBHyid];

    
    [UAndDLoad modifyMemberWithId:idStr
                             name:name
                              sex:sex
                              tel:tel
                             post:post];

    NSMutableDictionary *member = [SBJsonResolveData memberWithName:name Tel:tel Post:post Sex:[NSString stringWithFormat:@"%d",sex] ChdbId:idStr Hyid:hyidStr];
    
    [staticSBJsonResolveData.thisMeetingMembers replaceObjectAtIndex:index withObject:member];

}

#pragma mark 获取指定会议中 分组情况
+(NSMutableDictionary *)groupWithId:(NSString *)idStr
                               Code:(NSString *)code
                                 Name:(NSString *)name
                           CreateTime:(NSString *)time
                                 Mark:(NSString *)mark{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:code forKey:DBFZCode];
    [dic setObject:name forKey:DBFZName];
    [dic setObject:time forKey:DBFZCreatetime];
    [dic setObject:mark forKey:DBFZRemark];
     return dic;
}
+(void)getPointMeetingOfGroupsWithIndex:(int )index{
    [staticSBJsonResolveData.pointMeetingGroups removeAllObjects];
    
    NSString *idStr = [staticSBJsonResolveData.meetingId objectAtIndex:index];
    NSData *data = [UAndDLoad getPointMeetingGroupsWithIndex:idStr];
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *orgDic = [jsonObject objectWithString:dataString];

    NSArray *dbfzList = [orgDic objectForKey:DBFZList];
    
    for (NSDictionary *dic in dbfzList) {
        NSMutableDictionary *mutableDic = [SBJsonResolveData groupWithId:[dic objectForKey:@"id"]
                                                                    Code:[dic objectForKey:DBFZCode]
                                                                    Name:[dic objectForKey:DBFZName]
                                                              CreateTime:[dic objectForKey:DBFZCreatetime]
                                                                    Mark:[dic objectForKey:DBFZRemark]];
        [staticSBJsonResolveData.pointMeetingGroups addObject:mutableDic];
    }
    
}
#pragma mark 在指定会议中添加一个分组
+ (void)addPointMeetingWithIndex:(int)index
                            Code:(NSString *)code
                            Name:(NSString *)name
                            Mark:(NSString *)mark{
    NSString *idStr = [staticSBJsonResolveData.meetingId objectAtIndex:index];
    NSData *data = [UAndDLoad addPointMeetingOneGroupWithHyid:idStr
                                                    GroupCode:code
                                                    GroupName:name
                                                    GroupMark:mark];
    
}
@end

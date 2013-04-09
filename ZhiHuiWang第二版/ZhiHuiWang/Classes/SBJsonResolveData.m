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
- (NSMutableArray *)pointGroupMembers{
    if (!_pointGroupMembers) {
        _pointGroupMembers = [[NSMutableArray alloc]init];
    }
    return _pointGroupMembers;
}
- (NSMutableArray *)agenda{
    if (!_agenda) {
        _agenda = [[NSMutableArray alloc]init];
    }
    return _agenda;
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
                                     Hyid:[subDic objectForKey:CHDBHyid]
                                     Code:[subDic objectForKey:CHDBCode]];
        
        [staticSBJsonResolveData.thisMeetingMembers addObject:arrayWithDics_SubDic];

    }
    
}
+ (NSMutableDictionary *)memberWithName:(NSString *)name
                                    Tel:(NSString *)tel
                                   Post:(NSString *)post
                                    Sex:(NSString *)sex
                                 ChdbId:(NSString *)chdbid
                                   Hyid:(NSString *)hyid
                                   Code:(NSString *)code{
    NSMutableDictionary *arrayWithDics_SubDic = [NSMutableDictionary dictionary];
    
    [arrayWithDics_SubDic setObject:name forKey:CHDBName];//名称
    [arrayWithDics_SubDic setObject:tel forKey:CHDBLxdh];//电话
    [arrayWithDics_SubDic setObject:post forKey:CHDBZw];//职位
    [arrayWithDics_SubDic setObject:[NSNumber numberWithInt:[sex intValue]] forKey:CHDBXb];//性别  1为男  0为女
    [arrayWithDics_SubDic setObject:chdbid forKey:CHDBId];//id
    [arrayWithDics_SubDic setObject:hyid forKey:CHDBHyid];//hyid
    [arrayWithDics_SubDic setObject:code forKey:CHDBCode];//hyid

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

    NSMutableDictionary *member = [SBJsonResolveData memberWithName:name Tel:tel Post:post Sex:[NSString stringWithFormat:@"%d",sex] ChdbId:idStr Hyid:hyidStr Code:@"code"];
    
    [staticSBJsonResolveData.thisMeetingMembers replaceObjectAtIndex:index withObject:member];

}

#pragma mark 获取指定会议中 分组情况
+(NSMutableDictionary *)groupWithId:(NSString *)idStr
                               Code:(NSString *)code
                                 Name:(NSString *)name
                           CreateTime:(NSString *)time
                                 Mark:(NSString *)mark{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:idStr forKey:@"id"];
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
//    NSLog(@"%@",dbfzList);
    for (NSDictionary *dic in dbfzList) {
        NSMutableDictionary *mutableDic = [SBJsonResolveData groupWithId:[dic objectForKey:CHDBId]
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
    [UAndDLoad addPointMeetingOneGroupWithHyid:idStr
                                                    GroupCode:code
                                                    GroupName:name
                                                    GroupMark:mark];
//    data = nil;
    
}
#pragma mark 制定会议 删除一个分组
+ (void)deletePointMeetingGroupWithIndex:(int )index{
    NSString *idStr = [[staticSBJsonResolveData.pointMeetingGroups objectAtIndex:index] objectForKey:@"id"];
  [UAndDLoad deletePointMeetingGroupWithId:idStr];
//    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
    [staticSBJsonResolveData.pointMeetingGroups removeObjectAtIndex:index];
}
#pragma mark 指定会议中  指定分组  获取分组成员
+(NSMutableDictionary *)memberWithId:(NSString *)idStr
                               Code:(NSString *)code
                               Name:(NSString *)name
                         Post:(NSString *)post
                               tel:(NSString *)tel
                        memberCHDBId:(NSString *)chdbId{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:idStr forKey:@"id"];
    [dic setObject:code forKey:CHDBCode];
    [dic setObject:name forKey:CHDBName];
    [dic setObject:post forKey:CHDBZw];
    [dic setObject:tel forKey:CHDBLxdh];
    [dic setObject:chdbId forKey:@"chdbid"];

    return dic;
}

+ (void )GetPointMeetingGroupMemberWithIndex:(int )index{
    
    [staticSBJsonResolveData.pointGroupMembers removeAllObjects];
    
    NSString *idStr = [[staticSBJsonResolveData.pointMeetingGroups objectAtIndex:index] objectForKey:@"id"];
    NSData *data = [UAndDLoad getPointGroupMembersWithId:idStr];

    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *orgDic = [jsonObject objectWithString:dataString];
    NSArray *fzcyList = [orgDic objectForKey:@"fzcyList"];
//    NSLog(@"%@",fzcyList);

    for (NSDictionary *dic in fzcyList) {
        NSMutableDictionary *mutableDic = [SBJsonResolveData memberWithId:[dic objectForKey:CHDBId]
                                                                     Code:[dic objectForKey:CHDBCode]
                                                                     Name:[dic objectForKey:CHDBName]
                                                                     Post:[dic objectForKey:CHDBZw]
                                                                      tel:[dic objectForKey:CHDBLxdh]
                                                             memberCHDBId:[dic objectForKey:@"chdbid"]];
        [staticSBJsonResolveData.pointGroupMembers addObject:mutableDic];
    }
}
#pragma mark 指定会议中  指定分组  添加分组成员
+ (void)addPointMeetingGroupMemberWithMeetingIndex:(int )MI
                                        GroupIndex:(int )GI
                                       MemberIndex:(NSString *)MeI{
    [UAndDLoad addPointGroupWithHyId:staticSBJsonResolveData.meetingId[MI]
                                            groupId:[staticSBJsonResolveData.pointMeetingGroups[GI] objectForKey:CHDBId]
                                           memberId:MeI];
//    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}
#pragma mark 指定会议中 指定分组 删除分组成员
+ (void)deletePointMeetingGroupMemberWithIndex:(int )index{
    NSString *idStr = [[staticSBJsonResolveData.pointGroupMembers objectAtIndex:index] objectForKey:CHDBId];
    [UAndDLoad deletePointGroupMemberWithFZCYString:idStr];
//    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

#pragma mark 指定会议中 获取所有议程
+ (void)getMeetingAllMeetingsWithIndex:(int )index{
    [staticSBJsonResolveData.agenda removeAllObjects];
    
    NSString *idStr = [staticSBJsonResolveData.meetingId objectAtIndex:index];
    NSData *data = [UAndDLoad getPointMeetingAllMeetingsWithIndex:idStr];
    
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *orgDic = [jsonObject objectWithString:dataString];

    NSArray *ycList = [orgDic objectForKey:@"yclist"];

    for (NSDictionary *dic in ycList) {
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        
        NSString *ycName = [dic objectForKey:YCName];
        NSString *yclxrsj = [dic objectForKey:YCFZR];
        NSString *content = [dic objectForKey:YCContent];
        NSString *tel = [dic objectForKey:YCTel];
        NSString *start = [dic objectForKey:YCStartTime];
        NSString *end = [dic objectForKey:YCEndTime];
        NSString *agendaId = [dic objectForKey:@"id"];
        NSString *contactedGroup = [dic objectForKey:@"dbfzid"];

        [temp setObject:ycName forKey:YCName];
        [temp setObject:yclxrsj forKey:YCFZR];
        [temp setObject:content forKey:YCContent];
        [temp setObject:tel forKey:YCTel];
        [temp setObject:start forKey:YCStartTime];
        [temp setObject:end forKey:YCEndTime];
        [temp setObject:agendaId forKey:@"id"];
        [temp setObject:contactedGroup forKey:@"dbfzid"];

        [staticSBJsonResolveData.agenda addObject:temp];
    }
}

#pragma mark 指定会议添加  一个议程
+ (void)addPointMeetingOneAgendaWithHyIndex:(int )index
                                     ycName:(NSString *)name
                                       hcJJ:(NSString *)jj
                                       info:(NSString *)info
                                        msg:(NSString *)msg
                                      ycLXR:(NSString *)lxr
                                      ycTel:(NSString *)tel
                                     bdfzId:(int )bdfzIndex{
    NSString *hyId = staticSBJsonResolveData.meetingId[index];
    NSString *groupId = [staticSBJsonResolveData.pointMeetingGroups[bdfzIndex] objectForKey:CHDBId];
    NSString *idStr = [NSString stringWithFormat:@"%@;%@;;;%@;%@;%@;%@;%@;%@",hyId,name,jj,info,msg,lxr,tel,groupId];
//    NSLog(@"%@",idStr);
    [UAndDLoad addPointMeetingOneAgendaWithHyID:hyId YCXX:idStr];
//    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

#pragma mark 指定会议添加  一个议程
+ (void)modifyPointMeetingOneAgendaWithHyIndex:(int )index
                                   agendaIndex:(int )agendaIndex
                                     ycName:(NSString *)name
                                       hcJJ:(NSString *)jj
                                       info:(NSString *)info
                                        msg:(NSString *)msg
                                      ycLXR:(NSString *)lxr
                                      ycTel:(NSString *)tel
                                     bdfzId:(int )bdfzIndex{
    
    NSString *hyId = staticSBJsonResolveData.meetingId[index];
    NSString *groupId = [staticSBJsonResolveData.pointMeetingGroups[bdfzIndex] objectForKey:CHDBId];
    NSString *agendaId = [staticSBJsonResolveData.agenda[agendaIndex] objectForKey:@"id"];
    
    NSString *idStr = [NSString stringWithFormat:@"%@;%@;%@;;;%@;%@;%@;%@;%@;%@",agendaId,hyId,name,jj,info,msg,lxr,tel,groupId];

    [UAndDLoad modifyPointMeetingOneAgendaWithHyID:hyId YCXX:idStr];
//    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

#pragma mark 指定会议 删除  一个议程
+(void)deletePointMeetingOneAgendaWithHyIndex:(int )hyIndex
                                  AgendaIndex:(int )agendaIndex{
    NSString *hyId = staticSBJsonResolveData.meetingId[hyIndex];
    NSString *agendaId = [staticSBJsonResolveData.agenda[agendaIndex] objectForKey:@"id"];

    [UAndDLoad deletePointMeetingOneAgendaWithHyId:hyId AgendaId:agendaId];
//    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);

    [SBJsonResolveData getMeetingAllMeetingsWithIndex:hyIndex];
    
}


#pragma mark -------------------------------
#pragma mark 会议通知


@end

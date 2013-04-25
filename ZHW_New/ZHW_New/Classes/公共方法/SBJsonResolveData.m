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
#import "Define.h"
#import "StaticManager.h"
#import "CommonMethod.h"
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
#pragma mark 解析data数据 返回NSMutableDictionary
+ (NSMutableDictionary *)analyzeData:(NSData *)data{
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *dic = [jsonObject objectWithString:str];
    return dic;
}
//登入
+(NSString *)logInWithAccount:(NSString *)a secret:(NSString *)s{
    NSData *data = [UAndDLoad logInWithAccount:a secret:s];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *dic = [jsonObject objectWithString:str];
    return [dic objectForKey:@"msgForajax"];
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


- (NSMutableArray *)thisMeetingMembers{
    if (!_thisMeetingMembers) {
        _thisMeetingMembers = [[NSMutableArray alloc]init];
    }
    return _thisMeetingMembers;
}
- (void)setThisMeetingMembers:(NSMutableArray *)thisMeetingMembers{
    [staticSBJsonResolveData.thisMeetingMembers removeAllObjects];
    int index = [thisMeetingMembers[0] intValue];
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
#pragma mark 创建一个会议 
+ (void)createOneNewMeetingWithParams:(NSMutableDictionary *)params{
    NSData *data = [UAndDLoad upLoad:params withURL:Url_ModifyData];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *dic = [jsonObject objectWithString:str];
    if ([[dic objectForKey:@"returnMsg"] intValue]==1) {
        [StaticManager showAlertWithTitle:nil message:@"创建成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }else{
        [StaticManager showAlertWithTitle:nil message:@"创建失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }
}
#pragma mark SBJson解析 会议名称

+ (void )getMeetingData:(NSData *)data{
    [staticSBJsonResolveData.meetingNameList removeAllObjects];

    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *dic = [jsonObject objectWithString:str];
    
    NSArray *listDic = [dic objectForKey:@"hylist"];

    for (NSDictionary *objDic in listDic) {
//        NSLogString(objDic);
        NSString *meetingName = writeEnable([objDic objectForKey:G_HYName]);
        NSString *meetingId = writeEnable([objDic objectForKey:G_HYId]);
        NSString *meetingStartTime = writeEnable([objDic objectForKey:G_HYStartTime]);
//        NSLogString(meetingStartTime);
        NSMutableString *m_meetingStartTime = [NSMutableString stringWithString:meetingStartTime];
        if (m_meetingStartTime.length>0) {
            [m_meetingStartTime deleteCharactersInRange:[m_meetingStartTime rangeOfString:@".0"]];
        }
        NSString *meetingEndTime = writeEnable([objDic objectForKey:G_HYEndTime]);
        NSMutableString *m_meetingEndTime = [NSMutableString stringWithString:meetingEndTime];
        if (m_meetingEndTime.length>0) {
            [m_meetingEndTime deleteCharactersInRange:[m_meetingEndTime rangeOfString:@".0"]];
        }
        NSString *meetingAddress = writeEnable([objDic objectForKey:G_HYDz]);
        NSString *meetingTheme = writeEnable([objDic objectForKey:G_HYZt]);

        NSMutableArray *temp = [NSMutableArray array];
        [temp addObject:meetingName];
        [temp addObject:meetingId];
        [temp addObject:m_meetingStartTime];
        [temp addObject:m_meetingEndTime];
        [temp addObject:meetingAddress];
        [temp addObject:meetingTheme];

        [staticSBJsonResolveData.meetingNameList addObject:temp];

    }
}
#pragma mark  SBJson解析 会议人员
+ (void)updateThisMeetingMembersWithIndex:(int )index{
    [staticSBJsonResolveData setThisMeetingMembers:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:index]]];

}
+ (void )getMeetingMembers:(int )index{
    [staticSBJsonResolveData.thisMeetingMembers removeAllObjects];
    
    NSData *data = [UAndDLoad updateThisMeetingMembers:[staticSBJsonResolveData.meetingNameList objectAtIndex:index][1]];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *orgDic = [jsonObject objectWithString:str];

    NSArray *firstArray = [orgDic objectForKey:@"chdbList"];
//    NSLog(@"%@",firstArray);

    for (NSDictionary *subDic in firstArray) {
        NSMutableDictionary *arrayWithDics_SubDic =
        [SBJsonResolveData memberWithName:writeEnable([subDic objectForKey:CHDBName])
                                      Tel:writeEnable([subDic objectForKey:CHDBLxdh])
                                     Post:writeEnable([subDic objectForKey:CHDBZw])
                                      Sex:writeEnable([subDic objectForKey:CHDBXb])
                                   ChdbId:writeEnable([subDic objectForKey:CHDBId])
                                     Hyid:writeEnable([subDic objectForKey:CHDBHyid])
                                     Code:writeEnable([subDic objectForKey:CHDBCode])];
        
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
+(BOOL )deletePoitMeetingWithIndex:(int )index{
    NSString *idStr = [[staticSBJsonResolveData.thisMeetingMembers objectAtIndex:index] objectForKey:CHDBId];
   NSData *data = [UAndDLoad deleteMemberWithId:idStr];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];
    if ([[dic objectForKey:@"returnMsg"] isEqualToString:@"删除参会代表成功"]) {
        [staticSBJsonResolveData.thisMeetingMembers removeObjectAtIndex:index];
        return YES;
    }else
        return NO;
    
}
#pragma mark 增加 指定会议中 单个成员
+(BOOL )addPointMeetingWithIndex:(int )index
                           Name:(NSString *)name
                            Sex:(int )sex
                            Tel:(NSString *)tel
                           Post:(NSString *)post{
    int hyid = [staticSBJsonResolveData.meetingNameList[index][1] intValue];
    
    NSString *idStr = [NSString stringWithFormat:@"%d",hyid];
    
   NSData *data = [UAndDLoad addMemberWithHyid:idStr
                            Name:name
                             sex:sex
                             tel:tel
                            post:post];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];
    if ([[dic objectForKey:@"returnMsg"] isEqualToString:@"添加参会代表成功"]) {
        [SBJsonResolveData updateThisMeetingMembersWithIndex:index];
        return YES;
    }else
        return NO;

}
#pragma mark 编辑 指定会议中 单个成员
+(BOOL )modifyPointMeetingWithIndex:(int )index
                              Name:(NSString *)name
                               Sex:(int )sex
                               Tel:(NSString *)tel
                              Post:(NSString *)post{
    
    NSString *idStr = [[staticSBJsonResolveData.thisMeetingMembers objectAtIndex:index] objectForKey:CHDBId];
    NSString *hyidStr = [[staticSBJsonResolveData.thisMeetingMembers objectAtIndex:index] objectForKey:CHDBHyid];

    
    NSData *data = [UAndDLoad modifyMemberWithId:idStr
                             name:name
                              sex:sex
                              tel:tel
                             post:post];

    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];
    
    if ([[dic objectForKey:@"returnMsg"] isEqualToString:@"编辑参会代表成功"]) {
        NSMutableDictionary *member = [SBJsonResolveData memberWithName:name Tel:tel Post:post Sex:[NSString stringWithFormat:@"%d",sex] ChdbId:idStr Hyid:hyidStr Code:@"code"];
        [staticSBJsonResolveData.thisMeetingMembers replaceObjectAtIndex:index withObject:member];
        return YES;
    }else{
        return NO;
    }

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
    
    NSString *idStr = [staticSBJsonResolveData.meetingNameList objectAtIndex:index][1];
    NSData *data = [UAndDLoad getPointMeetingGroupsWithIndex:idStr];
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *orgDic = [jsonObject objectWithString:dataString];
    NSArray *dbfzList = [orgDic objectForKey:DBFZList];
//    NSLog(@"%@",dbfzList);
    for (NSDictionary *dic in dbfzList) {
        NSMutableDictionary *mutableDic = [SBJsonResolveData groupWithId:writeEnable([dic objectForKey:CHDBId])
                                                                    Code:writeEnable([dic objectForKey:DBFZCode])
                                                                    Name:writeEnable([dic objectForKey:DBFZName])
                                                              CreateTime:writeEnable([dic objectForKey:DBFZCreatetime])
                                                                    Mark:writeEnable([dic objectForKey:DBFZRemark])];
        [staticSBJsonResolveData.pointMeetingGroups addObject:mutableDic];
    }
    
}
#pragma mark 在指定会议中添加一个分组
+ (BOOL )addPointMeetingWithIndex:(int)index
                            Code:(NSString *)code
                            Name:(NSString *)name
                            Mark:(NSString *)mark{
    NSString *idStr = [staticSBJsonResolveData.meetingNameList objectAtIndex:index][1];
   NSData *data = [UAndDLoad addPointMeetingOneGroupWithHyid:idStr
                                                    GroupCode:code
                                                    GroupName:name
                                                    GroupMark:mark];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];
//    NSLogString([dic objectForKey:@"returnMsg"]);
    if ([[dic objectForKey:@"returnMsg"] isEqualToString:@"添加分组成功"]) {
        return YES;
    }
    else
        return NO;
}
#pragma mark  指定会议 删除一个分组
+ (BOOL )deletePointMeetingGroupWithIndex:(int )index{
    NSString *idStr = [[staticSBJsonResolveData.pointMeetingGroups objectAtIndex:index] objectForKey:@"id"];
   NSData *data = [UAndDLoad deletePointMeetingGroupWithId:idStr];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];
//    NSLogString([dic objectForKey:@"returnMsg"]);
    if ([[dic objectForKey:@"returnMsg"] isEqualToString:@"删除分组成功"]) {
        [staticSBJsonResolveData.pointMeetingGroups removeObjectAtIndex:index];

        return YES;
    }else
        return NO;
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
        NSMutableDictionary *mutableDic = [SBJsonResolveData memberWithId:writeEnable([dic objectForKey:CHDBId])
                                                                     Code:writeEnable([dic objectForKey:CHDBCode])
                                                                     Name:writeEnable([dic objectForKey:CHDBName])
                                                                     Post:writeEnable([dic objectForKey:CHDBZw])
                                                                      tel:writeEnable([dic objectForKey:CHDBLxdh])
                                                             memberCHDBId:writeEnable([dic objectForKey:@"chdbid"])];
        [staticSBJsonResolveData.pointGroupMembers addObject:mutableDic];
    }
}
#pragma mark 指定会议中  指定分组  添加分组成员
+ (BOOL )addPointMeetingGroupMemberWithMeetingIndex:(int )MI
                                        GroupIndex:(int )GI
                                       MemberIndex:(NSString *)MeI{
   NSData *data = [UAndDLoad addPointGroupWithHyId:staticSBJsonResolveData.meetingNameList[MI][1]
                                            groupId:[staticSBJsonResolveData.pointMeetingGroups[GI] objectForKey:CHDBId]
                                           memberId:MeI];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];
    if ([[dic objectForKey:@"returnMsg"] isEqualToString:@"添加分组成员成功"]) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 指定会议中 指定分组 删除分组成员
+ (BOOL )deletePointMeetingGroupMemberWithIndex:(int )index{
    NSString *idStr = [[staticSBJsonResolveData.pointGroupMembers objectAtIndex:index] objectForKey:CHDBId];
   NSData *data = [UAndDLoad deletePointGroupMemberWithFZCYString:idStr];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];
    if ([[dic objectForKey:@"returnMsg"] isEqualToString:@"删除分组成员成功"]) {
        return YES;
    }else
        return NO;
}

#pragma mark 指定会议中 获取所有议程
+ (void)getMeetingAllMeetingsWithIndex:(int )index{
    [staticSBJsonResolveData.agenda removeAllObjects];
    
    NSString *idStr = staticSBJsonResolveData.meetingNameList[index][1];
    NSData *data = [UAndDLoad getPointMeetingAllMeetingsWithIndex:idStr];
    
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *orgDic = [jsonObject objectWithString:dataString];

    NSArray *ycList = [orgDic objectForKey:@"yclist"];

    for (NSDictionary *dic in ycList) {
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        
        NSString *ycName = writeEnable([dic objectForKey:YCName]);
        NSString *yclxrsj = writeEnable([dic objectForKey:YCFZR]);
        NSString *content = writeEnable([dic objectForKey:YCContent]);
        NSString *tel = writeEnable([dic objectForKey:YCTel]);
        NSString *start = writeEnable([dic objectForKey:YCStartTime]);
        NSString *end = writeEnable([dic objectForKey:YCEndTime]);
        NSString *agendaId = writeEnable([dic objectForKey:@"id"]);
        NSString *contactedGroup = writeEnable([dic objectForKey:@"dbfzid"]);

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
+ (BOOL)addPointMeetingOneAgendaWithHyIndex:(int )index
                                     ycName:(NSString *)name
                                       hcJJ:(NSString *)jj
                                       info:(NSString *)info
                                        msg:(NSString *)msg
                                      ycLXR:(NSString *)lxr
                                      ycTel:(NSString *)tel
                                     bdfzId:(int )bdfzIndex{
    NSString *hyId = staticSBJsonResolveData.meetingNameList[index][1];
    NSString *groupId = [staticSBJsonResolveData.pointMeetingGroups[bdfzIndex] objectForKey:CHDBId];
    NSString *idStr = [NSString stringWithFormat:@"%@;%@;;;%@;%@;%@;%@;%@;%@",hyId,name,jj,info,msg,lxr,tel,groupId];

    NSData *data = [UAndDLoad addPointMeetingOneAgendaWithHyID:hyId YCXX:idStr];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];

    if ([[dic objectForKey:@"msgForajax"] isEqualToString:@"议程新建成功！"]) {
        return YES;
    }else{
        return NO;
    }
//    if ([[dic objectForKey:@"returnMsg"] isEqualToString:@"删除分组成员成功"]) {
//        <#statements#>
//    }
}

#pragma mark 指定会议修改  一个议程
+ (BOOL )modifyPointMeetingOneAgendaWithHyIndex:(int )index
                                   agendaIndex:(int )agendaIndex
                                     ycName:(NSString *)name
                                       hcJJ:(NSString *)jj
                                       info:(NSString *)info
                                        msg:(NSString *)msg
                                      ycLXR:(NSString *)lxr
                                      ycTel:(NSString *)tel
                                     bdfzId:(int )bdfzIndex{
    
    NSString *hyId = staticSBJsonResolveData.meetingNameList[index][1];
    NSString *groupId = [staticSBJsonResolveData.pointMeetingGroups[bdfzIndex] objectForKey:CHDBId];
    NSString *agendaId = [staticSBJsonResolveData.agenda[agendaIndex] objectForKey:@"id"];
    
    NSString *idStr = [NSString stringWithFormat:@"%@;%@;%@;;;%@;%@;%@;%@;%@;%@",agendaId,hyId,name,jj,info,msg,lxr,tel,groupId];

   NSData *data = [UAndDLoad modifyPointMeetingOneAgendaWithHyID:hyId YCXX:idStr];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];
    if ([[dic objectForKey:@"msgForajax"] isEqualToString:@"议程修改成功！"]) {
        return YES;
    }else{
        return NO;
    }

}

#pragma mark 指定会议 删除  一个议程
+(BOOL)deletePointMeetingOneAgendaWithHyIndex:(int )hyIndex
                                  AgendaIndex:(int )agendaIndex{
    NSString *hyId = staticSBJsonResolveData.meetingNameList[hyIndex][1];
    NSString *agendaId = [staticSBJsonResolveData.agenda[agendaIndex] objectForKey:@"id"];

   NSData *data =  [UAndDLoad deletePointMeetingOneAgendaWithHyId:hyId AgendaId:agendaId];
    NSMutableDictionary *dic = [SBJsonResolveData analyzeData:data];

    if ([[dic objectForKey:@"msgForajax"] isEqualToString:@"议程删除成功！"]) {
        [SBJsonResolveData getMeetingAllMeetingsWithIndex:hyIndex];
        return YES;
    }else{
        return NO;
    }

    
    

}


#pragma mark -------------------------------
#pragma mark 会议通知


@end

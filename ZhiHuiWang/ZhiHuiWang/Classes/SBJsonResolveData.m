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
+(SBJsonResolveData *)shareMeeting{
    if (!staticSBJsonResolveData) {
        staticSBJsonResolveData = [[SBJsonResolveData alloc]init];
        [SBJsonResolveData updateUrlData];
    }
    return staticSBJsonResolveData;
}
//更新数据
+(void )updateUrlData{
    NSData *data = [UAndDLoad downLoadWithUrl:Url_GetMeetingList];
    [SBJsonResolveData getMeetingData:data];
}
- (NSMutableArray *)meetingNameList{
    if (!_meetingNameList) {
        _meetingNameList = [[NSMutableArray alloc]init];
    }
    return _meetingNameList;
}
- (NSMutableArray *)meetingId{
    if (!_meetingId) {
        _meetingId = [[NSMutableArray alloc]init];
    }
    return _meetingId;
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

+ (NSMutableArray *)getMeetingMembers:(NSData *)data{
    NSMutableArray *arrayWithDics = [NSMutableArray array];
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *orgDic = [jsonObject objectWithString:str];

    NSArray *firstArray = [orgDic objectForKey:@"chdbList"];
    NSLog(@"%@",firstArray);

    for (NSDictionary *subDic in firstArray) {
        NSMutableDictionary *arrayWithDics_SubDic = [NSMutableDictionary dictionary];
        
        [arrayWithDics_SubDic setObject:[subDic objectForKey:CHDBName] forKey:CHDBName];//名称
        [arrayWithDics_SubDic setObject:[subDic objectForKey:CHDBLxdh] forKey:CHDBLxdh];//电话
        [arrayWithDics_SubDic setObject:[subDic objectForKey:CHDBZw] forKey:CHDBZw];//职位
        [arrayWithDics_SubDic setObject:[NSNumber numberWithInt:[[subDic objectForKey:CHDBXb] intValue]] forKey:CHDBXb];//性别  1为男  0为女
        [arrayWithDics_SubDic setObject:[subDic objectForKey:CHDBId] forKey:CHDBId];//id
        [arrayWithDics_SubDic setObject:[subDic objectForKey:CHDBHyid] forKey:CHDBHyid];//hyid

        [arrayWithDics addObject:arrayWithDics_SubDic];

    }

    return arrayWithDics;
    
}
@end

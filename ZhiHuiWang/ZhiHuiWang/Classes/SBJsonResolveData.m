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
    NSData *data = [UAndDLoad downLoadWithUrl:GetMeetingList];
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

@end

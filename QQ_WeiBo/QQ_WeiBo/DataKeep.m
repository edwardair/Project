//
//  DataKeep.m
//  QQ_WeiBo
//
//  Created by ZYJ on 12-12-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataKeep.h"


@implementation DataKeep
-(id)init{
    if (self == [super init]) {
        
        //=================NSKeyedArchiver========================
        NSString *saveStr1 = @"我是";
        NSString *saveStr2 = @"数据";
        NSArray *array = [NSArray arrayWithObjects:saveStr1, saveStr2, nil];
        //----Save
        //这一句是将路径和文件名合成文件完整路径
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [Path stringByAppendingPathComponent:@"saveDatatest"];
        [NSKeyedArchiver archiveRootObject:array toFile:filename];
        //用于测试是否已经保存了数据
        saveStr1 = @"hhhhhhiiii";
        saveStr2 =@"mmmmmmiiii";
        //----Load
        array = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
        saveStr1 = [array objectAtIndex:0];
        saveStr2 = [array objectAtIndex:1];
        CCLOG(@"str:%@",saveStr1);
        CCLOG(@"astr:%@",saveStr2);
    }
    return self;
}
@end

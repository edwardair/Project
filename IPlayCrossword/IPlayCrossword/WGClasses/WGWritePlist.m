//
//  WGWritePlist.m
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-4-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WGWritePlist.h"


@implementation WGWritePlist
//Write
+ (void)writePlistWithObj:(NSArray *)objArray
                      key:(NSArray *)keyArray
                plistName:(NSString *)plistName{
    NSString *error;
    
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                              NSUserDomainMask, YES) objectAtIndex:0];

//    NSString *rootPath = NSHomeDirectory();
//
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"iPlayCrossWord.app/%@",plistName]];
    NSString *plistPath = plistName;
    NSLog(@"%@",plistName);
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:objArray
                                                          forKeys:keyArray];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(@"%@",error);
        [error release];
    }
}
//Get
+(NSMutableDictionary* )readPlist:(NSString *)plistName{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistName];
    return dic;
}
@end

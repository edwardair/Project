//
//  UAndDLoad.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-27.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "UAndDLoad.h"
#include <CFNetwork/CFNetwork.h>

#define NSLOG(x)  NSLog(@"%@",x)

@implementation UAndDLoad

#pragma mark 上传数据
+(NSString *)createPostURL:(NSMutableDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}
+(NSData *)upLoad:(NSMutableDictionary *)params withURL:(NSString *)url
{
    NSString *postURL=[UAndDLoad createPostURL:params];
    NSError *error;
    NSURLResponse *theResponse;
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
}

+(void)test{
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"会议名字" forKey:@"hy.hyname"];
        [params setObject:@"CodeTest1" forKey:@"hy.hydz"];
//        [params setObject:@"2013-03-05" forKey:@"hy.hystarttime"];
//        [params setObject:@"2013-10-11" forKey:@"hy.hyendtime"];
        [params setObject:@"CodeTest2" forKey:@"hy.hyzbf"];
        [params setObject:@"CodeTest3" forKey:@"hy.hyxbf"];
        [params setObject:@"CodeTest4" forKey:@"hy.hyzt"];
        [params setObject:@"CodeTest5" forKey:@"hy.hyxq"];
//        NSData *resultData = [UAndDLoad upLoad:params withURL:ModifyData];
//        NSLog(@"%@",[[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding]);
}

#pragma mark 下载数据
+ (NSData *)downLoadWithUrl:(NSString *)urlString{
	//获取用户输入的字符串，并转换成为NSURL类型，路径格式
    NSURL *url = [[NSURL alloc] initWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	    
	//获得网页缓存中的数据，并链接网络
	[request setHTTPMethod:@"GET"];
	NSURLResponse *response = nil;
	NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

    //网络失败警告
    if (!data) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"联网失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		return nil;
	}else{
        NSLog(@"获取数据成功");
//        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }
    return data;
}

#pragma mark 删除会议中成员
+ (void)deleteMemberWithId:(NSString *)idStr{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:idStr forKey:@"chdbString"];
    
    [UAndDLoad upLoad:params withURL:Url_DeleteMeetingMember];
}
+ (void)addMemberWithHyid:(NSString *)idStr
                     Name:(NSString *)name
                      sex:(int )man
                      tel:(NSString *)tel
                     post:(NSString *)post{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:idStr forKey:@"chdb.hyid"];
    [params setObject:name forKey:@"chdb.chdbname"];
    [params setObject:[NSString stringWithFormat:@"%d",man] forKey:@"chdb.chdbxb"];
    [params setObject:tel forKey:@"chdb.chdblxdh"];
    if (post.length>0) {
        [params setObject:post forKey:@"chdb.chdbzw"];
    }
   
    [UAndDLoad upLoad:params withURL:Url_AddMeetingMember];
    
}
+ (void)modifyMemberWithId:(NSString *)idStr
                   name:(NSString *)name
                      sex:(int )man
                      tel:(NSString *)tel
                     post:(NSString *)post{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:idStr forKey:@"chdb.id"];
    [params setObject:name forKey:@"chdb.chdbname"];
    [params setObject:[NSString stringWithFormat:@"%d",man] forKey:@"chdb.chdbxb"];
    [params setObject:tel forKey:@"chdb.chdblxdh"];
    if (post.length>0) {
        [params setObject:post forKey:@"chdb.chdbzw"];
    }
    
    [UAndDLoad upLoad:params withURL:Url_ModifyMeetingMember];

}

@end

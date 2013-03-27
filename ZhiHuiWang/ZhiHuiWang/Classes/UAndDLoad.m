//
//  UAndDLoad.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-27.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "UAndDLoad.h"
#include <CFNetwork/CFNetwork.h>
#import "DataOperation.h"

#define NSLOG(x)  NSLog(@"%@",x)

@implementation UAndDLoad
+(void)upLoadWithString:(NSString *)content{
    DataOperation *oper = [[DataOperation alloc]init];
   NSString *str = @"123";
    NSLOG(str);

    str = [oper UpLoading];
    NSLOG(str);
    return;
    content = @"user.username=admin&user.password=admin";
    
	NSString *urlString = @"http://http://192.168.8.215:8088/GZHWV/login_login.action";
	
	//文件传输请求
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	[request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
	
    NSURLResponse*response=nil;
    NSError*error=nil;
    NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"%@",error);
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//    if (error==nil&&[data length]>0) {
//        //请求同步加载
//        NSURLResponse *urlResponse;
//       NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
//        NSLog(@"%@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
//
//    }/Users/blackapple/Desktop/服务器文件上下载/http-UploadAndDownload 03141109

}
+(void)test{
    NSString *urlString = @"http://192.168.8.214:8080/GZHWV/upload.do";

    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[UIImage imageNamed:@"CreateNewMeeting.png"];//[params objectForKey:@"pic"];
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
//    NSArray *keys= [params allKeys];
    
    //遍历keys
//    for(int i=0;i<[keys count];i++)
//    {
//        //得到当前key
//        NSString *key=[keys objectAtIndex:i];
//        //如果key不是pic，说明value是字符类型，比如name：Boris
//        if(![key isEqualToString:@"pic"])
//        {
//            //添加分界线，换行
//            [body appendFormat:@"%@\r\n",MPboundary];
//            //添加字段名称，换2行
//            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//            //添加字段的值
//            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
//        }
//    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSURLResponse*response=nil;
    NSError*error=nil;
    NSData*dataEnd=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"%@",error);
    NSLog(@"%@",[[NSString alloc]initWithData:dataEnd encoding:NSUTF8StringEncoding]);

    //设置接受resp*****e的data
//    if (conn) {
//        NSLog(@"%@",conn.description);
//    }
}
@end

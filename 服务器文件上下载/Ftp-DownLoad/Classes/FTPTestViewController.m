//
//  FTPTestViewController.m
//  FTPTest
//
//  Created by apple1 on 11-3-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FTPTestViewController.h"
#import "FTPTestAppDelegate.h"

@implementation FTPTestViewController
@synthesize urlTextField;
@synthesize statusLabel;
@synthesize getButton;
@synthesize connection;
@synthesize filePath;
@synthesize fileStream;


//返回当前的网络链接状态
- (BOOL)isReceiving
{
    return (self.connection != nil);
}

//响应downLoad按钮点击
-(IBAction)getOrCancelAction:(id)sender{
    if (self.isReceiving) {
	//[self stopReceiveWithStatus:@"Cancelled"];
    } 
	else {
        [self startReceive];
    }

}

//生成服务器的url，并返回，在这个函数中对输入的字符串进行了判断是否"ftp"
- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
	
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"ftp://%@", trimmedStr]];
        } 
		else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];//获取指定位置前的字符串
            assert(scheme != nil);
            
            if ( ([scheme compare:@"ftp"  options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {//判断是否ftp路径
                result = [NSURL URLWithString:trimmedStr];
            } 
			else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

- (NSString *)receivePath{
	
	NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	return documentDirectory;
}

//返回下载后的文件存放路径
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
   // NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);//随机生成一个ID号
    assert(uuidStr != NULL);
    
   // result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];//本机隐藏路径  /var 下
	//assert(result != nil);
    

	//NSLog(@"result:%@",NSTemporaryDirectory());
	
	//可以在这个函数中随机设置一个存放路径
	NSString *result=[NSString stringWithFormat:@"/Users/songwei/ftp-download/%@",uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}

//网络开始驱动
- (void)receiveDidStart
{
    // Clear the current image so that we get a nice visual cue if the receive fails.
    self.statusLabel.text = @"接受数据";
    [self didStartNetworking];
}

//工作开始，并启动activity
- (void)didStartNetworking{
    networkingCount += 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//工作停止，并结束activity
- (void)didStopNetworking{
    assert(networkingCount > 0);
    networkingCount -= 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (networkingCount != 0);

}

//开始接收
- (void)startReceive{
    BOOL                success;
    NSURL *             url;
    NSURLRequest *      request;
    
    assert(self.connection == nil);         // don't tap receive twice in a row!
    assert(self.fileStream == nil);         // ditto
    assert(self.filePath == nil);           // ditto
	
    // First get and check the URL.
    
    url = [self smartURLForString:self.urlTextField.text];
    success = (url != nil);
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    if ( ! success) {
        self.statusLabel.text = @"无效的服务器路径";
    } 
	else {
		
        // Open a stream for the file we're going to receive into.
		
        self.filePath = [self pathForTemporaryFileWithPrefix:@"Get"];//设置文件下载后存放路径
        assert(self.filePath != nil);
        
        self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:NO];
        assert(self.fileStream != nil);
		 
        [self.fileStream open];
        request = [NSURLRequest requestWithURL:url];
        assert(request != nil);
        
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        assert(self.connection != nil);
        [self receiveDidStart];
    }
}


////////////////////////////////////////////////
//连通
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
#pragma unused(theConnection)
#pragma unused(response)
	
    assert(theConnection == self.connection);
    assert(response != nil);
}

//接收数据返回
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
#pragma unused(theConnection)
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
	
    assert(theConnection == self.connection);
    
    dataLength = [data length];
    dataBytes  = [data bytes];
	
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];//写文件时的返回值
        assert(bytesWritten != 0);
        if (bytesWritten == -1) {
            [self stopReceiveWithStatus:@"File write error"];
            break;
        } 
		else {
            bytesWrittenSoFar += bytesWritten;
        }
    } 
	while (bytesWrittenSoFar != dataLength);
}

//错误
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
#pragma unused(theConnection)
#pragma unused(error)
    assert(theConnection == self.connection);
    
    [self stopReceiveWithStatus:@"Connection failed"];
}

//成功完成
- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
#pragma unused(theConnection)
    assert(theConnection == self.connection);
    
    [self stopReceiveWithStatus:nil];
}

- (void)stopReceiveWithStatus:(NSString *)statusString
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self receiveDidStopWithStatus:statusString];

}

//数据下载完后，判断格式、展示数据
- (void)receiveDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        assert(self.filePath != nil);
        statusString = @"GET succeeded";
    }
    self.statusLabel.text = statusString;
    [self didStopNetworking];
	
	NSString *pathExtension = [urlTextField.text pathExtension];

//	if ([pathExtension isEqual:@"png"] || [pathExtension isEqual:@"jpg"] || [pathExtension isEqual:@"gif"]){
//		UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.filePath]];
//		imageView.frame = CGRectMake(200, 200, 200, 200);
//		[self.view addSubview:imageView];
//		[imageView release];
//	}
//	else if([pathExtension isEqual:@"txt"]){
//
//	}
//	else if([pathExtension isEqual:@"mp4"]){
//		
//	}
    self.filePath = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

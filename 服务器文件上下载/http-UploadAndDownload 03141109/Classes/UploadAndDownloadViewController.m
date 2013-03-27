//
//  UploadAndDownloadViewController.m
//  UploadAndDownload
//
//  Created by songwei on 11-3-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UploadAndDownloadViewController.h"
#include <CFNetwork/CFNetwork.h>
#import "zlib.h"

static NSString * const boundry = @"0xKhTmLbOuNdArY";
static NSString * const FORM_FLE_INPUT = @"uploaded";
@implementation UploadAndDownloadViewController
@synthesize webView;
@synthesize upLoadServerPath;
@synthesize downLoadServerPath;
@synthesize upLoadFilePath;
@synthesize downLoadFilePath;
@synthesize receiveData;
@synthesize url;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	receiveData = [[NSMutableData data] retain];
	[super viewDidLoad];
}

-(void)downLoad{
	//获取用户输入的字符串，并转换成为NSURL类型，路径格式
    url=[[NSURL alloc] initWithString:downLoadServerPath.text]; 
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	
	//webView上加载，可删除
	[webView loadRequest:request];

	//获得网页缓存中的数据，并链接网络
	[request setHTTPMethod:@"GET"];
	NSURLResponse *response;
	NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	
	//long lengths = [response expectedContentLength];
	//NSLog(@"data:%ld",data.length);
	//NSLog(@"length:%f",data.length/lengths);
    //网络失败警告
   if (!data) {
		[receiveData release];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"联网失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	//查看传输的数据
	[receiveData appendData:data];
	
	//文件本地保存
	[self writereceiveDataToFile];	
	[url release];
}

-(void)upLoad{
	//服务器的路径
	NSString *filePath=upLoadFilePath.text;
	NSData *fileData =[[NSData alloc] initWithContentsOfFile:filePath];  
	
	//压缩数据，检查上传文件后发现乱码，所以应用时得解码
	//NSData *fileData=[self compress:Data];
	
	//64位数据编码，不知如何测试其编码是否成功
	//NSString *data=[UploadAndDownloadViewController base64forData:fileData];
	
	//获取当前路径下文件名，为上传同名做准备
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *displayNameAtPath = [fileManager displayNameAtPath:filePath];

	//将要上传文件路径  
	NSString *urlString =upLoadServerPath.text;  
	
	//文件传输请求  
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
	[request setURL:[NSURL URLWithString:urlString]];  
	[request setHTTPMethod:@"POST"];  
	
	//迷惑
	NSString *boundary = [NSString stringWithString:@"54246487833132145561449"];  
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];  
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];  
	
	//数据传输格式，组合http传输的，数据包头、数据、包尾
	NSMutableData *body = [NSMutableData data]; 
	
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];  
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",displayNameAtPath] dataUsingEncoding:NSUTF8StringEncoding]];  
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];  
	[body appendData:[NSData dataWithData:fileData]];  
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];  
    
	[request setHTTPBody:body];  
	
	//请求同步加载
	NSURLResponse *urlResponse;
	[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];	
}

//控制上传还是下载
-(IBAction)buttonControll:(id)sender{
	NSInteger tag=[sender tag];
	if (tag==1) {
		[self downLoad];
	}
	else {
		[self upLoad];
	}

}

//下载后保存文件
-(void)writereceiveDataToFile{

	assert(receiveData != nil);
	
	//获取被上传的文件名字
	NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *displayNameAtPath = [fileManager displayNameAtPath:downLoadServerPath.text];
	
	//创建完整路径
    NSString *filename=[downLoadFilePath.text stringByAppendingFormat:@"/%@",displayNameAtPath];
	
	[receiveData writeToFile:filename atomically:YES];
	[receiveData release];		
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[receiveData release];
    [super dealloc];
}

//压缩数据
- (NSData *)compress: (NSData *)data // IN
{
	if (!data || [data length] == 0)
		return nil;
	
	// zlib compress doc says destSize must be 1% + 12 bytes greater than source.
	uLong destSize = [data length] * 1.001 + 12;
	NSMutableData *destData = [NSMutableData dataWithLength:destSize];
	
	int error = compress([destData mutableBytes],
						 &destSize,
						 [data bytes],
						 [data length]);
	if (error != Z_OK) {
		//LOG(0, ("%s: self:0x%p, zlib error on compress:%d\n",__func__, self, error));
		return nil;
	}
	
	[destData setLength:destSize];
	return destData;
}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

@end

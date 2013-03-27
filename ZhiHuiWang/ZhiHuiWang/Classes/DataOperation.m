//
//  DataOperation.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-27.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "DataOperation.h"
//#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]
// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"

@implementation DataOperation
- (void)cleanup:(id )x{
    NSLog(@"%@",@"NOTIFY_AND_LEAVE");
}
- (UIImage *)theImage{
    if (!_theImage) {
        _theImage = [[UIImage alloc]initWithCGImage:[[UIImage imageNamed:@"CreateNewMeeting.png"] CGImage]];
    }
    return _theImage;
}
//创建postdata
- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
	
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		if ([value isKindOfClass:[NSData class]])
		{
			// handle image data
			NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:i]];
			[result appendData: DATA(formstring)];
			[result appendData:value];
		}
		else
		{
			// all non-image fields assumed to be strings
			NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
			[result appendData: DATA(formstring)];
			[result appendData:DATA(value)];
		}
		
		NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
	
	NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}
//上传图片
- (NSString *) UpLoading
{
	if (!self.theImage)
		[self cleanup:nil];
    
    
	NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    
	[post_dict setObject:@"Posted from iPhone" forKey:@"message"];
	[post_dict setObject:UIImageJPEGRepresentation(self.theImage, 0.75f) forKey:@"media"];
	
	NSData *postData = [self generateFormDataFromPostDictionary:post_dict];
	
    NSString *baseurl = @"http://192.168.8.214:8080/GZHWV/upload.do";
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    if (!urlRequest)
        [self cleanup:nil];

    [urlRequest setHTTPMethod: @"POST"];
	[urlRequest setValue:MULTIPART forHTTPHeaderField: @"Content-Type"];
    [urlRequest setHTTPBody:postData];
	
	// Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
	NSLog(@"Contacting TwitPic....");
    NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (!result)
	{
		[self cleanup:[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]];
		return nil;
	}
	
	// Return results
    NSString *outstring = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] ;
    return outstring;
}
@end

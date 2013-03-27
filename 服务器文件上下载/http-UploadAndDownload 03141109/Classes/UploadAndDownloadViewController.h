//
//  UploadAndDownloadViewController.h
//  UploadAndDownload
//
//  Created by songwei on 11-3-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadAndDownloadViewController : UIViewController {
	UIWebView        *webView;
	UITextField      *upLoadServerPath;
	UITextField      *upLoadFilePath;
	
    UITextField      *downLoadServerPath;
	UITextField      *downLoadFilePath;
	NSURL            *url;
	NSMutableData    *receiveData;

}
@property(nonatomic, readonly)IBOutlet UIWebView *webView;
@property(nonatomic,retain)IBOutlet UITextField *upLoadServerPath;
@property(nonatomic,retain)IBOutlet UITextField *downLoadServerPath; 
@property(nonatomic,retain)IBOutlet UITextField *upLoadFilePath;
@property(nonatomic,retain)IBOutlet UITextField *downLoadFilePath;
@property(nonatomic,retain)NSURL *url;

@property(nonatomic,retain)NSMutableData *receiveData;

-(void)upLoad;
-(void)downLoad;
-(IBAction)buttonControll:(id)sender;
-(void)writereceiveDataToFile;
- (NSData *)compress: (NSData *)data;
+ (NSString*)base64forData:(NSData*)theData;
@end


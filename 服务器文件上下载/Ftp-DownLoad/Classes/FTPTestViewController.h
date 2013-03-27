//
//  FTPTestViewController.h
//  FTPTest
//
//  Created by apple1 on 11-3-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPTestViewController : UIViewController {
	UITextField *urlTextField;
	UIButton    *getButton;
	UILabel		*statusLabel;
	NSInteger   networkingCount;
	
	NSURLConnection  *connection;
    NSString         *filePath;
    NSOutputStream   *fileStream;
	BOOL              isReceiving;
	
}
@property (nonatomic,assign) IBOutlet UITextField *urlTextField;
@property (nonatomic,assign) IBOutlet UIButton    *getButton;
@property (nonatomic, assign) IBOutlet UILabel    *statusLabel;

@property (nonatomic, readonly) BOOL              isReceiving;
@property (nonatomic, retain)   NSURLConnection * connection;
@property (nonatomic, copy)     NSString *        filePath;
@property (nonatomic, retain)   NSOutputStream *  fileStream;

-(IBAction)getOrCancelAction:(id)sender;
- (void)startReceive;
- (void)didStartNetworking;
- (void)didStopNetworking;
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;
- (NSURL *)smartURLForString:(NSString *)str;
- (void)stopReceiveWithStatus:(NSString *)statusString;
- (void)receiveDidStopWithStatus:(NSString *)statusString;
@end


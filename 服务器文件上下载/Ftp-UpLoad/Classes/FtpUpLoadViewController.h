//
//  FtpUpLoadViewController.h
//  FtpUpLoad
//
//  Created by songwei on 11-3-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CFNetwork/CFNetwork.h>
enum {
    kSendBufferSize = 32768
};

@interface FtpUpLoadViewController : UIViewController  <UITextFieldDelegate, NSStreamDelegate>{
	UITextField *textOfNetUrl;
	UITextField *textOfFileUrl;
	
	UILabel *statusLabel;
	NSInteger               networkingCount;
	
	size_t                      bufferOffset;
	size_t                      bufferLimit;
	uint8_t                     _buffer[kSendBufferSize];
	
	NSOutputStream *            networkStream;
    NSInputStream *             fileStream;
}

@property(nonatomic,retain)IBOutlet UITextField *textOfNetUrl;
@property(nonatomic,retain)IBOutlet UITextField *textOfFileUrl;
@property (nonatomic, retain)   NSOutputStream *  networkStream;
@property (nonatomic, retain)   NSInputStream *   fileStream;
@property (nonatomic,retain)IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) NSInteger             networkingCount;
@property (nonatomic, assign)   size_t            bufferOffset;
@property (nonatomic, assign)   size_t            bufferLimit;
@property (nonatomic, readonly) uint8_t *         buffer;

- (NSURL *)smartURLForString:(NSString *)str;
- (IBAction)sendAction:(id)sender;
- (NSString *)pathForTestImage:(NSUInteger)imageNumber;
- (void)_startSend:(NSString *)filePath;
- (void)_sendDidStart;
- (void)didStartNetworking;
- (void)_updateStatus:(NSString *)statusString;
- (void)_stopSendWithStatus:(NSString *)statusString;
- (void)_sendDidStopWithStatus:(NSString *)statusString;
- (void)didStopNetworking;
@end


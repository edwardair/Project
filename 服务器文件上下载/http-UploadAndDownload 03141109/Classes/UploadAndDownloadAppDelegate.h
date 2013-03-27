//
//  UploadAndDownloadAppDelegate.h
//  UploadAndDownload
//
//  Created by songwei on 11-3-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadAndDownloadViewController;

@interface UploadAndDownloadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UploadAndDownloadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UploadAndDownloadViewController *viewController;

@end


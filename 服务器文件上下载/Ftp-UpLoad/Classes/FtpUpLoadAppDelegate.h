//
//  FtpUpLoadAppDelegate.h
//  FtpUpLoad
//
//  Created by songwei on 11-3-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FtpUpLoadViewController;

@interface FtpUpLoadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FtpUpLoadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FtpUpLoadViewController *viewController;

@end


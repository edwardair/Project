//
//  FTPTestAppDelegate.h
//  FTPTest
//
//  Created by apple1 on 11-3-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTPTestViewController;

@interface FTPTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FTPTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FTPTestViewController *viewController;

@end


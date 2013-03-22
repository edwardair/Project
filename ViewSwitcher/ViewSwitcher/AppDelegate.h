//
//  AppDelegate.h
//  ViewSwitcher
//
//  Created by BlackApple on 13-3-22.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitcherViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) IBOutlet SwitcherViewController *switchViewController;


@end

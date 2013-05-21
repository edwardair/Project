//
//  AppDelegate.h
//  cqhot
//
//  Created by ZL on 13-4-2.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "NavigationController.h"
#import "EUNavigationController.h"
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TabBarViewController *tabBarController;
@property (strong, nonatomic) EUNavigationController *navigationController;

@end

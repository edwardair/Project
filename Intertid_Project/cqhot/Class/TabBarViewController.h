//
//  TabBarViewController.h
//
//  Created by gitmac on 13-3-18.
//  Copyright (c) 2013年 Gitmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUTabBar.h"
#import "EUKitCompat.h"


/**
 * Define EUTabBar view height
 */
#define kTBHeight 45

/**
 * 自定义tabar控制器
 * Use super Class UIViewController
 * And custom xib view EUTabBar for 5 tabs.
 */
@interface TabBarViewController : UIViewController

@property (readonly, nonatomic) EUTabBar *tbBar;
@property (copy, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIView *containerView;
@property (assign, nonatomic) NSUInteger selectedIndex;
@property (assign, nonatomic) UIViewController *selectedViewController;

@end

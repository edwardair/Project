//
//  RootViewController.h
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragScrollView.h"
@interface RootViewController : UIViewController<UITabBarControllerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) DragScrollView *rootScrollView;

+(RootViewController *)shareRootViewController;
+ (RootViewController *)rootController;
@end

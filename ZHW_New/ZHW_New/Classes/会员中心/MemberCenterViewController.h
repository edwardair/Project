//
//  MemberCenterViewController.h
//  ZHW_New
//
//  Created by BlackApple on 13-4-10.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCenterViewController : UIViewController
@property (strong,nonatomic) UIView *curPresentView;
- (void)changeViewWithIndexPath:(NSIndexPath *)path;
@end

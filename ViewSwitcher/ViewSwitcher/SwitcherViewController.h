//
//  SwitcherViewController.h
//  ViewSwitcher
//
//  Created by BlackApple on 13-3-22.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlueViewController;
@class YellowViewController;


@interface SwitcherViewController : UIViewController{
    
}
@property (nonatomic,strong) BlueViewController *blueViewController;
@property (nonatomic,strong) YellowViewController *yellowViewController;

- (IBAction)switchViews:(id)sender;

@end

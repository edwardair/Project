//
//  IWRViewController.h
//  WorkPlace
//
//  Created by BlackApple on 13-4-19.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RepairPopoverView.h"
#import "CheckBoxView.h"
@interface IWRViewController : UIViewController<RPVDelegate>

@property (strong,nonatomic) IBOutlet UIButton *reasonButton;
@property (strong,nonatomic) IBOutlet CheckBoxView *installationUnitButton;
@property (strong,nonatomic) IBOutlet CheckBoxView *principalButton;

- (IBAction)reasonButtonPressed;
- (IBAction)installationUnitButtonPressed;
- (IBAction)principalButtonPressed;

- (IBAction)submitButtonPressed;
- (IBAction)resetButtonPressed;
@end

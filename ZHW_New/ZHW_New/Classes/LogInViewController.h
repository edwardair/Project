//
//  LogInViewController.h
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic) IBOutlet UITextField *account;
@property (strong,nonatomic) IBOutlet UITextField *secret;

- (IBAction)logIn;

@end

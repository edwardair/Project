//
//  ViewController.h
//  abc
//
//  Created by BlackApple on 13-4-16.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic) IBOutlet UIScrollView *s;
@property (strong,nonatomic) IBOutlet UITextField* t1;
@property (strong,nonatomic) IBOutlet UITextField* t2;
@property (strong,nonatomic) IBOutlet UITextField* t3;

@end

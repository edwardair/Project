//
//  LogInViewController.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-17.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "LogInViewController.h"
#import "CommonMethod.h"
@interface LogInViewController ()
@property (strong,nonatomic) UITextField *accountField;
@property (strong,nonatomic) UITextField *secretField;

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //账号
        UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake(50, applicationFrame().origin.y+100, 0, 0)];
        [self.view addSubview:account];
        account.text = @"账号:";
        [CommonMethod autoSizeLabel:account];
        [account release];
        
        //密码 
        UILabel *secret = [[UILabel alloc]initWithFrame:CGRectMake(50, applicationFrame().origin.y+130, 0, 0)];
        [self.view addSubview:secret];
        secret.text = @"密码:";
        [CommonMethod autoSizeLabel:secret];
        [secret release];

        //输入框
        _accountField = [[CommonTextField alloc]initWithFrame:CGRectMake(account.frame.origin.x + account.frame.size.width + 30, account.frame.origin.y, 200, account.frame.size.height)];
        [self.view addSubview:_accountField];
        _accountField.borderStyle = UITextBorderStyleLine;
        _accountField.delegate = self;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

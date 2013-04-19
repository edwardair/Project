//
//  LogInViewController.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-17.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "LogInViewController.h"
#import "CommonMethod.h"
#import "BDMapViewController.h"
#import "AppDelegate.h"
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
        UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake(20, applicationFrame().origin.y+100, 0, 0)];
        [self.view addSubview:account];
        account.text = @"账号:";
        [CommonMethod autoSizeLabel:account withFont:systemFontSize(DefaultSystemFontSize)];
        [account release];
        
        //密码 
        UILabel *secret = [[UILabel alloc]initWithFrame:CGRectMake(20, applicationFrame().origin.y+150, 0, 0)];
        [self.view addSubview:secret];
        secret.text = @"密码:";
        [CommonMethod autoSizeLabel:secret withFont:systemFontSize(DefaultSystemFontSize)];
        [secret release];

        //输入框
        _accountField = [[CommonTextField alloc]initWithFrame:CGRectMake(account.frame.origin.x + account.frame.size.width + 30, account.frame.origin.y-(30-account.frame.size.height), 200, 30)];
        [self.view addSubview:_accountField];
        _accountField.borderStyle = UITextBorderStyleLine;
        _accountField.delegate = self;
        _accountField.returnKeyType = UIReturnKeyDone;
        
        _secretField = [[CommonTextField alloc]initWithFrame:CGRectMake(secret.frame.origin.x + secret.frame.size.width + 30, secret.frame.origin.y-(30-account.frame.size.height), 200, 30)];
        [self.view addSubview:_secretField];
        _secretField.borderStyle = UITextBorderStyleLine;
        _secretField.delegate = self;
        _secretField.secureTextEntry = YES;
        _secretField.returnKeyType = UIReturnKeyDone;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBoard)];
        [self.view addGestureRecognizer:tap];
        [tap setCancelsTouchesInView:NO];

        UIButton *login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.view addSubview:login];
        login.frame = CGRectMake(20, _secretField.frame.origin.y+_secretField.frame.size.height+70, applicationFrame().size.width-40, 35);
        [login setTitle:@"登入" forState:UIControlStateNormal];
        [login setTitle:@"登入" forState:UIControlStateHighlighted];
        login.center = CGPointMake(applicationFrame().size.width/2, _secretField.center.y+50);
        [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [login setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        
        //Debug
        _accountField.text = @"admin";
        _secretField.text = @"admin";
    }
    return self;
}

- (void)resignKeyBoard{
    [_accountField resignFirstResponder];
    [_secretField resignFirstResponder];
}
//登入
- (void)login{
    if (_accountField.text.length>0&&_secretField.text.length>0) {
        BDMapViewController *bdMap = [[BDMapViewController alloc]initWithNibName:@"BDMapViewController" bundle:nil];
//        [self.navigationController pushViewController:bdMap animated:YES];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bdMap];
        AppDelegate *app  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        app.window.rootViewController = nav;
        
        [bdMap release];
        [nav release];
        
    }else{
        NSLog(@"账号密码不为空");
    }
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


#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end

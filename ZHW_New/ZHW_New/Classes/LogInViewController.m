//
//  LogInViewController.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "LogInViewController.h"
#import "SBJsonResolveData.h"
#import "StaticManager.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "CommonMethod.h"
@interface LogInViewController ()
@property (strong,nonatomic) id editText;
@end
@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _account.delegate = self;
    _secret.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)resignKeyBoard{
    [_editText resignFirstResponder];
}
//delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [StaticManager resignParentView];
    [[TapResignKeyBoard shareTapResignKeyBoard] removeGestureRecognizer];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"kaishi");
    _editText = textField;
    [StaticManager TextInputAnimationWithParentView:self.view textView:textField];
//    [StaticManager TextInputAnimationWithParentView:self.view textViewFrame:textField.frame];

    [[TapResignKeyBoard shareTapResignKeyBoard] addTarget:self action:@selector(resignKeyBoard) parentView:self.view];

    return YES;
}
#define DEBUG 1
- (IBAction)logIn{
#ifdef DEBUG 
    RootViewController *root = [RootViewController rootController];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate.window.rootViewController release];
    appDelegate.window.rootViewController = root;
    return;
#endif
    if (_account.text.length==0 || _secret.text.length==0) {
        [StaticManager showAlertWithTitle:nil message:@"账号密码不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitle:nil];
    }else{
        NSString *msg = [SBJsonResolveData logInWithAccount:_account.text secret:_secret.text];
        if ([msg isEqual:@"ok"]) {
            NSLog(@"登入成功");
            RootViewController *root = [RootViewController rootController];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window.rootViewController release];
            appDelegate.window.rootViewController = root;
            
        }else{
            [StaticManager showAlertWithTitle:nil message:@"登入失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitle:nil];
        }
    }
}

@end

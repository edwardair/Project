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
//#import "CommonMethod.h"
@interface LogInViewController (){
    UIView *textEditor;
    float centerY;
}
//@property (strong,nonatomic) id editText;
@end
@implementation LogInViewController

#pragma mark TapDelegate
- (UIView *)willFitPointOfView{
    return self.view;
}
- (float )orgCenterYOfView{
    NSLogFloat(centerY);
    return centerY;
}
- (UIView *)curClickedText{
    return textEditor;
}
- (BOOL)statusBarShow{
    return YES;
}
- (BOOL)navigationBarShow{
    return NO;
}
#pragma mark --------------------------

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
    
    [TapResignKeyBoard shareTapResignKeyBoard].tapDelegate = self;
    
    centerY = self.view.center.y;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textEditor = textField;

    return YES;
}
#define DEBUG 1
- (IBAction)logIn{
#ifdef DEBUG 
    RootViewController *root = [RootViewController rootController];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[TapResignKeyBoard shareTapResignKeyBoard] removeGestureFromRootViewController];
    appDelegate.window.rootViewController = root;
    [[TapResignKeyBoard shareTapResignKeyBoard] addGestureToRootViewController];
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

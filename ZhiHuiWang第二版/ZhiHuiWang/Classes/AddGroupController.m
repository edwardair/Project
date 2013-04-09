//
//  GroupManagerController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-3.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "AddGroupController.h"
#import "StaticManager.h"
@interface AddGroupController ()

@end

@implementation AddGroupController
@synthesize delegate;
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
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveEnterData)];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(callBack)];
    _userDefinedBar.topItem.leftBarButtonItem = back;
    _userDefinedBar.topItem.rightBarButtonItem = done;
    _userDefinedBar.topItem.title = @"添加分组";

}
#pragma mark 注销键盘
- (IBAction)resignKeyboard:(id)sender {
    [_Code resignFirstResponder];
    [_Name resignFirstResponder];
    [_Mark resignFirstResponder];
}
- (void)saveEnterData{
    if (_Code.text.length>0 && _Name.text.length>0) {
        [self.delegate delegateSaveGroup:self];
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [StaticManager showAlertWithTitle:nil message:@"必填项目不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitle:nil];
    }
    
}
- (void)callBack{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  CellPushedViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-29.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CellPushedViewController.h"
#import "StaticManager.h"
@interface CellPushedViewController (){
    UIView *textEditor;
    float centerY;
}

@end

@implementation CellPushedViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark TapDelegate
- (UIView *)willFitPointOfView{
    return self.view;
}
- (float )orgCenterYOfView{
//    NSLogFloat(centerY);
    return centerY;
}
- (UIView *)curClickedText{
    return textEditor;
}
- (BOOL)statusBarShow{
    return YES;
}
- (BOOL)navigationBarShow{
    return self.navigationController?YES:NO;
}
#pragma mark --------------------------


- (void)upMoveWithView:(UIView *)view{
    for (UIView *sub in view.subviews) {
        sub.transform = CGAffineTransformMakeTranslation(0, -45);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [TapResignKeyBoard shareTapResignKeyBoard].preDelegate = [TapResignKeyBoard shareTapResignKeyBoard].tapDelegate;
    [TapResignKeyBoard shareTapResignKeyBoard].tapDelegate = self;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveEnterData)];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(callBack)];

    if (self.navigationController) {
        _userDefineNavBar.hidden = YES;
        self.navigationItem.rightBarButtonItem = done;
        self.navigationItem.leftBarButtonItem = back;
        
        [self upMoveWithView:self.view];
        
    }else{
        _userDefineNavBar.topItem.leftBarButtonItem = back;
        _userDefineNavBar.topItem.rightBarButtonItem = done;
    }

    UIGestureRecognizer *emptyAreaTouched = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboardInOtherArea)];
    [emptyAreaTouched setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:emptyAreaTouched];

    _name.delegate = self;
    _post.delegate = self;
    _tel.delegate = self;
}
#pragma mark textFieldDelegate
- (BOOL )textFieldShouldBeginEditing:(UITextField *)textField{
//    if ([textField.superview isEqual:self.view]) {
//        NSLogString(textField.superview);
//    }
    textEditor = textField;
    return YES;
}
- (void)resignKeyboardInOtherArea{
    [_name resignFirstResponder];
    [_tel resignFirstResponder];
    [_post resignFirstResponder];
}

- (IBAction)sexButton:(UIButton *)sender{
    BOOL man = [sender.titleLabel.text isEqualToString:@"男"];
    [sender setTitle:man?@"女":@"男" forState:UIControlStateNormal];
    [sender setTitle:man?@"女":@"男" forState:UIControlStateHighlighted];
}

- (IBAction)textFieldDone:(id)sender {
    [sender resignFirstResponder];
}

- (void)saveEnterData{
    if (![self isVereistEmpty]) {
        [StaticManager showAlertWithTitle:nil message:@"必填项目不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    BOOL type = 0;//0   代表 添加操作  1为编辑操作
    if ([self.navigationItem.title isEqualToString:@"编辑参会代表"]) {
        type = 1;
    }
    [self.delegate saveCell:self addType:type];

}
- (void)editFail{
    NSString *msg = @"创建失败";
    if (self.navigationController) {
        msg = @"修改失败";
    }
    [StaticManager showAlertWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
}
- (void)callBack{
    //取消此页面的通知  由于上一页面的delegate=nil，故直接用nil赋值;
    [TapResignKeyBoard shareTapResignKeyBoard].tapDelegate = nil;
    if (self.navigationController) {
        [self popViewController];
    }else{
        [self disMissViewController];
    }
}
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)disMissViewController{
    [self dismissModalViewControllerAnimated:YES];
}
//检测 必填项目是否为空
- (BOOL)isVereistEmpty{
    if (_name.text.length==0 || _tel.text.length==0) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

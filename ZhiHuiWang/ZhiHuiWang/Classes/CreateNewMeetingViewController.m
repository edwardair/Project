//
//  CreateNewMeetingViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CreateNewMeetingViewController.h"
#import "My97DatePicker.h"
#import "ShowDownButton.h"
#import "UAndDLoad.h"
#import "SBJson.h"
#define Title @"新建会议"
@interface CreateNewMeetingViewController (){
    UIView *curPresentUIView;
}
@property (strong,nonatomic) id textKeyBoard;
@end

@implementation CreateNewMeetingViewController

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
    
    self.navigationItem.title = Title;
    
    //-------------------------新建会议
    _meetingName.delegate = self;
    _meetingStartDate.delegate = self;
    _meetingEndDate.delegate = self;
    _meetingAddress.delegate = self;
    _meetingSponsor.delegate = self;
    _meetingJoiner.delegate = self;
    _meetingTheme.delegate = self;
    _meetingRequriements.delegate = self;
    
    _meetingTheme.editable = YES;
    _meetingRequriements.editable = YES;

    _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.contentSize.width, _bottomScrollView.contentSize.height+700);
    
    _bottomScrollView.delegate = self;

    NSData *data = [UAndDLoad downLoadWithUrl:GetMeetingList];
    NSMutableArray *nameArray = [self getMeetingNameList:data];
    [_meetingType initializeButtonData:nameArray];

    //-------------------------人员管理
    
    
    //-------------------------群组管理
    //-------------------------议程管理

    
    
    UIGestureRecognizer *emptyAreaTouched = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboardInOtherArea)];
    [emptyAreaTouched setCancelsTouchesInView:NO];

    [_bottomScrollView addGestureRecognizer:emptyAreaTouched];
    
    [self CreateNewMeeting:nil];
    
}
#pragma mark SBJson解析 会议名称
- (NSMutableArray *)getMeetingNameList:(NSData *)data{
    NSMutableArray *nameList = [NSMutableArray array];
    NSData *downLoadData = [UAndDLoad downLoadWithUrl:GetMeetingList];
    NSString *str1 = [[NSString alloc]initWithData:downLoadData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonObject = [[SBJsonParser alloc]init];
    NSMutableDictionary *dic = [jsonObject objectWithString:str1];
    
    NSArray *listDic = [dic objectForKey:@"hylist"];
    
    for (NSDictionary *objDic in listDic) {
        NSString *s = [objDic objectForKey:@"hyname"];
        [nameList addObject:s];
    }
    NSLog(@"%@",nameList);
    return nameList;
}
#pragma mark 弹出警告
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)msg
                  delegate:(id )delegate
         cancelButtonTitle:(NSString *)cancle
          otherButtonTitle:(NSString *)other{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancle otherButtonTitles:other, nil];
    [alert show];
}
#pragma mark 新建会议  二级 按钮
enum{
    CNM_C,
    CNM_M,
    CNM_G,
    CNM_S,
};
- (IBAction)CreateNewMeeting:(ShowDownButton *)sender{
    //选中框
    if (sender) {
        _coverImage.center = sender.center;
    }

    UIView *temp = nil;
    switch (sender.tag) {
        case CNM_C:
            temp = _createNewMeetingView;
            break;
        case CNM_M:
            temp = _memberManageView;
            break;
        case CNM_G:
            temp = nil;
            break;
        case CNM_S:
            temp = nil;
            break;
        default:
            break;
    }
    if (temp) {
        if (temp.superview) {
            if (temp.hidden) {
                temp.hidden = NO;
            }
        }else{
            [_bottomScrollView addSubview:temp];
            [temp setTransform:CGAffineTransformMakeTranslation(0, 65)];
        }
        if (curPresentUIView) {
            curPresentUIView.hidden = YES;
        }
        curPresentUIView = temp;
    }

}
#pragma mark --------------------新建会议  子菜单
#pragma mark 新建会议 中 "确定"按钮
- (BOOL)checkPostEnable:(UIView *)curPresentView{
    for (UIView *subView in curPresentView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *temp = (UITextField *)subView;
            //UITextField 当placeholder为“必填”，并且text为空时 无法上传
            if ([[temp placeholder] isEqualToString:@"必填"]) {
                if (temp.text.length==0) {
                    return NO;
                }
            }
        }else if ([subView isKindOfClass:[UITextView class]]){
            UITextView *temp = (UITextView *)subView;
            //UITextView 默认为为“必填”，所以当text为空时 无法上传
            if (temp.text.length==0) {
                return NO;
            }
        }
    }
    return YES;
}
- (IBAction)CreateNewMeeting_OK{
    if (![self checkPostEnable:_createNewMeetingView]) {
        [self showAlertWithTitle:nil message:@"必填项目不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitle:nil];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_meetingName.text forKey:HYName];
    [params setObject:_meetingAddress.text forKey:HYAddress];
    [params setObject:_meetingStartDate.text forKey:HYStartTime];
    [params setObject:_meetingEndDate.text forKey:HYEndTime];
    [params setObject:_meetingSponsor.text forKey:HYZBF];
    [params setObject:_meetingJoiner.text?_meetingJoiner.text:@"" forKey:HYXBF];
     //TODO: 会议类型关键字无定义
//    [params setObject:_meetingType forKey:HYTheme]; 
    [params setObject:_meetingTheme.text forKey:HYTheme];
    [params setObject:_meetingRequriements.text forKey:HYRequirments];
    
    //上传数据
    [UAndDLoad upLoad:params withURL:ModifyData];
    
}
#pragma mark 新建会议 中 "全部重置"按钮
- (IBAction)CreateNewMeeting_ResetAll{
    for (UIView *subView in _createNewMeetingView.subviews) {
        if ([subView isKindOfClass:[UITextView class]]) {
            [(UITextView *)subView setText:nil];
        }else if ([subView isKindOfClass:[UITextField class]]) {
            [(UITextField *)subView setText:nil];
        }
    }
    [_meetingType setTitle:@"--请选择--" forState:UIControlStateNormal];
}

#pragma mark --------------------人员管理  子菜单
- (IBAction)MM_AddMember:(id)sender{
    
}//添加
- (IBAction)MM_ModifyMember:(id)sender{
    
}//编辑
- (IBAction)MM_DeleteMember:(id)sender{
    
}//删除

#pragma mark --------------------群组管理  子菜单
#pragma mark --------------------议程管理  子菜单


#pragma mark 注销键盘
- (IBAction)resignKeyboard:(id)sender {
    [sender resignFirstResponder];
    self.textKeyBoard = nil;

}

#pragma mark 点击空白区域 注销键盘  UIButton的下拉菜单
- (void)resignKeyboardInOtherArea{
    if (self.textKeyBoard) {
        [self.textKeyBoard resignFirstResponder];
        self.textKeyBoard = nil;
    }
    if (!_meetingType.downScrollView.hidden) {
        _meetingType.downScrollView.hidden = YES;
    }
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"ShouldBeginEditing:%@",textField.text);
    self.textKeyBoard = textField;
    
    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
        [(My97DatePicker *)textField selectDate];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@",textField.text);
    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
        NSLog(@"处理时间格式");
        
    }
    
    return YES;
}

#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.textKeyBoard = textView;

    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self resignKeyboard:textView];
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

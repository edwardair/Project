//
//  AddAgendaViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-7.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "AddAgendaViewController.h"
#import "ShowDownButton.h"
#import "SBJsonResolveData.h"
#import "StaticManager.h"
#import "TimeChooseView.h"
@interface AddAgendaViewController (){
    TimeChooseView *timeChooseView;

}
@property (nonatomic,retain) id textEditor;
@end

@implementation AddAgendaViewController
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
    
    if (self.navigationController) {
//        CGRect rect = [[UIScreen mainScreen]applicationFrame];
        self.navigationItem.title = @"修改";
        _scrollView.transform = CGAffineTransformMakeTranslation(0, -self.navigationController.navigationBar.frame.size.height);
        
        _userDefineNavBar.hidden = YES;
        self.navigationItem.rightBarButtonItem = done;
        self.navigationItem.leftBarButtonItem = back;
    }else{
        _userDefineNavBar.topItem.leftBarButtonItem = back;
        _userDefineNavBar.topItem.rightBarButtonItem = done;
        _userDefineNavBar.topItem.title = @"添加";
    }

    UIGestureRecognizer *emptyAreaTouched = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboardInOtherArea)];
    [emptyAreaTouched setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:emptyAreaTouched];

    _agendaNameField.delegate = self;
    _agendaFZRField.delegate = self;
    _agendaTelField.delegate = self;
    _agendaStartDate.delegate = self;
    _agendaEndDate.delegate = self;
    _agendaContentField.delegate = self;

    [_Participants initializeButton];
    _Participants.delegate = self;
    
    _agendaContentField.delegate = self;
    
    CGRect screenRect = [[UIScreen mainScreen]applicationFrame];
    timeChooseView = [[TimeChooseView alloc]initWithFrame:CGRectMake(0, screenRect.size.height+self.view.frame.origin.y, screenRect.size.width, 246)];

    [self.view addSubview:timeChooseView];
    [self.view bringSubviewToFront:timeChooseView];

    _scrollView.scrollEnabled = NO;
//    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height+650);

}

- (void)callBack{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}
- (void)showCreateNotFinish{
    [StaticManager showAlertWithTitle:nil message:@"必填项目不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitle:nil];
}
- (BOOL)isVereistEmpty{
    if (_agendaNameField.text.length==0 ||
        _agendaFZRField.text.length==0 ||
        _agendaTelField.text.length==0 ||
        _agendaStartDate.text.length==0 ||
        _agendaEndDate.text.length==0 ||
        _Participants.meetingId==-1) {
        return NO;
    }
    return YES;
}

- (void)saveEnterData{
//    _agendaStartDate.text = @"2012-03-04 10:00:00";
//    _agendaEndDate.text = @"2012-03-05 10:00:00";

    if (![self isVereistEmpty]) {
        [self showCreateNotFinish];
        return;
    }
    
    BOOL scuess = NO;
    if (self.navigationController)
       scuess = [SBJsonResolveData modifyPointMeetingOneAgendaWithHyIndex:_meetingIndex
                                                      agendaIndex:_agendaIndex
                                                        ycName:_agendaNameField.text
                                                          hcJJ:_agendaContentField.text
                                                          info:_agendaStartDate.text
                                                           msg:_agendaEndDate.text
                                                         ycLXR:_agendaFZRField.text
                                                         ycTel:_agendaTelField.text
                                                        bdfzId:_Participants.meetingId];
    
    else
       scuess = [SBJsonResolveData addPointMeetingOneAgendaWithHyIndex:_meetingIndex
                                                        ycName:_agendaNameField.text
                                                          hcJJ:_agendaContentField.text
                                                          info:_agendaStartDate.text
                                                           msg:_agendaEndDate.text
                                                         ycLXR:_agendaFZRField.text
                                                         ycTel:_agendaTelField.text
                                                        bdfzId:_Participants.meetingId];
    
    if (scuess) {
        [delegate updateAgendas];
        
        [self callBack];
    }else{
        [StaticManager showAlertWithTitle:nil message:self.navigationController?@"修改失败":@"创建成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }
}
- (IBAction)resignKeyboard:(id)sender {
    [sender resignFirstResponder];    
}

- (void)resignKeyboardInOtherArea{
    
    [_textEditor resignFirstResponder];
    
    [timeChooseView showPicker:NO withField:nil];
    
}



#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSLog(@"ShouldBeginEditing:%@",textField.text);
//    [_agendaContentField resignFirstResponder];

    if ([textField isEqual:_agendaStartDate] || [textField isEqual:_agendaEndDate]) {
        if (textField.text.length==0){
            [timeChooseView.datePicker setDate:[NSDate date]];

        }
        if (_textEditor) {
            [_textEditor resignFirstResponder];
            _textEditor = nil;
        }

        [timeChooseView showPicker:YES withField:textField];
        
        return NO;
    }
    _textEditor = textField;

    [timeChooseView showPicker:NO withField:nil];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    NSLog(@"%@",textField.text);
    if ([textField isEqual:_agendaStartDate] || [textField isEqual:_agendaEndDate]) {
        NSLog(@"处理时间格式");
        
    }
    
    return YES;
}
#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _textEditor = textView;
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self resignKeyboard:textView];
        return NO;
    }
    [timeChooseView showPicker:NO withField:nil];

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

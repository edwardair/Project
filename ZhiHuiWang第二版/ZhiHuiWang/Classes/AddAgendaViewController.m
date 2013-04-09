//
//  AddAgendaViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-7.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "AddAgendaViewController.h"
#import "My97DatePicker.h"
#import "ShowDownButton.h"
#import "SBJsonResolveData.h"
#import "StaticManager.h"
#import "CKCalendarView.h"
@interface AddAgendaViewController ()

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
        _userDefineNavBar.hidden = YES;
        self.navigationItem.rightBarButtonItem = done;
        self.navigationItem.leftBarButtonItem = back;
    }else{
        _userDefineNavBar.topItem.leftBarButtonItem = back;
        _userDefineNavBar.topItem.rightBarButtonItem = done;
    }

    UIGestureRecognizer *emptyAreaTouched = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboardInOtherArea)];
    [emptyAreaTouched setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:emptyAreaTouched];

    _agendaStartDate.delegate = self;
    _agendaEndDate.delegate = self;
    
    [_Participants initializeButton];
    _Participants.delegate = self;
    
    _agendaContentField.delegate = self;
    
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
    _agendaStartDate.text = @"2012-03-04 10:00:00";
    _agendaEndDate.text = @"2012-03-05 10:00:00";

    if (![self isVereistEmpty]) {
        [self showCreateNotFinish];
        return;
    }
    

    if (self.navigationController)
        [SBJsonResolveData modifyPointMeetingOneAgendaWithHyIndex:_meetingIndex
                                                      agendaIndex:_agendaIndex
                                                        ycName:_agendaNameField.text
                                                          hcJJ:_agendaContentField.text
                                                          info:_agendaStartDate.text
                                                           msg:_agendaEndDate.text
                                                         ycLXR:_agendaFZRField.text
                                                         ycTel:_agendaTelField.text
                                                        bdfzId:_Participants.meetingId];
    
    else
        [SBJsonResolveData addPointMeetingOneAgendaWithHyIndex:_meetingIndex
                                                        ycName:_agendaNameField.text
                                                          hcJJ:_agendaContentField.text
                                                          info:_agendaStartDate.text
                                                           msg:_agendaEndDate.text
                                                         ycLXR:_agendaFZRField.text
                                                         ycTel:_agendaTelField.text
                                                        bdfzId:_Participants.meetingId];
    
    [delegate updateAgendas];
    
    [self callBack];
}
- (IBAction)resignKeyboard:(id)sender {
    [sender resignFirstResponder];    
}

- (void)resignKeyboardInOtherArea{
    [_agendaNameField resignFirstResponder];
    [_agendaFZRField resignFirstResponder];
    [_agendaStartDate resignFirstResponder];
    [_agendaEndDate resignFirstResponder];
    [_agendaTelField resignFirstResponder];
    [_agendaContentField resignFirstResponder];
}



#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSLog(@"ShouldBeginEditing:%@",textField.text);
    
    if ([textField isEqual:_agendaStartDate] || [textField isEqual:_agendaEndDate]) {
        [(My97DatePicker *)textField selectDate];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"%@",textField.text);
    if ([textField isEqual:_agendaStartDate] || [textField isEqual:_agendaEndDate]) {
        NSLog(@"处理时间格式");
        
    }
    
    return YES;
}
#pragma mark UITextView Delegate
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

@end

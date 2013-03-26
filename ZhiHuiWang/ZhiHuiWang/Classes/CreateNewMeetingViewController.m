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
#define Title @"新建会议"
@interface CreateNewMeetingViewController ()

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

    _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.contentSize.width, _bottomScrollView.contentSize.height+1000);

    NSArray *nameArray = @[@"A",@"B",@"C",@"D",@"E",];
    [_meetingType initializeButtonData:nameArray];

}

#pragma mark 注销键盘
- (IBAction)resignKeyboard:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"ShouldBeginEditing:%@",textField.text);

    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
        [(My97DatePicker *)textField selectDate];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"DidBeginEditing:%@",textField.text);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@",textField.text);
    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
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

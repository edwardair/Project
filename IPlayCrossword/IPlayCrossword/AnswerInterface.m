//
//  AnswerInterface.m
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-5-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "AnswerInterface.h"
@interface AnswerInterface(){
    UIView *bootView;
}
@end

@implementation AnswerInterface
@synthesize delegate;
+(id )initizlizeWithQ:(NSString *)question AndA:(NSString *)answer{
    return [[[[self class]alloc]initWithQ:question AndA:answer] autorelease];
}
-(void)autoSizeLabel:(UILabel *)label{
    CGSize s = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = label.frame;
    rect.size.height = s.height;
    label.frame = rect;
}

- (id )initWithQ:(NSString *)question AndA:(NSString *)answer{
    if (self == [super init]) {
        
        bootView = [Director view];
        
        _loadView = [[UIView alloc]initWithFrame:bootView.frame];
        [bootView addSubview:_loadView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, bootView.frame.size.height-130, 300, 40)];
        [_loadView addSubview:label];
        label.numberOfLines = 0;
        label.textColor = [UIColor blackColor];
        label.text = question;
        [label setFont:[UIFont systemFontOfSize:17.f]];
        label.backgroundColor = [UIColor clearColor];
        self.question = label;
        
        _answer = [[UITextField alloc]initWithFrame:CGRectMake(50, bootView.frame.size.height-80, 220, 50)];
        [_loadView addSubview:_answer];
        [_answer setPlaceholder:@"请输入答案"];
        _answer.backgroundColor = [UIColor redColor];
        _answer.background = [UIImage imageNamed:@"Default.png"];
        _answer.textAlignment = UITextAlignmentCenter;
        _answer.textColor = [UIColor blackColor];
        _answer.delegate = self;
        _answer.returnKeyType = UIReturnKeyDone;
        
        _answer.text = answer;
        _answer.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)msg
                  delegate:(id )delegate
         cancelButtonTitle:(NSString *)cancle
          otherButtonTitle:(NSString *)other{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancle otherButtonTitles:other, nil];
    [alert show];
}

//delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_answerLength==0) {
        [AnswerInterface showAlertWithTitle:@"请选择一个问题" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_answer resignFirstResponder];

    if (self.delegate) {
        [self.delegate UITextFieldShouldReturn];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length>=_answerLength && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
- (void)dealloc{
    for (UIView *subView in bootView.subviews) {
        [subView removeFromSuperview];
        subView = nil; 
    }
    bootView = nil;
    [super dealloc];
}
@end

//
//  CommonTextField.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-17.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CommonTextField.h"

static CommonTextField *staticFirstResponder;

@implementation CommonTextField
@synthesize commonDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//+ (CommonTextField *)firstResponder{
//    return staticFirstResponder;
//}

//- (BOOL)textFieldShouldBeginEditing:(CommonTextField *)textField{
//    NSLog(@"13");
////    CommonTextField *temp = (CommonTextField *)textField;
////    if (commonDelegate) {
////        BOOL begin = [commonDelegate textFieldShouldTouchBegan:temp];
////        if (begin) {
////            staticFirstResponder = temp;
////        }
////        return begin;
////    }
////    staticFirstResponder = temp;
//    return YES;
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    CommonTextField *temp = (CommonTextField *)textField;
//
//    [temp resignFirstResponder];
//    staticFirstResponder = nil;
//    if (commonDelegate) {
//        [commonDelegate textFieldDidEndEdit:temp];
//    }
//    return YES;
//}
@end

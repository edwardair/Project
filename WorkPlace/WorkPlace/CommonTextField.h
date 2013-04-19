//
//  CommonTextField.h
//  WorkPlace
//
//  Created by BlackApple on 13-4-17.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommonTextFieldDelegate;
@interface CommonTextField : UITextField<UITextFieldDelegate>{
    id<CommonTextFieldDelegate> commonDelegate;
}
@property (assign,nonatomic) id<CommonTextFieldDelegate> commonDelegate;

//+ (CommonTextField *)firstResponder;

@end

@protocol CommonTextFieldDelegate <NSObject>
@optional
- (BOOL)delegateTextFieldShouldBeginEdit:(CommonTextField *)field;
- (void)delegateTextFieldDidEndEdit:(CommonTextField *)field;
@end
//
//  GroupManagerController.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-3.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//
//无锡市南长区南湖大道501号创智园A栋 3楼

#import <UIKit/UIKit.h>
@protocol AddGroupControllerDelegate;
@interface AddGroupController : UIViewController<UITextFieldDelegate>{
    id<AddGroupControllerDelegate> delegate;
}
@property (nonatomic,assign) id<AddGroupControllerDelegate> delegate;
@property (strong,nonatomic) IBOutlet UINavigationBar *userDefinedBar;
@property (strong,nonatomic) IBOutlet UITextField *Code;
@property (strong,nonatomic) IBOutlet UITextField *Name;
@property (strong,nonatomic) IBOutlet UITextField *Mark;
- (IBAction)resignKeyboard:(id)sender;
- (void)callBack;
- (void)editFail;
@end

@protocol AddGroupControllerDelegate <NSObject>

- (void)delegateSaveGroup:(AddGroupController *)group;

@end
//
//  CellPushedViewController.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-29.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMethod.h"

@protocol CellPushedViewControllerDelegate;

@interface CellPushedViewController : UIViewController<TapResignKeyBoardDelegate,UITextFieldDelegate>{
    id<CellPushedViewControllerDelegate> delegate;
}
@property (nonatomic,assign) id<CellPushedViewControllerDelegate> delegate;

@property (strong,nonatomic) IBOutlet UINavigationBar *userDefineNavBar;
@property (strong,nonatomic) IBOutlet UITextField *name;
@property (strong,nonatomic) IBOutlet UITextField *post;
@property (strong,nonatomic) IBOutlet UITextField *tel;
@property (strong,nonatomic) IBOutlet UIButton *sex;
@property (nonatomic) int index;

- (IBAction)sexButton:(id)sender;
- (IBAction)textFieldDone:(id)sender;
- (void)callBack;
- (void)editFail;
@end

@protocol CellPushedViewControllerDelegate <NSObject>

- (void)saveCell:(CellPushedViewController *)cellViewController addType:(int )type;

@end
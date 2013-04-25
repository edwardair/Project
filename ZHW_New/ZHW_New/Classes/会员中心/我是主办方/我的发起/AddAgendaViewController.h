//
//  AddAgendaViewController.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-7.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMethod.h"

@class ShowDownButton;

@protocol AgendaDelegate;

@interface AddAgendaViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,TapResignKeyBoardDelegate>{
    id<AgendaDelegate> delegate;
}
@property (nonatomic,assign) id<AgendaDelegate> delegate;
@property (nonatomic,assign) int meetingIndex;
@property (nonatomic,assign) int agendaIndex;

@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic) IBOutlet UINavigationBar *userDefineNavBar;

@property (strong,nonatomic) IBOutlet UITextField *agendaNameField;
@property (strong,nonatomic) IBOutlet UITextField *agendaFZRField;
@property (strong,nonatomic) IBOutlet UITextField *agendaTelField;
@property (strong,nonatomic) IBOutlet UITextField *agendaStartDate;//开始时间
@property (strong,nonatomic) IBOutlet UITextField *agendaEndDate;//结束时间

@property (strong,nonatomic) IBOutlet UITextView *agendaContentField;

@property (strong,nonatomic) IBOutlet ShowDownButton *Participants;

- (IBAction)resignKeyboard:(id)sender;

@end

@protocol AgendaDelegate <NSObject>

@required
- (void)updateAgendas;

@end

//
//  GroupManagerView.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-2.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowDownButton;
@class CreateNewMeetingViewController;
#import "AddGroupController.h"
@interface GroupManagerView : UIView<UITableViewDataSource,UITableViewDelegate,AddGroupControllerDelegate>
@property (strong,nonatomic) IBOutlet UITableView *GM_TableView;
@property (strong,nonatomic) IBOutlet ShowDownButton *GM_MeetingList;
@property (strong,nonatomic) NSMutableArray *GM_TableData;
@property (strong,nonatomic) CreateNewMeetingViewController *superViewController;
- (IBAction)addOneGroup;

@end

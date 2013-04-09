//
//  ModifyPointGroupViewController.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-3.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYCustomMultiSelectPickerView.h"
@interface ModifyPointGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CYCustomMultiSelectPickerViewDelegate>
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int groupIndex;
@property (nonatomic) int meetingIndex;
@end

//
//  ModifyPointGroupViewController.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-3.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPointGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int groupIndex;
@end

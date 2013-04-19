//
//  MoviePlayController.h
//  WorkPlace
//
//  Created by BlackApple on 13-4-18.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"
@interface MoviePlayController : UIViewController<UIPopoverListViewDelegate,UIPopoverListViewDataSource>
@property (retain, nonatomic) IBOutlet UIView *MoviePlayer;
- (IBAction)ConnectMovie:(id)sender;
- (IBAction)BreakMovie:(id)sender;
- (IBAction)DirectionController:(id)sender;
- (IBAction)ProjectDetails:(id)sender;
- (IBAction)IWannaRepairs:(id)sender;

@property (retain,nonatomic) NSMutableArray *dataSource;

@end

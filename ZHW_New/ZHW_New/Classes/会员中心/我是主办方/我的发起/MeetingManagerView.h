//
//  MeetingManagerView.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-7.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAgendaViewController.h"

@class ShowDownButton;
@class CreateNewMeetingViewController;
@interface MeetingManagerView : UIView<UITableViewDataSource,UITableViewDelegate,AgendaDelegate>
@property (strong,nonatomic) CreateNewMeetingViewController *superViewController;

@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) IBOutlet ShowDownButton *meetingList;

- (void)addButton;

@end

/*
 {
 corpid = "<null>";
 dbfzid = 830;
 hcapid = 0;
 hcid = 0;
 hcname = "<null>";
 hotelid = 0;
 hyid = 627;
 id = 614;
 pai = "<null>";
 ycby1 = "<null>";
 ycby2 = "<null>";
 ycby3 = "<null>";
 ycby4 = "<null>";
 ycby5 = "<null>";
 ycbystr1 = "<null>";
 ycbystr2 = "<null>";
 ycbystr3 = "<null>";
 ycbystr4 = "<null>";
 ycbystr5 = "<null>";
 ycclosed = 0;
 yccode = "<null>";
 yccreatetime = "<null>";
 ycedituserid = "<null>";
 ycendtime = "2013-04-02T16:29:51";
 ycjj = 11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
 yclxrdh = 13844445555;
 yclxrid = "<null>";
 yclxrsj = B;
 ycname = A;
 ycsequno = "<null>";
 ycstarttime = "2013-04-01T16:29:49";
 ycupdatetime = "<null>";
 ycupflag = "<null>";
 ycxxjs = "<null>";
 zuo = "<null>";
 }

 
 */
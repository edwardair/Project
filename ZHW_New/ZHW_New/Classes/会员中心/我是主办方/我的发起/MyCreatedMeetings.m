//
//  MyCreatedMeetings.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "MyCreatedMeetings.h"
#import "CommonMethod.h"
#import "SBJsonResolveData.h"
#import "StaticManager.h"
#import "CommonViewPopup.h"
#import "CreateNewMeetingViewController.h"
#import "MemberCenterViewController.h"

@interface MyCreatedMeetings(){
    CommonTableView *tableView;
    CommonViewPopup *popView;
}
@end
@implementation MyCreatedMeetings
+(id)initilaize{
    return [[[self class]alloc]initWithFrame:CGRectMake(0, 0, applicationFrame().size.width, applicationFrame().size.height)] ;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tableView = [[CommonTableView alloc]initWithFrame:CGRectMake(0, 0, applicationFrame().size.width, applicationFrame().size.height-88)];
        [self addSubview:tableView];
        tableView.commonTableViewDelegate = self;
        tableView.cellTitle = @"MyCreatedMeetings";
        [tableView.sectionSource addObject:@"编号     会议名称      会议地点"];
        
        [self updateTableViewDataSource];
        
        self.opaque = YES;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelfHaveSuperView) name:@"superView" object:nil];
        
    }
    return self;
}
- (void)didSelfHaveSuperView{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAMeeting)];
    UIViewControllerOfSuperView(self).parentViewController.navigationItem.rightBarButtonItem = _add;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)addAMeeting{
    CreateNewMeetingViewController *createNewMeeting = [[CreateNewMeetingViewController alloc]initWithNibName:@"CreateNewMeetingViewController" bundle:nil];
    createNewMeeting.preView = self;
    [self.parentController.navigationController pushViewController:createNewMeeting animated:YES];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回123" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
    self.parentController.navigationController.navigationItem.backBarButtonItem  = back;

}
- (void)updateTableViewDataSource{
    [SBJsonResolveData shareMeeting];
    [SBJsonResolveData updateAllMeetingNames];
    
    NSMutableArray *source = [NSMutableArray array];
    NSMutableArray *section = [NSMutableArray array];
    NSMutableArray *temp = [[SBJsonResolveData shareMeeting] meetingNameList];
//    NSLog(@"%@",temp);
    for (NSMutableArray *ar in temp) {
        NSMutableArray *row = [NSMutableArray array];
        [row addObject:[NSString stringWithFormat:@"%02d",1+[temp indexOfObject:ar]]];
        [row addObject:ar[0]];
        [row addObject:ar[4]];
        [section addObject:row];
        [source addObject:section];

    }
    tableView.rowSource = source;
    [tableView reloadData];
}
- (void)setCellLabelsFrams:(CommonTableViewCell *)cell{
    [cell setLabelsFrame:
     CGRectMake(10, 0, 30, 30),
     CGRectMake(60, 0, 80, 30),
     CGRectMake(160, 0, 160, 30),
     CGRectNull];
}
- (UILabel *)labelWithText:(NSString *)text frame:(CGRect )frame{
    UILabel *l = [[UILabel alloc]init];
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    CGSize s = [text sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    [l setText:text];
    [l setTextColor:[UIColor blackColor]];
    [l setTextAlignment:NSTextAlignmentLeft];
    [l setBackgroundColor:[UIColor whiteColor]];
//    [l setLineBreakMode:NSLineBreakByWordWrapping];
    frame.size.height = s.height;
    [l setFrame:frame];

    return l;//[l autorelease];
}
- (void)autoFitSizeOf:(UILabel *)curLabel preLabel:(UILabel *)preLabel{
    CGRect preFrame = preLabel.frame;
    CGPoint curLabelCenter = curLabel.center;
    curLabelCenter.y = preLabel.center.y+preFrame.size.height/2+curLabel.frame.size.height/2+20;
    curLabel.center = curLabelCenter;
}
-(void)autoSizeLabel:(UILabel *)label{
    CGSize s = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
    if (s.height==0) {
        s.height = 21.0f;
    }
    CGRect rect = label.frame;
    rect.size.height = s.height;
    label.frame = rect;
}
- (void)cellClickedAtIndexPath:(NSIndexPath *)path{
//    CommonViewPopup *popView = [CommonViewPopup initializeView];
    
    if (!popView) {
        popView = (CommonViewPopup *)[[NSBundle mainBundle] loadNibNamed:@"ShowThisMeeting" owner:self options:nil][0];
        [popView initializeView];
//        [self addSubview:popView];
    }
    
    int row = path.row;
    NSMutableArray *meeting = [[[SBJsonResolveData shareMeeting] meetingNameList] objectAtIndex:row];

//    NSString *number = [NSString stringWithFormat:@"%02d",row+1];
    NSString *name = [NSString stringWithFormat:@"%@",[meeting objectAtIndex:0]];
    NSString *start = [NSString stringWithFormat:@"%@",[meeting objectAtIndex:2]];
    NSString *end = [NSString stringWithFormat:@"%@",[meeting objectAtIndex:3]];
    NSString *address = [NSString stringWithFormat:@"%@",[meeting objectAtIndex:4]];
    NSString *theme = [NSString stringWithFormat:@"%@",[meeting objectAtIndex:5]];
        
    _name.text = [NSString stringWithFormat:@"%@%@",@"会议名称：",name];

    _start.text = [NSString stringWithFormat:@"%@%@",@"开始时间：",start];
    [self autoFitSizeOf:_start preLabel:_name];

    _end.text = [NSString stringWithFormat:@"%@%@",@"结束时间：",end];
    [self autoFitSizeOf:_end preLabel:_start];

    _address.text = [NSString stringWithFormat:@"%@",address];
    [self autoSizeLabel:_address];
    [self autoFitSizeOf:_address preLabel:_end];

    CGRect _rectA = _addressTitle.frame;
    _rectA.origin.y = _address.frame.origin.y;
    _rectA.size.height = _address.frame.size.height;
    _addressTitle.frame = _rectA;

    _theme.text = [NSString stringWithFormat:@"%@",theme];
    [self autoSizeLabel:_theme];
    [self autoFitSizeOf:_theme preLabel:_address];
    
    CGRect _rectB = _themeTitle.frame;
    _rectB.origin.y = _theme.frame.origin.y;
    _rectB.size.height = _theme.frame.size.height;
    _themeTitle.frame = _rectB;

    UIViewController *c = [[UIViewController alloc]init];
    [c setView:popView];
//    [popView showAction];
    [self.parentController.navigationController pushViewController:c animated:YES];
    
}
//- (void)dealloc{
//    NSLog(@"我的发起   释放");
////    self.add = nil;
//    [super dealloc];
//}
@end

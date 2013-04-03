//
//  GroupManagerView.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-2.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "GroupManagerView.h"
#import "SBJsonResolveData.h"
#import "ShowDownButton.h"
#import "CreateNewMeetingViewController.h"
#import "AddGroupController.h"
@class CreateNewMeetingViewController;
#define TableHeader @"编号     名称    创建时间            备注"
@implementation GroupManagerView

- (NSMutableArray *)GM_TableData{
    if (!_GM_TableData) {
        _GM_TableData = [[NSMutableArray alloc]init];
    }
    return _GM_TableData;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [_GM_MeetingList initializeButton];
    _GM_MeetingList.delegate = self;
    _GM_MeetingList.selector = @selector(GM_MeetingListButtonClicked);
    
    _GM_TableView.delegate = self;
    _GM_TableView.dataSource = self;
    
}
- (void)GM_MeetingListButtonClicked{
    int tag = _GM_MeetingList.meetingId;
    
    [self.GM_TableData removeAllObjects];
    
    if (tag!=-1) {
        [SBJsonResolveData getPointMeetingOfGroupsWithIndex:tag];
        
        _GM_TableData = [[SBJsonResolveData shareMeeting] pointMeetingGroups];
        NSLog(@"%@",_GM_TableData);
    }
    
    [_GM_TableView reloadData];

}

//添加 分组
- (IBAction)addOneGroup{
    AddGroupController *addController = [[AddGroupController alloc]initWithNibName:@"AddGroupController" bundle:nil];
    
    CreateNewMeetingViewController *c = (CreateNewMeetingViewController *)self.superview.superview;
    NSLog(@"%@",c.description);
    [c presentModalViewController:addController animated:YES];
    
}

#pragma mark UITableView Delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //  UILabel *result = nil;
    
    UIView *result = nil;
    
    if([tableView isEqual:_GM_TableView] && section == 0){
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        
        label.text = TableHeader;
        
        label.backgroundColor = [UIColor grayColor];
        
        [label sizeToFit];
        
        label.frame = CGRectMake(label.frame.origin.x, 0, 320, label.frame.size.height);
        
        CGRect resultFrame = CGRectMake(0.0f, 0.0f, label.frame.size.height, label.frame.size.width + 10.0f);
        
        result = [[UIView alloc]initWithFrame:resultFrame];
        
        [result addSubview:label];
        
    }
    
    return result;
    
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _GM_TableData.count;
}
- (void)appendLabelWithString:(NSString *)content
                        Frame:(CGRect )frame
                    SuperView:(UITableViewCell *)cell{
    
    UILabel *code = [[UILabel alloc]init];
    code.numberOfLines = 2;
    code.lineBreakMode = UILineBreakModeCharacterWrap;
    code.text = content;
    code.frame = frame;
    code.textAlignment = UITextAlignmentCenter;
    [cell addSubview:code];
}
- (void)appendCellString:(NSDictionary *)dic object:(UITableViewCell *)cell{
    
    NSArray *key = @[DBFZCode,DBFZName,DBFZCreatetime,DBFZRemark];
    float orginX[4] = {0,50,100,200};
    float width[4] = {50,50,90,120};

    for (int i = 0; i < 4; i++) {
        NSMutableString *s = [NSMutableString stringWithString:[dic objectForKey:[key objectAtIndex:i]]];
        if (i==2) {
            [s deleteCharactersInRange:[s rangeOfString:@"T"]];
//            [s replaceCharactersInRange:[s rangeOfString:@"T"] withString:@"  "];
        }
        CGRect frame = CGRectMake(orginX[i], 0, width[i], cell.frame.size.height);
        
        [self appendLabelWithString:s Frame:frame SuperView:cell];
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"Group";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
    }
    
    NSUInteger row = [indexPath row];

    NSDictionary *dic = [_GM_TableData objectAtIndex:row];
    
    [self appendCellString:dic object:cell];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    
    //tableView 删除数据操作 同时上传服务器删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [SBJsonResolveData deletePoitMeetingWithIndex:row];
        
        // Delete the row from the data source.
//        [_MM_MemberList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

@end

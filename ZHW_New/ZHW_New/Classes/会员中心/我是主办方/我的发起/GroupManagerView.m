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
#import "StaticManager.h"
#import "ModifyPointGroupViewController.h"
#define TableHeader @"  编号     名称      创建时间          备注"
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
    _GM_MeetingList.showDataArray = [[SBJsonResolveData shareMeeting] meetingNameList];
    
    _GM_TableView.delegate = self;
    _GM_TableView.dataSource = self;
    
    [_GM_TableView reloadData];

}
- (void)GM_MeetingListButtonClicked{
    int tag = _GM_MeetingList.meetingId;

    [self.GM_TableData removeAllObjects];
    
    if (tag!=-1) {
        [SBJsonResolveData getPointMeetingOfGroupsWithIndex:tag];
        
        _GM_TableData = [[SBJsonResolveData shareMeeting] pointMeetingGroups];
//        NSLog(@"%@",_GM_TableData);
    }
    
    [_GM_TableView reloadData];

}

//添加 分组
- (void)addOneGroup{
    if (_GM_MeetingList.meetingId==-1) {
        [StaticManager showAlertWithTitle:nil message:@"请选择一个会议" delegate:self cancelButtonTitle:@"OK" otherButtonTitle:nil];
        return;
    }

    AddGroupController *addController = [[AddGroupController alloc]initWithNibName:@"AddGroupController" bundle:nil];
    addController.delegate = self;
    [self.superViewController presentModalViewController:addController animated:YES];
    
}
//delegate
- (void)delegateSaveGroup:(AddGroupController *)group{
    NSString *code = group.Code.text;
    NSString *name = group.Name.text;
    NSString *mark = group.Mark.text;
    BOOL scuess = NO;
    scuess = [SBJsonResolveData addPointMeetingWithIndex:_GM_MeetingList.meetingId
                                                    Code:code
                                                    Name:name
                                                    Mark:mark];
    
    if (scuess) {
        [SBJsonResolveData getPointMeetingOfGroupsWithIndex:_GM_MeetingList.meetingId];
        _GM_TableData = [[SBJsonResolveData shareMeeting] pointMeetingGroups];
        [_GM_TableView reloadData];
        [group callBack];
    }
    else
        [group editFail];

}
#pragma mark UITableView Delegate
//- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 22.f;
//}

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
                    SuperView:(UITableViewCell *)cell
                     TagIndex:(int )tag{
    UILabel *code = (UILabel *)[cell viewWithTag:tag];

    if (!code) {
        code = [[UILabel alloc]init];
        code.numberOfLines = 2;
        code.lineBreakMode = UILineBreakModeCharacterWrap;
        code.frame = frame;
        code.textAlignment = UITextAlignmentCenter;
        code.tag = tag;
        [cell addSubview:code];
    }
    code.text = content;
}
- (void)appendCellString:(NSDictionary *)dic object:(UITableViewCell *)cell{
    
    NSArray *key = @[DBFZCode,DBFZName,DBFZCreatetime,DBFZRemark];
    float orginX[4] = {0,40,120,210};
    float width[4] = {40,80,90,110};

    for (int i = 0; i < 4; i++) {
        NSMutableString *s = [NSMutableString stringWithString:[dic objectForKey:[key objectAtIndex:i]]];
//        NSLogString(s);
        if (i==2 && s.length>0) {
            [s deleteCharactersInRange:[s rangeOfString:@"T"]];
        }
        CGRect frame = CGRectMake(orginX[i], 0, width[i], cell.frame.size.height);
        
        [self appendLabelWithString:s Frame:frame SuperView:cell TagIndex:i+1];
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"Group";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSUInteger row = [indexPath row];

    NSDictionary *dic = [_GM_TableData objectAtIndex:row];
    
    [self appendCellString:dic object:cell];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    ModifyPointGroupViewController *groupMembers = [[ModifyPointGroupViewController alloc]initWithNibName:@"ModifyPointGroupViewController" bundle:nil];
    groupMembers.groupIndex = row;
    groupMembers.meetingIndex = _GM_MeetingList.meetingId;
    groupMembers.navigationItem.title = [[_GM_TableData objectAtIndex:row] objectForKey:DBFZName];
    [self.superViewController.navigationController pushViewController:groupMembers animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    
    //tableView 删除数据操作 同时上传服务器删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       BOOL scuess = [SBJsonResolveData deletePointMeetingGroupWithIndex:row];
        if (scuess) {
            [_GM_TableView reloadData];
        }else{
            [StaticManager showAlertWithTitle:nil message:@"删除分组失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
    
    }
}

@end

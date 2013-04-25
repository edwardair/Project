//
//  MeetingManagerView.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-7.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "MeetingManagerView.h"
#import "CreateNewMeetingViewController.h"
#import "ShowDownButton.h"
#import "SBJsonResolveData.h"
#import "AgendaCell.h"
#import "AddAgendaViewController.h"
#import "StaticManager.h"

#define TableHeader @"    议程名            负责人"
@interface MeetingManagerView()@property (strong,nonatomic) NSMutableArray *dataSource;
@end
@implementation MeetingManagerView

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
    [_meetingList initializeButton];
    _meetingList.delegate = self;
    _meetingList.selector = @selector(meetingListButtonClicked);

    _meetingList.showDataArray = [[SBJsonResolveData shareMeeting] meetingNameList];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    
}
- (void)addButton{
    
    if (_meetingList.meetingId==-1) {
        [StaticManager showAlertWithTitle:nil message:@"请选择一个会议" delegate:self cancelButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    
    AddAgendaViewController *c = [[AddAgendaViewController alloc]initWithNibName:@"AddAgendaViewController" bundle:nil];
    c.delegate = self;

    [self.superViewController presentModalViewController:c animated:YES];
    
    [self initlizeBtnData:c];
}
- (void)meetingListButtonClicked{
    int tag = _meetingList.meetingId;
    
    if (tag!=-1) {
        [SBJsonResolveData getMeetingAllMeetingsWithIndex:tag];
        
        _dataSource = [[SBJsonResolveData shareMeeting] agenda];

    }
    
    [_tableView reloadData];

}
#pragma mark AddAgendaViewController Delegate
- (void)updateAgendas{
    [self meetingListButtonClicked];
}

#pragma mark UITableView Delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //  UILabel *result = nil;
    
    UIView *result = nil;
    
    if([tableView isEqual:_tableView] && section == 0){
        
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
    return _dataSource.count;
}
- (void)setLabelText:(UILabel *)label withText:(NSString *)str{
    if ([str isEqual:[NSNull null]]) {
        str = @"";
    }
    label.text = str;
    label.textAlignment = UITextAlignmentCenter;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"Agenda";
    
    AgendaCell *cell = (AgendaCell *)[tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell =  (AgendaCell *)[[NSBundle mainBundle] loadNibNamed:@"AgendaCell" owner:self options:nil][0];
    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *dic = [_dataSource objectAtIndex:row];

    [self setLabelText:cell.agendaName withText:[dic objectForKey:YCName]];
    [self setLabelText:cell.agendaFZR withText:[dic objectForKey:YCFZR]];

    return cell;
}
NSString *textContent(NSString *str){
    return [str isEqual:[NSNull null]]?@"":str;
}
- (void)initlizeBtnData:(AddAgendaViewController *)c{
    c.meetingIndex = _meetingList.meetingId;
    [SBJsonResolveData getPointMeetingOfGroupsWithIndex:c.meetingIndex];
    NSMutableArray *ar0 = [NSMutableArray array];

    for (NSDictionary *dic in [[SBJsonResolveData shareMeeting] pointMeetingGroups]) {
        NSMutableArray *ar1 = [NSMutableArray arrayWithObject:[dic objectForKey:DBFZName]];
        [ar0 addObject:ar1];
    }
    c.Participants.showDataArray = ar0;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    NSDictionary *dic = [_dataSource objectAtIndex:row];
    AddAgendaViewController *c = [[AddAgendaViewController alloc]initWithNibName:@"AddAgendaViewController" bundle:nil];
    c.delegate = self;
    [self.superViewController.navigationController pushViewController:c animated:YES];
    
    c.agendaIndex = row;
    c.agendaNameField.text = textContent([dic objectForKey:YCName]);
    c.agendaFZRField.text = textContent([dic objectForKey:YCFZR]);
    c.agendaContentField.text = textContent([dic objectForKey:YCContent]);
    c.agendaTelField.text = textContent([dic objectForKey:YCTel]);
    NSMutableString *start = [NSMutableString stringWithString:textContent([dic objectForKey:YCStartTime])];
    NSMutableString *end = [NSMutableString stringWithString:textContent([dic objectForKey:YCEndTime])];
    [start replaceCharactersInRange:[start rangeOfString:@"T"] withString:@" "];
    [end replaceCharactersInRange:[end rangeOfString:@"T"] withString:@" "];
    c.agendaStartDate.text = start;
    c.agendaEndDate.text = end;
    
    [self initlizeBtnData:c];
    
    NSString *s = [[[SBJsonResolveData shareMeeting] agenda][row] objectForKey:@"dbfzid"];
    s = [NSString stringWithFormat:@"%@",s];
    
    NSLog(@"%@,%@",s,[[SBJsonResolveData shareMeeting] pointMeetingGroups]);
    
    for (NSMutableDictionary *dic in [[SBJsonResolveData shareMeeting] pointMeetingGroups]) {
        NSString *idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:CHDBId]];

        if ([idStr isEqualToString:s]) {
            int index = [[[SBJsonResolveData shareMeeting] pointMeetingGroups] indexOfObject:dic];
            [c.Participants setTitle:[[[SBJsonResolveData shareMeeting] pointMeetingGroups][index] objectForKey:DBFZName] forState:UIControlStateNormal];
            c.Participants.meetingId = index;
            break;
        }
    }
    //    [c.Participants setTitle:[] forState:UIControlStateNormal];
//    self.meetingId = selectedIndex.row;

    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];

    //tableView 删除数据操作 同时上传服务器删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       BOOL scuess = [SBJsonResolveData deletePointMeetingOneAgendaWithHyIndex:_meetingList.meetingId AgendaIndex:row];
        if (scuess) {
            [_tableView reloadData];
        }else{
            [StaticManager showAlertWithTitle:nil message:@"删除议程失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
    
    }
}

@end

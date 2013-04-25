//
//  ModifyPointGroupViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-3.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "ModifyPointGroupViewController.h"
#import "OneMemberCell.h"
#import "SBJsonResolveData.h"
#import "StaticManager.h"
//#import "CYCustomMultiSelectPickerView.h"
#define TableHeader @"编号     姓名       职位            联系电话"
@interface ModifyPointGroupViewController (){
    CYCustomMultiSelectPickerView *multiPickerView;
}
@property (strong,nonatomic) NSMutableArray *membersData;
@end

@implementation ModifyPointGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(callBack)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMembers)];
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = back;
        self.navigationItem.rightBarButtonItem = add;
    }

    _tableView.dataSource = self;
    _tableView.delegate = self;

    [SBJsonResolveData GetPointMeetingGroupMemberWithIndex:self.groupIndex];
    
   _membersData = [[SBJsonResolveData shareMeeting] pointGroupMembers];
}
- (void)callBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//添加分组成员

- (void)addMembers{
    [SBJsonResolveData getMeetingMembers:self.meetingIndex];
    
    [self  getData];
}

-(void)getData
{
    //点击后删除之前的PickerView
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]]) {
            [view removeFromSuperview];
        }
    }
    
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 260-20, 320, 260+44)];
    multiPickerView.multiPickerDelegate = self;

    //  multiPickerView.backgroundColor = [UIColor redColor];
    
    NSMutableArray *a1 = [NSMutableArray array];
    NSMutableArray *a2 = [NSMutableArray array];
    NSLog(@"%@,%@",[[SBJsonResolveData shareMeeting] thisMeetingMembers],[[SBJsonResolveData shareMeeting] pointGroupMembers]);
    for (NSDictionary *dic in [[SBJsonResolveData shareMeeting] thisMeetingMembers]) {
        [a1 addObject:[NSDictionary dictionaryWithObject:[dic objectForKey:CHDBName] forKey:[dic objectForKey:CHDBId]]];
    }
    for (NSDictionary *dic in [[SBJsonResolveData shareMeeting] pointGroupMembers]) {
        [a2 addObject:[NSDictionary dictionaryWithObject:[dic objectForKey:CHDBName] forKey:[dic objectForKey:@"chdbid"]]];
    }
    NSLog(@"%@\n%@",a1,a2);
    
    multiPickerView.entriesArray = a1;
    multiPickerView.entriesSelectedArray = a2;
    
    [self.view addSubview:multiPickerView];
    
    [multiPickerView pickerShow];
    
}
#pragma mark Picker Delegate
- (void)returnChoosedPickerString:(NSMutableArray *)selectedEntriesArr{

    for (NSString *idStr in selectedEntriesArr) {
        NSLog(@"%@",idStr);
       BOOL allScuess = [SBJsonResolveData addPointMeetingGroupMemberWithMeetingIndex:_meetingIndex GroupIndex:_groupIndex MemberIndex:idStr];
        if (!allScuess) {
            [StaticManager showAlertWithTitle:nil message:@"添加分组成员失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
            break;
        }
    }
    
    [SBJsonResolveData GetPointMeetingGroupMemberWithIndex:self.groupIndex];
    
    [_tableView reloadData];
}

#pragma mark UITableView Delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        
    UIView *result = nil;
    
    if(section == 0){
        
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
    return _membersData.count;
}
- (void)setLabelText:(UILabel *)label withText:(NSString *)str{
    if ([str isEqual:[NSNull null]]) {
        str = @"";
    }
    label.text = str;
    label.textAlignment = UITextAlignmentCenter;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSDictionary *dic = [_membersData objectAtIndex:row];

    NSString *title = @"Member";
    
    OneMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = (OneMemberCell *)[[[NSBundle mainBundle] loadNibNamed:@"OneMemberCell" owner:self options:nil] objectAtIndex:0];

    }
//    NSLog(@"%@",[dic objectForKey:CHDBName]);
//    for (NSString *obj in dic) {
        [self setLabelText:cell.code withText:[dic objectForKey:CHDBCode]];
        [self setLabelText:cell.name withText:[dic objectForKey:CHDBName]];
        [self setLabelText:cell.post withText:[dic objectForKey:CHDBZw]];
        [self setLabelText:cell.tel withText:[dic objectForKey:CHDBLxdh]];

//    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    
    //tableView 删除数据操作 同时上传服务器删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       BOOL scuess = [SBJsonResolveData deletePointMeetingGroupMemberWithIndex:row];
        if (scuess) {
            [SBJsonResolveData GetPointMeetingGroupMemberWithIndex:_groupIndex];
            [_tableView reloadData];
        }else{
            [StaticManager showAlertWithTitle:nil message:@"删除分组成员失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

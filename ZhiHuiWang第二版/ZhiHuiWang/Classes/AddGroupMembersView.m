//
//  AddGroupMembersView.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-7.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "AddGroupMembersView.h"
#import "SBJsonResolveData.h"
#import "OneMemberCell.h"
#define TableHeader @"编号     名称    创建时间            备注"

@interface AddGroupMembersView(){
    
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation AddGroupMembersView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        
        
        
    }
    return self;
}
- (void)loadTableView{
    _dataSource = [[NSMutableArray alloc] init];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
    [self addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    _dataSource = [[SBJsonResolveData shareMeeting] thisMeetingMembers];
    
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
    NSUInteger row = [indexPath row];
    NSDictionary *dic = [_dataSource objectAtIndex:row];
    
    NSString *title = @"theMember";
    
    OneMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = (OneMemberCell *)[[[NSBundle mainBundle] loadNibNamed:@"OneMemberCell" owner:self options:nil] objectAtIndex:0];
        
    }
    for (NSString *obj in dic) {
        [self setLabelText:cell.code withText:[dic objectForKey:CHDBCode]];
        [self setLabelText:cell.name withText:[dic objectForKey:DBFZName]];
        [self setLabelText:cell.post withText:[dic objectForKey:@"chdbzw"]];
        [self setLabelText:cell.tel withText:[dic objectForKey:CHDBLxdh]];
        
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    
    //tableView 删除数据操作 同时上传服务器删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

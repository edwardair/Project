//
//  ModifyPointGroupViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-3.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "ModifyPointGroupViewController.h"
#import "OneMemberCell.h"
#define TableHeader @"编号     姓名      职位     联系电话"
@interface ModifyPointGroupViewController ()
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

    _membersData = [[NSMutableArray alloc]init];
    [_membersData addObject:@"001"];
    [_membersData addObject:@"王虎"];
    [_membersData addObject:@"老大"];
    [_membersData addObject:@"13800001598"];

}
- (void)callBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//添加分组成员

- (void)addMembers{
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"Member";
    
    OneMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = (OneMemberCell *)[[[NSBundle mainBundle] loadNibNamed:@"OneMemberCell" owner:self options:nil] objectAtIndex:0];
        cell.code.text = [_membersData objectAtIndex:0];
        cell.name.text = [_membersData objectAtIndex:1];
        cell.post.text = [_membersData objectAtIndex:2];
        cell.tel.text = [_membersData objectAtIndex:3];

    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *dic = [_membersData objectAtIndex:row];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

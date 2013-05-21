//
//  ConfigureController.m
//  cqhot
//
//  Created by ZL on 13-4-2.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "ConfigureController.h"
#import "InfoWebController.h"

@interface ConfigureController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *items;

@end

@implementation ConfigureController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dctInternal_setupInternals {
  self.items = @[@[@{@"title": @"掌上解放碑",@"id":@"-1",@"sub":@"版本Alpha 1.0.0",@"des":@"@重庆智佳科技有限公司"}],
  @[@{@"title":@"更多应用",@"id":@"0"}],
  @[@{@"title":@"新浪微博帐号",@"id":@"1"},@{@"title":@"腾讯微博帐号",@"id":@"2"}],
  @[@{@"title":@"关于我们",@"id":@"3"}]];
  
  NSLog(@"%@",[_items description]);
}

- (void)initializeViews {
  
  UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  tableView.delegate = self;
  tableView.dataSource = self;
  tableView.backgroundView = [[UIView alloc] initWithFrame:tableView.bounds];
  tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about_background.png"]];
  [self.view addSubview:tableView];
}

#pragma mark -
#pragma mark UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 90;
  }
  return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [_items count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [_items[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if(!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"indexPath"];
  }
  
  NSDictionary *dctTmp = [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  if (indexPath.section == 0) {
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = [dctTmp valueForKey:@"title"];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 30)];
    label.font = [UIFont systemFontOfSize:17];
    label.text = [dctTmp valueForKey:@"sub"];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 300, 30)];
    label.font = [UIFont systemFontOfSize:17];
    label.text = [dctTmp valueForKey:@"des"];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    return cell;
  }
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [dctTmp valueForKey:@"title"];
  
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == 1) {
    InfoWebController *ic = [[InfoWebController alloc] init];
    ic.title = @"更多应用";
    ic.webURL = [NSURL URLWithString:@"http://app.cqhot.com/wap.php"];
    [self.navigationController pushViewController:ic animated:YES];
  }
}
@end

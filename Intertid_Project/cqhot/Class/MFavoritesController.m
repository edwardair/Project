//
//  MFavoritesController.m
//  cqhot
//
//  Created by ZL on 13-4-2.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "MFavoritesController.h"
#import "EUOperation.h"
#import "HotCell.h"
#import "InfoCustomController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface MFavoritesController () <UITableViewDataSource,UITableViewDelegate>



@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation MFavoritesController

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


- (void)updateFavorites {

  EUOperation *op = [EUOperation defaultDatabase];
  [op open];
  NSArray *favorites = [op selectAllFromTable:@"DEFAULT_TABLE"];
  [op close];
  
  [_items removeAllObjects];
  
  for (int i = 0; i < [favorites count] ; i++) {
    NSDictionary *dctTmp = [favorites objectAtIndex:i];
    [_items addObject:[dctTmp[@"VALUE"] JSONValue]];
  }
  NSLog(@"%@",[_items description]);
  [_tableView reloadData];
  
}

- (void)viewWillAppear:(BOOL)animated {
//  NSLog(@"%@", [_items description]);
  [self updateFavorites];
}

- (void)dctInternal_setupInternals {

  self.items = [[NSMutableArray alloc] init];
  
}

- (void)initializeViews {
  
  self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.tableView.delegate   = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight  = 90;
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  [self.view addSubview:self.tableView];
}


#pragma mark -
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"cell";
  HotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"HotCell" owner:self options:nil] objectAtIndex:0];
  }
  NSDictionary *dctTmp  = _items[indexPath.row];
  cell.title.text       = dctTmp[@"name"];
  cell.markView.star    = 5;
  [cell.icon setImageWithURL:[NSURL URLWithString:dctTmp[@"pictureurl"]]];
  
  cell.detail.text = self.title;
  cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f公里",[_items[indexPath.row][@"distance"] integerValue]/1000.00];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSMutableDictionary *dctTmp    = [[NSMutableDictionary alloc] initWithDictionary:_items[indexPath.row]];
  
  InfoCustomController *ic = [[InfoCustomController alloc] init];
  [dctTmp setObject:self.title forKey:@"title"];
  ic.userInfo = dctTmp;
  
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [delegate.navigationController pushViewController:ic animated:YES];
  return;
  
}





@end

//
//  GuideController.m
//  cqhot
//
//  Created by ZL on 13-4-2.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "GuideController.h"
#import "EUFunc.h"

@interface GuideController ()<UITableViewDataSource,UITableViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *leftTable;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *rightTable;

@property (strong, nonatomic) NSMutableArray *guideLeft;
@property (strong, nonatomic) NSMutableArray *guideRight;

@end

@implementation GuideController

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

- (void)viewWillAppear:(BOOL)animated {
  NSLog(@"%@",NSStringFromCGRect(self.view.frame));
  NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
  NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].applicationFrame));
  NSLog(@"%@",NSStringFromCGRect(self.tabBarController.view.frame));
  NSLog(@"%@",NSStringFromCGRect(self.navigationController.view.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setLeftTable:nil];
  [self setRightTable:nil];
  [super viewDidUnload];
}

- (void)dctInternal_setupInternals {
  NSString *bundlePath  = [[NSBundle mainBundle] bundlePath];
  NSString *file        = [bundlePath stringByAppendingPathComponent:@"guide.plist"];
  NSDictionary *doc     = [NSDictionary dictionaryWithContentsOfFile:file];
  
  self.guideLeft = [doc valueForKey:@"guideLeft"];

}

- (void)initializeViews {
  _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  _rightTable.backgroundColor = [UIColor clearColor];
  [self updateRightTableViewWithLeftIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}


- (void)updateRightTableViewWithLeftIndexPath:(NSIndexPath *)indexPath {
  NSString *bundlePath  = [[NSBundle mainBundle] bundlePath];
  NSString *file        = [bundlePath stringByAppendingPathComponent:@"guide.plist"];
  NSDictionary *doc     = [NSDictionary dictionaryWithContentsOfFile:file];
  
//  [_leftTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  NSString *idRight = [[_guideLeft objectAtIndex:indexPath.row] valueForKey:@"id"];
  self.guideRight = nil;
  self.guideRight = [[doc valueForKey:@"guideRight"] valueForKey:idRight];
  [_rightTable reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if ([tableView isEqual:_leftTable]) {
    return [_guideLeft count];
  }
  return [_guideRight count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"indexPath"];
  }
  if ([tableView isEqual:_leftTable]) {
    
    UIView *selectedView          = [[UIView alloc] initWithFrame:cell.bounds];
    selectedView.backgroundColor  = [UIColor colorWithRGBString:@"233,233,233"];
    UIImageView *imgTmp           = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 44)];
    imgTmp.image                  = [UIImage imageNamed:@"item_root_focused_category.png"];
    
    [selectedView addSubview:imgTmp];
    
    cell.selectedBackgroundView = selectedView;
  
  
    cell.textLabel.text = [[_guideLeft objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    cell.imageView.image = [UIImage imageNamed:[[_guideLeft objectAtIndex:indexPath.row] valueForKey:@"icon"]];
  }else {
    
    cell.textLabel.text = _guideRight[indexPath.row];
    id guidr = _guideRight[indexPath.row];
    if ([guidr isKindOfClass:[NSString class]]) {
      cell.textLabel.text = guidr;
    }else {
      cell.textLabel.text = [guidr valueForKey:@"title"];
    }
//    NSLog(@"%@",_guideRight[indexPath.row]);
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    UIImage *image = [UIImage imageNamed:@"category_detail_text_background.9.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    imageView.frame = CGRectMake(0,0,155,44);
    [cell.contentView addSubview:imageView];
    [cell.contentView sendSubviewToBack:imageView];
    image = [UIImage imageNamed:@"item_blue.png"];
    imageView.highlightedImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
  
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([tableView isEqual:_leftTable]) {
    [self updateRightTableViewWithLeftIndexPath:indexPath];
  }else {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

  }
}
@end

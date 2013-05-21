//
//  IFTableController.m
//  cqhot
//
//  Created by ZL on 13-4-9.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "InfoTableController.h"
#import "MBProgressHUD.h"
#import "HotCell.h"
#import "UIImageView+WebCache.h"
#import "EUFunc.h"

#import "InfoCustomController.h"
#import "SVPullToRefresh.h"
#import "CategoryView.h"
#import "LBSManager.h"


#import <QuartzCore/QuartzCore.h>

#define PI 3.1415926

static double LantitudeLongitudeDist(double lon1,double lat1,
                              double lon2,double lat2)
{
	double er = 6378137; // 6378700.0f;
	//ave. radius = 6371.315 (someone said more accurate is 6366.707)
	//equatorial radius = 6378.388
	//nautical mile = 1.15078
	double radlat1 = PI*lat1/180.0f;
	double radlat2 = PI*lat2/180.0f;
  
	//now long.
	double radlong1 = PI*lon1/180.0f;
	double radlong2 = PI*lon2/180.0f;
  
	if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
	if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
	if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
  
	if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
	if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
	if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
  
	//spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
	//zero ag is up so reverse lat
	double x1 = er * cos(radlong1) * sin(radlat1);
	double y1 = er * sin(radlong1) * sin(radlat1);
	double z1 = er * cos(radlat1);
  
	double x2 = er * cos(radlong2) * sin(radlat2);
	double y2 = er * sin(radlong2) * sin(radlat2);
	double z2 = er * cos(radlat2);
  
	double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
  
	//side, side, side, law of cosines and arccos
	double theta = acos((er*er+er*er-d*d)/(2*er*er));
	double dist  = theta*er;
  
	return dist;
}


@interface InfoTableController ()<UITableViewDataSource,UITableViewDelegate,CategoryViewDelegate,CLLocationManagerDelegate>


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) CategoryView *categoryView;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@end

@implementation InfoTableController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
  self.tableView = nil;
  self.items = nil;
  self.tableView.showsInfiniteScrolling = NO;
  self.tableView.showsPullToRefresh     = NO;
  NSArray *ges = [self.view gestureRecognizers];
  for (UIGestureRecognizer *gesture in ges) {
    [self.view removeGestureRecognizer:gesture];
  }

}

- (UIBarButtonItem *)leftItem {
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bar_divider.png"]];
  imageView.frame        = CGRectMake(44, 1, 1, 42);
  UIButton *btn          = [UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame              = CGRectMake(0, 0, 44, 44);
  UIView *view           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
  
  [view addSubview:imageView];
  [view addSubview:btn];
  __autoreleasing UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
  
  [btn setFrame:CGRectMake(0, 0, 44, 44)];
  [btn setImage:[UIImage imageNamed:@"action_bar_glyph_back.png"] forState:UIControlStateNormal];
  [btn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
  
  view = nil;
  imageView = nil;
  
  return item;
}

- (UIBarButtonItem *)rightItem {
  
  UIImageView *imageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bar_divider.png"]];
  imageView.frame         = CGRectMake(0, 1, 1, 42);
  UIButton *btn           = [UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame               = CGRectMake(2, 0, 44, 44);
  UIView *view            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
  
  [view addSubview:imageView];
  [view addSubview:btn];
  
  __autoreleasing UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
  
  [btn setImage:[UIImage imageNamed:@"action_bar_glyph_more.png"] forState:UIControlStateNormal];
  [btn addTarget:self action:@selector(clickBar) forControlEvents:UIControlEventTouchUpInside];
  view = nil;
  imageView = nil;
  return item;
}

- (void)backTo {
  [self.navigationController popViewControllerAnimated:YES];
}

/**
	条件：URL中page参数放在最后可取得当前的page
	@returns 当前在第几页
 */
- (NSInteger)currentPage
 {
  NSArray *coms = [_URL.absoluteString componentsSeparatedByString:@"&"];
  NSInteger page = 0;
  for (NSString *string in coms) {
    if ([string hasPrefix:@"page"]) {
      page = [[[string componentsSeparatedByString:@"="] lastObject] integerValue];
      break;
    }
  }
  return page;
}


- (void)infinitePage {
  
  if (_integerType == 1) {
    NSString *url         = [NSString stringWithFormat:@"http://cq.cqhot.com/store/prclass.php?fatherclassid=%@&page=%d",
                             self.userInfo[@"id"],[self currentPage] + 1];
    self.URL              = [NSURL URLWithString:url];
    self.request          = [EURequest requestWithURL:_URL userCache:NO];
    self.request.delegate = self;
    self.request.userInfo = @{@"type": @"infinite"};
    [self.request startAsynchronous];
    return;
  }
  
  CLLocationCoordinate2D coor = [[LBSManager sharedManager] coor];
  NSString *url               = [NSString stringWithFormat:@"http://cq.cqhot.com/store/storelist.php?childclassid=%@&sort=location&mylo=%f&myla=%f&page=%d",
                                 self.userInfo[@"id"],coor.longitude,coor.latitude,[self currentPage] + 1];
  self.URL                    = [NSURL URLWithString:url];
  
  self.request                = [EURequest requestWithURL:_URL userCache:NO];
  self.request.delegate       = self;
  self.request.userInfo       = @{@"type": @"infinite"};
  [self.request startAsynchronous];
}

- (void)refreshPage {
  if (_integerType == 1) {
    NSString *url         = [NSString stringWithFormat:@"http://cq.cqhot.com/store/prclass.php?fatherclassid=%@&page=%d",self.userInfo[@"id"],0];
    self.URL              = [NSURL URLWithString:url];
    self.request          = [EURequest requestWithURL:_URL userCache:NO];
    self.request.delegate = self;
    [self.request startAsynchronous];
    return;
    
  }
  if (_integerType == 2) {
    CLLocationCoordinate2D coor = [[LBSManager sharedManager] coor];
    NSString *url               = [NSString stringWithFormat:@"http://cq.cqhot.com/store/storelist.php?childclassid=%@&sort=location&mylo=%f&myla=%f&page=%d",
                                   self.userInfo[@"id"],coor.longitude,coor.latitude,0];
    self.URL                    = [NSURL URLWithString:url];
    self.request                = [EURequest requestWithURL:_URL userCache:NO];
    self.request.delegate       = self;
    [self.request startAsynchronous];
  }

}

- (void)dctInternal_setupInternals {
  self.navigationItem.leftBarButtonItem = [self leftItem];

 
}


- (void)clickTap {
  [self showLeft];
}


- (void)initializeViews {
  
  self.tableView                  = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.tableView.delegate         = self;
  self.tableView.dataSource       = self;
  self.tableView.rowHeight        = 90;
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  
  [self.view addSubview:self.tableView];
  
  [self configurePullToRefresh];

  [self initializeHoderData];
  [[self tableView] triggerPullToRefresh];
  
  self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
  [self.tableView addGestureRecognizer:_tap];
  _tap.enabled = NO;
  


  if (_integerType == 2 && self.category != nil) {
    self.navigationItem.rightBarButtonItem = [self rightItem];
    
    CategoryView *view                  = [[[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil] objectAtIndex:0];
    self.categoryView                   = view;
    self.categoryView.frame             = CGRectMake(160, 0, 160, self.view.bounds.size.height);
    self.categoryView.autoresizingMask  = UIViewAutoresizingFlexibleHeight;
    self.categoryView.items             = self.category;
    self.categoryView.sectionTitle      = self.categoryTitle;
    self.categoryView.delegate          = self;
    [self.categoryView.tableView reloadData];
    
    [self.view addSubview:self.categoryView];
    [self.view sendSubviewToBack:self.categoryView];
  
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.direction                 = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
    swipe = nil;
    
    swipe           = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    swipe = nil;

    
  }

}

- (void)clickBar {
  if (self.tableView.frame.origin.x < 0) {
    [self showLeft];
  }else {
    [self showRight];
  }

}

- (void)swipe:(UISwipeGestureRecognizer *)gesture {
  if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
    [self showLeft];
  }else {
    [self showRight];
  }
}

- (void)showLeft {
  self.tap.enabled = NO;
//  self.tableView.scrollEnabled = YES;
//  [self.tableView ad];
//  self.tableView.scrollEnabled = YES;
//  self.tableView.sec
  self.tableView.userInteractionEnabled = YES;
//  [[[self.tableView subviews] lastObject] removeFromSuperview];
  [UIView animateWithDuration:.3 animations:^{
    CGRect frame          = self.tableView.frame;
    frame.origin.x        = 0;
    self.tableView.frame  = frame;
  }];

}

- (void)showRight {
  self.tap.enabled = YES;
//  self.tableView.scrollEnabled = NO;
  self.tableView.userInteractionEnabled = NO;
//  UIView *view  = [[UIView alloc] initWithFrame:self.tableView.bounds];
//  view.backgroundColor = [UIColor blackColor];
//  view.alpha = .3;
//  [self.tableView addSubview:view];
  [UIView animateWithDuration:.3 animations:^{
    CGRect frame          = self.tableView.frame;
    frame.origin.x        = -160;
    self.tableView.frame  = frame;
  }];
}

#pragma mark -
#pragma mark SVPullToRefresh
- (void)configurePullToRefresh {

  __weak InfoTableController *weakSelf = self;
  
  [self.tableView addPullToRefreshWithActionHandler:^{
    weakSelf.tableView.showsInfiniteScrolling = NO;
    [weakSelf refreshPage];
  }];
  
  if (_integerType == 2) {
    [self.tableView addInfiniteScrollingWithActionHandler:^{
      [weakSelf infinitePage];
    }];
  }
 

  [self.tableView.pullToRefreshView setTitle:@"释放立即加载..." forState:SVPullToRefreshStateTriggered];
  [self.tableView.pullToRefreshView setTitle:@"下拉可以刷新..." forState:SVPullToRefreshStateStopped];
  [self.tableView.pullToRefreshView setTitle:@"正在更新位置信息..." forState:SVPullToRefreshStateLoading];
  
  UILabel *label        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  label.textAlignment   = UITextAlignmentCenter;
  label.textColor       = [UIColor darkGrayColor];
  label.font            = [UIFont boldSystemFontOfSize:14];
  label.backgroundColor = [UIColor clearColor];
  UIView *view          = [[UIView alloc] initWithFrame:label.bounds];
  [view addSubview:label];
  
  label.text = @"正在载入...";
  UIActivityIndicatorView *aic  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  aic.frame                     = CGRectMake(100, 22, 0, 0);
  
  [aic startAnimating];
  [view addSubview:aic];
  
  [self.tableView.infiniteScrollingView setCustomView:view forState:SVPullToRefreshStateLoading];
  

}

- (void)stopRefresh {
  if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
    [self.tableView.pullToRefreshView stopAnimating];
  }
  
  if (self.tableView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
    [self.tableView.infiniteScrollingView stopAnimating];
  }
  
  self.tableView.showsInfiniteScrolling = YES;
}

- (void)initializeHoderData {
  NSString *responseString = [EURequest stringForURL:self.URL];
  if (responseString) {
    NSDictionary *json  = [[responseString stringByRemovingControlCharacters] JSONValue];
    self.items          = [json valueForKey:@"data"];
    [self.tableView reloadData];
  }
  
}

#pragma mark -
#pragma mark EURequestDelegate

- (void)requestStarted:(EURequest *)request {

}

- (void)requestFinished:(EURequest *)request {
  
  [self stopRefresh];
  if (request.responseString == nil) {
    return;
  }
  NSDictionary *json = [[request.responseString stringByRemovingControlCharacters] JSONValue];
  
  if ([[request.userInfo valueForKey:@"type"] isEqualToString:@"infinite"]) {
    [self.items addObjectsFromArray:[json valueForKey:@"data"]];
    [self.tableView reloadData];
    return;
  }
  self.items = [json valueForKey:@"data"];
  [self.tableView reloadData];
}

- (void)requestFailed:(EURequest *)request {
  [self stopRefresh];
  
	MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	hud.mode            = MBProgressHUDModeText;
	hud.labelText       = @"数据加在失败";
	hud.margin          = 10.f;
	hud.yOffset         = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1];

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
  
  if (self.integerType == 2 ){
    cell.detail.text = self.title;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f公里",[_items[indexPath.row][@"distance"] integerValue]/1000.00];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSMutableDictionary *dctTmp    = [[NSMutableDictionary alloc] initWithDictionary:_items[indexPath.row]];
  
  if (_integerType == 1) {
    
    CLLocationCoordinate2D coor = [[LBSManager sharedManager] coor];
    
    
    NSString *url           = [NSString stringWithFormat:
                               @"http://cq.cqhot.com/store/storelist.php?childclassid=%@&sort=location&mylo=%f&myla=%f&page=0",
                               dctTmp[@"id"],coor.longitude,coor.latitude];
    InfoTableController *it = [[InfoTableController alloc] init];
    it.title                = dctTmp[@"name"];
    it.URL                  = [NSURL URLWithString:url];
    it.integerType          = 2;
    it.userInfo             = @{@"id": dctTmp[@"id"]};
    it.category             = self.items;
    it.categoryTitle        = self.title;
    [self.navigationController pushViewController:it animated:YES];
    dctTmp = nil;
    return;
  }
  
  if (_integerType == 2) {
    InfoCustomController *ic = [[InfoCustomController alloc] init];
    [dctTmp setObject:self.title forKey:@"title"];
    ic.userInfo = dctTmp;
    [self.navigationController pushViewController:ic animated:YES];
    dctTmp = nil;
    return;
  }

}

#pragma CategoryViewDelegate

- (void)updateContentTableView {
  [self.tableView triggerPullToRefresh];
}

- (void)categoryDidSelectedIndexPath:(NSIndexPath *)indexPath {
  
  NSDictionary *dctTmp        = [self.categoryView.items objectAtIndex:indexPath.row];
  CLLocationCoordinate2D coor = [[LBSManager sharedManager] coor];
  NSString *url               = [NSString stringWithFormat:
                                 @"http://cq.cqhot.com/store/storelist.php?childclassid=%@&sort=location&mylo=%f&myla=%f&page=0",
                                 dctTmp[@"id"],coor.longitude,coor.latitude];
  
  self.URL      = [NSURL URLWithString:url];
  self.userInfo = @{@"id": dctTmp[@"id"]};
  self.title    = dctTmp[@"name"];
  
//  [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:NO];
  if ([_items count] > 0) {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
  }
  
  [self initializeHoderData];
  [self.tableView triggerPullToRefresh];
  [self showLeft];
}



@end

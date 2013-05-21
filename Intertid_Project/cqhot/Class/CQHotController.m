//
//  CQHotController.m
//  cqhot
//
//  Created by ZL on 13-4-2.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "CQHotController.h"
#import "MenuView.h"
#import "MarqueeLabel.h"

#import "InfoWebController.h"
#import "InfoTableController.h"

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "MBProgressHUD.h"
#import "EUKitCompat.h"
#import "LBSManager.h"

#import "GridView.h"
#import "AutoScrollLabel.h"



@interface CQHotController ()<UIScrollViewDelegate,GridViewDelegate>{
    NSInteger cqhotindex;
    AutoScrollLabel *autoScrollLabel;
}

/**
 * 滚动的页视图
 */
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;

/**
 * 滚动的文字视图
 */
@property (strong, nonatomic) IBOutlet UIView *sTitleView;

/**
 所有的标题
 */
@property (strong, nonatomic) NSArray *keys;

@property (strong, nonatomic) NSArray *srollerKeys;
@property (strong, nonatomic) NSDictionary *document;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


@property (strong, nonatomic) MarqueeLabel *marqueeLabel;

@end

@implementation CQHotController

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
    [autoScrollLabel scroll];
    //  [self resetMarqueeLabel];
    //  [self.marqueeLabel pauseLabel];
    //  [self.marqueeLabel unpauseLabel];
    //  [self.marqueeLabel restartLabel];
    //   [(MarqueeLabel *)[[_sTitleView subviews] objectAtIndex:0] restartLabel];
    //  [self contentToUpdate:self.pageControl.currentPage];
    //  [self.marqueeLabel resetLabel];
    //  [self.marqueeLabel restartLabel];
    //  [self resetMarqueeLabel];
    //  [self.marqueeLabel unpauseLabel];
    //   [MarqueeLabel controllerViewAppearing:self];
    //  [self resetMarqueeLabel];
    //  [self reset];
    //  [MarqueeLabel controllerLabelsShouldAnimate:self];
    //  [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [self.marqueeLabel restartLabel];
    //
    //  self.marqueeLabel.text = @"";
    //
    //  self.marqueeLabel.text = @"您距离重庆市中心“解放碑”2.4公里，点击“掌上解放碑”，立即向您推荐前往“解放碑”的导航路线。       ";
    //  if (self.marqueeLabel.isPaused) {
    //    [self.marqueeLabel unpauseLabel];
    //  }
    //
    //  if (_marqueeLabel != nil) {
    //    [MarqueeLabel controllerLabelsShouldAnimate:self];
    //    [MarqueeLabel controllerLabelsShouldLabelize:self];
    //    [MarqueeLabel controllerViewAppearing:self];
    //
    //    [self.marqueeLabel resetLabel];
    //    [self.marqueeLabel restartLabel];
    //  }
    
    NSLog(@"viewWillAppear");
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    //  [self.marqueeLabel pauseLabel];
    NSLog(@"viewWillDisappear");
    //  [(MarqueeLabel *)[[_sTitleView subviews] objectAtIndex:0] resetLabel];
    //   [MarqueeLabel controllerViewAppearing:self];
    //  [self.marqueeLabel removeFromSuperview];
    //  self.marqueeLabel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScroller:nil];
    [self setSTitleView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UIScrollView

- (void)dctInternal_setupInternals {
    NSString *bundlePath  = [[NSBundle mainBundle] bundlePath];
    NSString *file        = [bundlePath stringByAppendingPathComponent:@"hots.plist"];
    NSDictionary *doc     = [NSDictionary dictionaryWithContentsOfFile:file];
    
    NSArray *keys = [NSArray arrayWithObjects:@"首页",@"玩转重庆",@"生活服务",@"时尚网购",@"周边导航",@"重庆团购",@"重庆健康",@"教育培训",@"智能交通",@"智能生活",@"政务云",@"商务云",@"解放碑社区",@"应用商店", nil];//@"人在职场",@"智佳服务",
    self.keys     = keys;
    self.document = doc;
#pragma mark scrollerKeys 代表pageView翻页后nav显示的标题
    self.srollerKeys = @[@"首页",@"玩转重庆",@"生活服务",@"时尚网购",@"重庆健康",@"教育培训",@"智能交通",];//@"人在职场",@"智佳服务",
}


- (void)resetMarqueeLabel {
    autoScrollLabel = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(5,3, self.view.bounds.size.width - 10, 20)];
    //TODO: 此处原程序为写死内容，之后需要修改
    autoScrollLabel.text = @"距离无锡市中心10公里距离无锡市中心10公里距离无锡市中心10公里距离无锡市中心10公里距离无锡市中心10公里 ";
    autoScrollLabel.textColor = [UIColor lightGrayColor];
    autoScrollLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.00];
    [_sTitleView addSubview:autoScrollLabel];
}

- (void)initializeViews {
    [self resetMarqueeLabel];
    
    [[_scroller subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect bounds = _scroller.bounds;
    if (RETINA_4_INCH) {
        bounds.size.height += 88;
    }
    
    CGSize size   = bounds.size;
    [_scroller setPagingEnabled:YES];
    [_scroller setContentSize:CGSizeMake(size.width * ([_keys count] - 7), size.height)];
    
    NSMutableArray *itemTmps = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_keys count]; i++) {
        NSArray *items  = [_document valueForKey:[_keys objectAtIndex:i]];
        if ([items count] >  2){
            [itemTmps addObject:items];
        }
        
    }
    
    BOOL inch4  = RETINA_4_INCH;
    for (int i = 0; i < [itemTmps count]; i++) {
        NSArray *itemsPage  = [itemTmps objectAtIndex:i];
        NSInteger base      = i * 320;
        for (int j = 0;j < [itemsPage count];j++ ) {
            NSDictionary *dctTmp      = [itemsPage objectAtIndex:j];
            NSArray *bundles          = [[NSBundle mainBundle] loadNibNamed:@"GridView" owner:self options:nil];
            GridView *gridView        = inch4?bundles[1]:bundles[0];
            
            gridView.titleLabel.text  = dctTmp[@"title"];
            gridView.imageView.image  = [UIImage imageNamed:dctTmp[@"icon"]];
            gridView.userInfo         = dctTmp;
            gridView.delegate         = self;
            
            CGRect frame = CGRectMake(0, 0, 80, 80);
            int index    = j / 4;
            int row      = j % 4;
            
            frame.origin.x = 80 * row + base ;
            frame.origin.y = inch4?100*index + 10:80 * index + 10;
            
            frame.size.height = inch4?100:80;
            if (i > 0) {
                frame.origin.y += inch4?100:80;
            }
            
            gridView.frame = frame;
            gridView.tag = i*100+j;
            
            [_scroller addSubview:gridView];
            gridView = nil;
        }
    }
    
    self.pageControl.currentPage    = 0;
    self.pageControl.numberOfPages  = [_keys count] - 7;
    
}


- (UIBarButtonItem *)leftItem {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bar_divider.png"]];
    imageView.frame = CGRectMake(44, 1, 1, 42);
    
    
    //action_bar_glyph_location.png
    UIButton *btn         = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    [view addSubview:imageView];
    [view addSubview:btn];
    __autoreleasing UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"action_bar_glyph_back.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    view = nil;
    imageView = nil;
    
    return item;
}

- (void)reset {
    [_scroller setContentOffset:CGPointMake(0, 0) animated:NO];
    [self contentToUpdate:0];
}

- (void)contentToUpdate:(NSInteger)index {
    self.pageControl.currentPage      = index;
    TabBarViewController *tab         = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tabBarController];
    UINavigationItem *navigationItem  = tab.navigationItem;
    navigationItem.title              = [_srollerKeys objectAtIndex:index];
    if (index !=0) {
        navigationItem.leftBarButtonItem = [self leftItem];
    }else {
        navigationItem.leftBarButtonItem = nil;
    }
}


- (EUNavigationController *)navigationController{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //  [(MarqueeLabel *)[[_sTitleView subviews] objectAtIndex:0] pauseLabel];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int currentPage   = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self contentToUpdate:currentPage];
    
    //   [(MarqueeLabel *)[[_sTitleView subviews] objectAtIndex:0] unpauseLabel];
}

#pragma mark -
#pragma mark NAMenuViewDelegate


- (NSURL *)URLWithFID:(NSString *)fid {
    NSString *str = [NSString stringWithFormat:@"http://cq.cqhot.com/store/prclass.php?fatherclassid=%@&page=0",fid];
    return [NSURL URLWithString:str];
}
- (NSURL *)URLWithCID:(NSString *)cid {
    CLLocationCoordinate2D coor = [[LBSManager sharedManager] coor];
    NSString *str = [NSString stringWithFormat:@"http://cq.cqhot.com/store/storelist.php?childclassid=%@&sort=location&mylo=%f&myla=%f&page=0",cid,coor.longitude,coor.latitude];
    return [NSURL URLWithString:str];
}


- (void)touchGridView:(GridView *)gridView {
    NSDictionary *userinfo = gridView.userInfo;
    NSLog(@"userinfo %@",[userinfo description]);
    
    NSInteger cat = [[userinfo valueForKey:@"category"] integerValue];
    
    // MARK:Category description
    /**
     0 未开通
     1 跳屏
     2 网页
     3 有超类的连接 如http://cq.cqhot.com/store/prclass.php?fatherclassid=1&page=0
     4 无超类的连接 如http://cq.cqhot.com/store/storelist.php?childclassid=64&sort=location&mylo=106.559378&myla=29.560166&page=0
     
     5.特殊处理
     */
    
    if (cat == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂未开通";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:.7];
        return;
    }
    if (cat == 1) {
        NSInteger index = gridView.tag %100;
        NSString *key   = _keys[index];
        NSInteger tmp   = [_srollerKeys indexOfObject:key];
        CGFloat offset  = _scroller.bounds.size.width * tmp;
        [_scroller setContentOffset:CGPointMake(offset, 0) animated:YES];
        [self contentToUpdate:tmp];
        return;
    }
    if (cat == 2) {
        InfoWebController *ic = [[InfoWebController alloc] init];
        ic.title = userinfo[@"title"];
        ic.webURL = [NSURL URLWithString:userinfo[@"url"]];
        [self.navigationController pushViewController:ic animated:YES];
        return;
    }
    if (cat == 3) {
        InfoTableController *it = [[InfoTableController alloc] init];
        it.title                = userinfo[@"title"];
        it.URL                  =  [self URLWithFID:userinfo[@"id"]];
        it.integerType          =  1;
        it.userInfo             = @{@"id": userinfo[@"id"]};
        [self.navigationController pushViewController:it animated:YES];
        return;
    }
    if (cat == 4) {
        InfoTableController *it = [[InfoTableController alloc] init];
        it.title                = userinfo[@"title"];
        it.URL                  = [self URLWithCID:userinfo[@"id"]];
        it.integerType          = 2;
        it.userInfo             = @{@"id": userinfo[@"id"]};
        it.category             = nil;
        it.categoryTitle        = self.title;
        [self.navigationController pushViewController:it animated:YES];
    }
    
    if (cat == 5) {
        
        return;
    }
    
}
- (void)menuView:(NAMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"%d %d",menuView.tag, index);
    
    NAMenuItem *item = [(MenuView *)menuView objectForIndex:index];
    NSDictionary *userinfo = item.userinfo;
    
    NSInteger cat = [[userinfo valueForKey:@"category"] integerValue];
    
    // MARK:Category description
    /**
     0 未开通
     1 跳屏
     2 网页
     3 有超类的连接 如http://cq.cqhot.com/store/prclass.php?fatherclassid=1&page=0
     4 无超类的连接 如http://cq.cqhot.com/store/storelist.php?childclassid=64&sort=location&mylo=106.559378&myla=29.560166&page=0
     
     5.特殊处理
     */
    
    if (cat == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂未开通";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:.7];
        return;
    }
    if (cat == 1) {
        NSString *key   = _keys[index];
        NSInteger tmp   = [_srollerKeys indexOfObject:key];
        CGFloat offset  = _scroller.bounds.size.width * tmp;
        [_scroller setContentOffset:CGPointMake(offset, 0) animated:YES];
        [self contentToUpdate:tmp];
        return;
    }
    if (cat == 2) {
        InfoWebController *ic = [[InfoWebController alloc] init];
        ic.title = userinfo[@"title"];
        ic.webURL = [NSURL URLWithString:userinfo[@"url"]];
        [self.navigationController pushViewController:ic animated:YES];
        return;
    }
    if (cat == 3) {
        InfoTableController *it = [[InfoTableController alloc] init];
        it.title                = userinfo[@"title"];
        it.URL                  =  [self URLWithFID:userinfo[@"id"]];
        it.integerType          =  1;
        it.userInfo             = @{@"id": userinfo[@"id"]};
        [self.navigationController pushViewController:it animated:YES];
        return;
    }
    if (cat == 4) {
        InfoTableController *it = [[InfoTableController alloc] init];
        it.title                = userinfo[@"title"];
        it.URL                  = [self URLWithCID:userinfo[@"id"]];
        it.integerType          = 2;
        it.userInfo             = @{@"id": userinfo[@"id"]};
        it.category             = nil;
        it.categoryTitle        = self.title;
        [self.navigationController pushViewController:it animated:YES];
    }
    
    if (cat == 5) {
        
        return;
    }
    
    
    
    
    //  NSLog(@"%@",item.userinfo);
    
    // MARK:第一页
    if (menuView.tag ==0 && index == 0) {
        // TODO:重庆hot
        InfoWebController *ic = [[InfoWebController alloc] init];
        ic.title = @"重庆HOT+";
        ic.webURL = [NSURL URLWithString:@"http://cq.cqhot.com"];
        [self.navigationController pushViewController:ic animated:YES];
        return;
    }
    if (menuView.tag ==0 && index == 5) {
        // TODO:重庆团购
        InfoWebController *ic = [[InfoWebController alloc] init];
        ic.title = @"重庆团购";
        ic.webURL = [NSURL URLWithString:@"http://tuan.cqhot.com/mobi"];
        [self.navigationController pushViewController:ic animated:YES];
        return;
    }
    if (menuView.tag ==0 && index == 14) {
        // TODO:应用商店
        InfoWebController *ic = [[InfoWebController alloc] init];
        ic.title = @"应用商店";
        ic.webURL = [NSURL URLWithString:@"http://app.cqhot.com/wap.php"];
        [self.navigationController pushViewController:ic animated:YES];
        return;
    }
    if (menuView.tag == 0 && index == 4) {
        // TODO: 周边导航
        self.tabBarController.selectedIndex = 1;
        TabBarViewController *tc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tabBarController];
        [tc.tbBar setTabIndex:1];
        return;
    }
    if (menuView.tag ==0 && (index == 9 || index == 11)) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂未开通";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;
    }
    
    if (menuView.tag ==0 && index == 13) {
        // TODO:解放碑社区
        InfoWebController *ic = [[InfoWebController alloc] init];
        ic.title = @"解放碑社区";
        ic.webURL = [NSURL URLWithString:@"http://mt.cqhot.com"];
        [self.navigationController pushViewController:ic animated:YES];
        return;
    }
    if (menuView.tag == 0 && index == 10) {
        // TODO:政务云
        InfoTableController *it = [[InfoTableController alloc] init];
        it.title                = @"政务云";
        it.URL                  = [NSURL URLWithString:
                                   @"http://cq.cqhot.com/store/prclass.php?fatherclassid=197&page=0"];
        it.integerType          =  1;
        it.userInfo             = @{@"id": @"197"};
        [self.navigationController pushViewController:it animated:YES];
        return;
    }
    
    if (menuView.tag == 0) {
        NSString *key = _keys[index];
        NSInteger tmp = [_srollerKeys indexOfObject:key];
        CGFloat offset = _scroller.bounds.size.width * tmp;
        [_scroller setContentOffset:CGPointMake(offset, 0) animated:YES];
        [self contentToUpdate:tmp];
        
    }
    
    // MARK:第二页
    if (menuView.tag == 1 && index == 0) {
        // TODO:美食
        InfoTableController *it = [[InfoTableController alloc] init];
        it.title                = @"美食";
        it.URL                  = [NSURL URLWithString:
                                   @"http://cq.cqhot.com/store/prclass.php?fatherclassid=1&page=0"];
        it.integerType          =  1;
        it.userInfo             = @{@"id": @"1"};
        [self.navigationController pushViewController:it animated:YES];
    }
    
    
}

@end

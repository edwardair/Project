//
//  RootViewController.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "RootViewController.h"
#import "CommonMethod.h"

#import "HomePageViewController.h"
#import "MeetingInforationViewController.h"
#import "SupplierInformationViewController.h"
#import "MemberCenterViewController.h"
#import "ClientServeViewController.h"

#import "MemberMenuClickCell.h"
#import "DragScrollView.h"

@interface RootViewController (){
        

}
@property (strong,nonatomic) HomePageViewController *homePageViewController;
@property (strong,nonatomic) MeetingInforationViewController *meetingInformationViewController;
@property (strong,nonatomic) SupplierInformationViewController *supplierInformationViewController;
@property (strong,nonatomic) MemberCenterViewController *memberCenterViewController;
@property (strong,nonatomic) ClientServeViewController *clientServeViewController;

@property (strong,nonatomic) UITabBarController *rootTabBarController;
@property (strong,nonatomic) UINavigationController *rootNavigationController;
@property (strong,nonatomic) DragScrollView *rootScrollView;
@property (strong,nonatomic) UITapGestureRecognizer *rootTapGesture;

@property (strong,nonatomic) UITableView *memberCenterMenu;
@property (strong,nonatomic) NSMutableDictionary *menuDataSource;
@end

@implementation RootViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter

#pragma mark image像素大小必须是30*30的PNG图片
- (HomePageViewController *)homePageViewController{
    if (!_homePageViewController) {
        _homePageViewController =
        [[HomePageViewController alloc]initWithNibName:@"HomePageViewController"
                                                                          bundle:nil];
        _homePageViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页"
                                                                          image:nil
                                                                            tag:0];
        _homePageViewController.parentViewController.navigationItem.title = @"首页";

    }
    return _homePageViewController;
}
- (MeetingInforationViewController *)meetingInformationViewController{
    if (!_meetingInformationViewController) {
        _meetingInformationViewController =
        [[MeetingInforationViewController alloc]initWithNibName:@"MeetingInforationViewController"
                                                         bundle:nil];
        _meetingInformationViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"会议信息"
                                                                                    image:nil
                                                                                      tag:1];
    }
    return _meetingInformationViewController;
}
- (SupplierInformationViewController *)supplierInformationViewController{
    if (!_supplierInformationViewController) {
        _supplierInformationViewController =
        [[SupplierInformationViewController alloc]initWithNibName:@"SupplierInformationViewController"
                                                           bundle:nil];
        _supplierInformationViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"供应商信息"
                                                                                     image:nil
                                                                                       tag:2];
    }
    return _supplierInformationViewController;
}
- (MemberCenterViewController *)memberCenterViewController{
    if (!_memberCenterViewController) {
        _memberCenterViewController =
        [[MemberCenterViewController alloc]initWithNibName:@"MemberCenterViewController"
                                                    bundle:nil];
        _memberCenterViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"会员中心"
                                                                              image:nil
                                                                                tag:3];
    }
    return _memberCenterViewController;
}

- (ClientServeViewController *)clientServeViewController{
    if (!_clientServeViewController) {
        _clientServeViewController =
        [[ClientServeViewController alloc]initWithNibName:@"ClientServeViewController"
                                                   bundle:nil];
        _clientServeViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"客户服务"
                                                                             image:nil
                                                                               tag:4];
    }
    return _clientServeViewController;
}
- (UITabBarController *)rootTabBarController{
    if (!_rootTabBarController) {
        _rootTabBarController = [[UITabBarController alloc]init];
        _rootTabBarController.delegate = self;
        [_rootTabBarController setViewControllers:@[
         self.homePageViewController,
         self.meetingInformationViewController,
         self.supplierInformationViewController,
         self.memberCenterViewController,
         self.clientServeViewController]];
        

    }
    return _rootTabBarController;
}

- (UINavigationController *)rootNavigationController{
    if (!_rootNavigationController) {
        _rootNavigationController = [[UINavigationController alloc]initWithRootViewController:self.rootTabBarController];
        _rootNavigationController.view.frame = CGRectMake(0, 0, applicationFrame().size.width, applicationFrame().size.height);
        
        [self addGettureForMemberCenter];
    }
    return _rootNavigationController;
}
//会员中心 添加点击手势
- (void)addGettureForMemberCenter{
    _rootTapGesture = [[UITapGestureRecognizer alloc]init];
    [_rootNavigationController.view addGestureRecognizer:_rootTapGesture];
    [_rootTapGesture addTarget:self action:@selector(tap)];
    _rootTapGesture.delaysTouchesBegan = YES;
    _rootTapGesture.enabled = NO;
}


- (NSMutableDictionary *)menuDataSource{
    if (!_menuDataSource) {
        _menuDataSource = [[NSMutableDictionary alloc]initWithCapacity:4];
        
        NSArray *a1 = @[@"基本信息",@"我的账户",@"我的收藏",@"标签寻友",@"下载中心"];
        NSArray *a2 = @[@"我的发起",@"会议通知",@"批复申请",@"首页推荐"];
        NSArray *a3 = @[@"我的商品",@"首页展示"];
        NSArray *a4 = @[@"我的申请",@"我的参加"];

        [_menuDataSource setObject:a1 forKey:@"个人中心"];
        [_menuDataSource setObject:a2 forKey:@"我是主办方"];
        [_menuDataSource setObject:a3 forKey:@"我是供应商"];
        [_menuDataSource setObject:a4 forKey:@"我是参会者"];

    }
    return _menuDataSource;
}
- (UITableView *)memberCenterMenu{
    if (!_memberCenterMenu) {
        _memberCenterMenu = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, applicationFrame().size.width, applicationFrame().size.height) style:UITableViewStylePlain];
        _memberCenterMenu.delegate = self;
        _memberCenterMenu.dataSource = self;
        
        NSMutableDictionary *dic = self.menuDataSource;
        [_memberCenterMenu reloadData];
        
    }
    return _memberCenterMenu;
}

#pragma mark  setter

//codes
+ (RootViewController *)rootController{
    RootViewController *c = [[RootViewController alloc]init];
    [c.view setFrame:CGRectMake(0, 0, applicationFrame().size.width, applicationFrame().size.height)];
    c.view.backgroundColor = [UIColor lightGrayColor];
    
    DragScrollView *scrollView = [[DragScrollView alloc]initWithFrame:CGRectMake(0, 0, applicationFrame().size.width, applicationFrame().size.height)];
    [c.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*6.0/4,scrollView.frame.size.height);
    scrollView.bounces = YES;
    scrollView.delegate = c;
    scrollView.scrollEnabled = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delaysContentTouches = YES;
//    [scrollView scrollRectToVisible:CGRectMake(applicationFrame().size.width*4.0/4, 0, applicationFrame().size.width, applicationFrame().size.height) animated:NO];
    scrollView.contentOffset = CGPointMake(applicationFrame().size.width*2.0/4, 0);
    scrollView.passthroughViews = @[c.memberCenterMenu];

    c.rootScrollView = scrollView;
//    [scrollView release];
    
    [scrollView addSubview:c.rootNavigationController.view];
    
    c.rootNavigationController.view.transform = CGAffineTransformMakeTranslation(applicationFrame().size.width*2.0/4, 0);
        
    [c.view addSubview:c.memberCenterMenu];
    [c.view sendSubviewToBack:c.memberCenterMenu];

    return c;
}

#pragma mark scrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLogString(@"停止拖动");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.x<80) {
        _rootTapGesture.enabled = YES;
    }
}

- (void)tap{
    _rootTapGesture.enabled = NO;

    [_rootScrollView scrollRectToVisible:CGRectMake(applicationFrame().size.width*4.0/4, 0, applicationFrame().size.width, applicationFrame().size.height) animated:YES];
}

#pragma mark tabBarController Delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    int index = tabBarController.selectedIndex;
    NSString *title = nil;
    switch (index) {
        case 0:
            title = @"首页";
            break;
        case 1:
            title = @"会议信息";
            break;
        case 2:
            title = @"供应商信息";
            break;
        case 3:
            title = @"会员中心";
            break;
        case 4:
            title = @"客户服务";
            break;
        default:
            break;
    }
    if (index==3) {
        _rootScrollView.scrollEnabled = YES;

        UIBarButtonItem *menu = [[UIBarButtonItem alloc]init];
        [menu setTarget:self];
        [menu setAction:@selector(showMenu)];
        viewController.parentViewController.navigationItem.leftBarButtonItem = menu;
        
        [menu setTitle:@"基本信息"];

    }else{
        _rootScrollView.scrollEnabled = NO;
    }
    viewController.parentViewController.navigationItem.title = title;
}
//显示 隐藏 底部菜单
- (void)showMenu{
    _rootTapGesture.enabled = YES;

    if (_rootScrollView) 
        [_rootScrollView scrollRectToVisible:CGRectMake(applicationFrame().size.width*(-.1), 0, applicationFrame().size.width, applicationFrame().size.height) animated:YES];
}
- (void)hideMenu{
    _rootTapGesture.enabled = NO;
    
    if (_rootScrollView)
        [_rootScrollView scrollRectToVisible:CGRectMake(applicationFrame().size.width*1, 0, applicationFrame().size.width, applicationFrame().size.height) animated:YES];
}
#pragma mark UITablesView delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //  UILabel *result = nil;
    
    UIView *result = nil;
        
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    
    label.text = [self getCellTitleWithIndexOfGroup:section];
    
    label.backgroundColor = [UIColor grayColor];
    
    [label sizeToFit];
    
    label.frame = CGRectMake(label.frame.origin.x, 0, 320, label.frame.size.height);
    
    CGRect resultFrame = CGRectMake(0.0f, 0.0f, label.frame.size.height, label.frame.size.width + 10.0f);
    
    result = [[UIView alloc]initWithFrame:resultFrame];
    
    [result addSubview:label];
    
    return result;
    
}
- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_menuDataSource objectForKey:[self getCellTitleWithIndexOfGroup:section]] count];
}
- (NSString *)getCellTitleWithIndexOfGroup:(int )g{
    NSString *key = nil;
    switch (g) {
        case 0:
            key = @"个人中心";
            break;
        case 1:
            key = @"我是主办方";
            break;
        case 2:
            key = @"我是供应商";
            break;
        case 3:
            key = @"我是参会者";
            break;
        default:
            break;
    }
    return key;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"Menu";
    
    MemberMenuClickCell *cell = (MemberMenuClickCell *)[tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell =  [[MemberMenuClickCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
        cell.userInteractionEnabled = YES;
    }
    NSString *key = [self getCellTitleWithIndexOfGroup:indexPath.section];
    NSLogString(key);
    cell.textLabel.text = [[_menuDataSource objectForKey:key] objectAtIndex:indexPath.row];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_memberCenterViewController changeViewWithIndexPath:indexPath];
    [self hideMenu];
}
@end

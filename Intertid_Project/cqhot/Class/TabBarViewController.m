//
//  TabBarViewController.m
//
//  Created by gitmac on 13-3-18.
//  Copyright (c) 2013年 Gitmac. All rights reserved.
//

#import "TabBarViewController.h"
#import "EUImagePickerController.h"

@interface TabBarViewController ()<EUTabBarViewDelegate>

// Initialize parameter
- (void)dctInternal_setupInternals;

// Initialize views
- (void)initializeViews;
@end

@implementation TabBarViewController
@synthesize selectedIndex = _selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self dctInternal_setupInternals];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeViews];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Init
- (void)dctInternal_setupInternals {
    
}

- (void)initializeViews {
    
    self.view.frame = [UIScreen mainScreen].applicationFrame;
    _tbBar          = [[[NSBundle mainBundle] loadNibNamed:@"EUTabBar" owner:self options:nil] objectAtIndex:0];
    self.tbBar.delegate = self;
    
    CGRect frame    = CGRectZero;
    frame.origin.y  = self.view.frame.size.height - kTBHeight;
    frame.size      = CGSizeMake(320, kTBHeight);
    _tbBar.frame    = frame;
    
    [self.view addSubview:_tbBar];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (kTBHeight + 20+self.navigationController.navigationBar.bounds.size.height);
    self.containerView.frame = frame;
    
    [self.view addSubview:self.containerView];
    [self.view sendSubviewToBack:self.containerView];
    
    
    //  frame = [UIScreen mainScreen].bounds;
    //  frame.size.height = frame.size.height - 45;
    //
    //  [[[self.view subviews] objectAtIndex:0] setFrame:frame];
    
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].applicationFrame));
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    NSLog(@"%@",NSStringFromCGRect(self.navigationController.view.frame));
    NSLog(@"%@",NSStringFromCGRect(frame));
    NSLog(@"%@",NSStringFromCGRect(self.selectedViewController.view.frame));
    
    //  self.selectedViewController = [];
    self.selectedIndex = 0;
    //  [[self.viewControllers objectAtIndex:0] viewWillAppear:YES];
    
    self.navigationItem.title = @"首页";
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.selectedViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    //  [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    //  [self.selectedViewController viewDidDisappear:animated];
}


- (void)hiddenBar {
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame    = _tbBar.frame;
        frame.origin.y  = self.view.frame.size.height;
        _tbBar.frame    = frame;
    } completion:^(BOOL b){
        
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size.height = frame.size.height;
        [[[self.view subviews] objectAtIndex:0] setFrame:frame];
    }];
    
}

- (void)showBarAnimation:(BOOL)animation {
    if (animation) {
        [self showBar];
    }else {
        CGRect frame    = _tbBar.frame;
        frame.origin.y  = self.view.frame.size.height - kTBHeight;
        _tbBar.frame    = frame;
        
        frame = [UIScreen mainScreen].bounds;
        frame.size.height = frame.size.height - 45;
        
        [[[self.view subviews] objectAtIndex:0] setFrame:frame];
    }
}
- (void)showBar {
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame    = _tbBar.frame;
        frame.origin.y  = self.view.frame.size.height - kTBHeight;
        _tbBar.frame    = frame;
    } completion:^(BOOL b){
        
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size.height = frame.size.height - 45;
        
        [[[self.view subviews] objectAtIndex:0] setFrame:frame];
    }];
    
}


- (void)tabBarView:(EUTabBar *)aTabBarView didSelectButtonAtIndex:(NSInteger)index {
    self.navigationItem.leftBarButtonItem = nil;
    if (index == 2) {
        [self takePicture];
        return;
    }
    switch (index) {
        case 0:
            self.navigationItem.title = @"首页";
            break;
        case 1:
            self.navigationItem.title = @"导航";
            break;
        case 2:
            self.navigationItem.title = @"导航";
            break;
        case 3:
            self.navigationItem.title = @"收藏";
            break;
        case 4:
            self.navigationItem.title = @"更多";
            break;
        default:
            break;
    }
    if(index >= [self.viewControllers count]) {
        return;
    }
    
    self.selectedIndex = index;
    UIViewController *vc = [self.viewControllers objectAtIndex:_selectedIndex];
    if (self.selectedViewController == vc) {
        //如果导航进入的视图这弹出
        [vc.navigationController popViewControllerAnimated:NO];
    }else {
        self.selectedViewController = vc;
    }
    
}


- (void)viewDidUnload {
    _tbBar = nil;
    [super viewDidUnload];
}
#pragma mark -
#pragma mark EUTabBarControlelr
- (void)setSelectedViewController:(UIViewController *)vc {
    
    UIViewController *oldVC= _selectedViewController;
    
    CGRect frame = _containerView.bounds;
    
    if (vc != _selectedViewController) {
        _selectedViewController = vc;
        _selectedViewController.view.frame = frame;
        
        if (!self.childViewControllers) {
            [oldVC viewWillDisappear:NO];
            [_selectedViewController viewWillAppear:NO];
        }
        
        [oldVC.view removeFromSuperview];
        [self.containerView addSubview:vc.view];
        [self.containerView sendSubviewToBack:vc.view];
        
        if (!self.childViewControllers) {
            [oldVC viewDidDisappear:NO];
            [_selectedViewController viewDidAppear:NO];
        }
    }
}
- (void)setSelectedIndex:(NSUInteger)index {
    _selectedIndex = index;
    if (self.viewControllers.count > index) {
        self.selectedViewController = [self.viewControllers objectAtIndex:index];
    }
}

- (NSUInteger)selectedIndex {
    
    return [self.viewControllers indexOfObject:self.selectedViewController];
}


@end

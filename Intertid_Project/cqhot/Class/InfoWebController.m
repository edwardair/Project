//
//  InfoWebController.m
//  cqhot
//
//  Created by ZL on 13-4-7.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "InfoWebController.h"
#import "AppDelegate.h"
#import "EUWebView.h"

@interface InfoWebController ()

@end

@implementation InfoWebController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
//  [AppDelegate showTabBarAnimation:NO];
//  [AppDelegate showTabBar];
//  [super dealloc];
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

- (void)viewDidAppear:(BOOL)animated {
//    [AppDelegate hiddenTabBar];
}
//- (void)viewWillDisappear:(BOOL)animated {
//  [AppDelegate showTabBar];
//}

- (void)dctInternal_setupInternals {

}

- (void)initializeViews {
  self.navigationItem.leftBarButtonItem = [self leftItem];
  
  EUWebView *web = [[EUWebView alloc] initWithFrame:self.view.bounds];
  web.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
  [web loadRequest:[NSURLRequest requestWithURL:_webURL]];
  [web setScalesPageToFit:YES];
  [self.view addSubview:web];

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
  [btn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
  
  view = nil;
  imageView = nil;
  
  return item;
}

- (void)backTo {
  [self.navigationController popViewControllerAnimated:YES];
}




@end

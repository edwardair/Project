//
//  SMS_ViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-9.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "SMS_ViewController.h"

@interface SMS_ViewController (){
    CGRect rect;
    UIScrollView *bottomScrollView;
}

@end

@implementation SMS_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rect = [[UIScreen mainScreen]applicationFrame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadBottomScrollView];

    [self loadLabels];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

//底部 scrollView
- (void)loadBottomScrollView{
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self.view addSubview:bottomScrollView];
    bottomScrollView.contentSize = CGSizeMake(0, rect.size.height+100);
    bottomScrollView.backgroundColor = [UIColor lightGrayColor];
}
//添加 所有 UILabel
- (void)loadLabels{
    UILabel *model = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [bottomScrollView addSubview:model];
    model.text = @"短信模板";
}
@end

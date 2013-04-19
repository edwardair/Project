//
//  IWRViewController.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-19.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "IWRViewController.h"
#import "RepairPopoverView.h"

@interface IWRViewController ()

@end

@implementation IWRViewController

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
    [_reasonButton setTitle:@"黑屏" forState:UIControlStateNormal];
    [_reasonButton setTitle:@"黑屏" forState:UIControlStateHighlighted];

    _installationUnitButton.type = UICheckBoxTypeDefault;
    _principalButton.type = UICheckBoxTypeDefault;
    _installationUnitButton.text = @"安装单位";
    _principalButton.text = @"项目负责人";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//故障原因
- (IBAction)reasonButtonPressed{
    RepairPopoverView *repair = [[RepairPopoverView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [repair show:self];
}

//提交
- (IBAction)submitButtonPressed{
    
}
//重置
- (IBAction)resetButtonPressed{
    [_reasonButton setTitle:@"黑屏" forState:UIControlStateNormal];
    [_reasonButton setTitle:@"黑屏" forState:UIControlStateHighlighted];
    _installationUnitButton.boxSelected = NO;
    _principalButton.boxSelected = NO;
}

#pragma mark RepairPopoverView Delegate
- (void)cellSelected:(int)index{
    NSLog(@"%d",index);
    NSString *text = nil;
    switch (index) {
        case 0:
            text = @"黑屏";
            break;
        case 1:
            text = @"原因A";
            break;
        case 2:
            text = @"原因原因啊";
            break;

        default:
            break;
    }
    [_reasonButton setTitle:text forState:UIControlStateNormal];
    [_reasonButton setTitle:text forState:UIControlStateHighlighted];
}

@end

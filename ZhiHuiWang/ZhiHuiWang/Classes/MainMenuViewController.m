//
//  MainMenuViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CreateNewMeetingViewController.h"
@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

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
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:1 target:self action:nil];
    self.navigationItem.backBarButtonItem = back;

}

- (void)CreateNewMeeting{

    CreateNewMeetingViewController *new = [[CreateNewMeetingViewController alloc]initWithNibName:@"CreateNewMeetingViewController" bundle:nil];

    [self.navigationController pushViewController:new animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

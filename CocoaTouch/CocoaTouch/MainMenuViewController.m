//
//  MainMenuViewController.m
//  CocoaTouch
//
//  Created by BlackApple on 13-3-22.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CreateNewMeetingViewController.h"
enum{
    CreateNewMeeting = 1,
};
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuPressed:(UIButton *)sender{
    switch (sender.tag) {
        case CreateNewMeeting:
            NSLog(@"新建会议  按钮点击");
            [self createNewMeeting];
            break;
            
        default:
            break;
    }
}
- (void)createNewMeeting{
    CreateNewMeetingViewController *ctrl = [[CreateNewMeetingViewController alloc]initWithNibName:@"CreateNewMeetingViewController" bundle:nil];
    
    cl = [[UINavigationController alloc]init];
    cl.navigationBarHidden = NO;
    cl.title = @"新建会议B";
    back = [[UIBarButtonItem alloc]initWithTitle:@"Go Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMenu)];
    cl.navigationItem.backBarButtonItem = back;

    [cl pushViewController:ctrl animated:YES];

    [self.view addSubview:cl.view];
}
- (void)backToMenu{
    [cl removeFromParentViewController];
}
@end

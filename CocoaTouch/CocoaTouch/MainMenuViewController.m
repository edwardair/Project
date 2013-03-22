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
    UINavigationController *cl = [[UINavigationController alloc]init];
    cl.navigationBarHidden = NO;
    cl.title = @"新建会议 标题";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:<#(UIBarButtonItemStyle)#> target:<#(id)#> action:<#(SEL)#>]
    
    cl.navigationItem.leftBarButtonItem
    [cl pushViewController:ctrl animated:YES];
//    [cl.view addSubview:ctrl];
    [self.view addSubview:cl.view];
}

@end

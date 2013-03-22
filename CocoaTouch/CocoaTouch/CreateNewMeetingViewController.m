//
//  CreateNewMeetingViewController.m
//  CocoaTouch
//
//  Created by BlackApple on 13-3-22.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CreateNewMeetingViewController.h"

@interface CreateNewMeetingViewController ()

@end

@implementation CreateNewMeetingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"新建会议 初始化");
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

@end

//
//  CreateNewMeetingViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CreateNewMeetingViewController.h"
#import "SubMenuButton.h"
#define Title @"新建会议"
@interface CreateNewMeetingViewController ()

@end

@implementation CreateNewMeetingViewController

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
    self.title = Title;
    
//    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CreateNewMeeting_Create" owner:nil options:nil];
//    [self.view addSubview:[array objectAtIndex:0]];

    
    
}
- (void)btnClicked:(SubMenuButton *)btn{
    NSLog(@"clicked %d",btn.tag);
    
}

//- (UIImage *)contextImageWithTitle:(NSString *)title{
//    UILabel *label = [[UILabel alloc]init];
//    label.text = title;
//    label.textColor = [UIColor blueColor];
//    
//    CGSize size = CGSizeMake(200, 100);
//    UIGraphicsBeginImageContext(size);
//    [label drawRect:label.frame];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

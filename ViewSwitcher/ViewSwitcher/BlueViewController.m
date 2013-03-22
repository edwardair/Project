//
//  BlueViewController.m
//  ViewSwitcher
//
//  Created by BlackApple on 13-3-22.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "BlueViewController.h"

@interface BlueViewController ()

@end

@implementation BlueViewController

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

- (IBAction)blueButtonPressed{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Blue View Pressed" message:@"blue button pressed" delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:nil];
    [alert show];
}

@end

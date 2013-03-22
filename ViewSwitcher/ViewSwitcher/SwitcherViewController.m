//
//  SwitcherViewController.m
//  ViewSwitcher
//
//  Created by BlackApple on 13-3-22.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "SwitcherViewController.h"
#import "BlueViewController.h"
#import "YellowViewController.h"

@interface SwitcherViewController ()

@end

@implementation SwitcherViewController

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
    
    BlueViewController *blueController = [[BlueViewController alloc]initWithNibName:@"BlueViewController" bundle:nil];
    self.blueViewController = blueController;
    
    [self.view insertSubview:blueController.view atIndex:0];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchViews:(id)sender{
    NSLog(@"switch");
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.yellowViewController.view.superview == nil) {
        if (self.yellowViewController == nil) {
            YellowViewController *yellowController = [[YellowViewController alloc]initWithNibName:@"YellowViewController" bundle:nil];
            self.yellowViewController = yellowController;
        }
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [_blueViewController viewWillAppear:YES];
        [_yellowViewController viewWillDisappear:YES];
        
        [_blueViewController.view removeFromSuperview];
        [self.view insertSubview:_yellowViewController.view atIndex:0];
        
        [_yellowViewController viewDidDisappear:YES];
        [_blueViewController viewDidAppear:YES];

    }else{
        if (self.blueViewController == nil) {
            BlueViewController *blueController = [[BlueViewController alloc]initWithNibName:@"BlueViewController" bundle:nil];
            self.blueViewController = blueController;
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];

        [_blueViewController viewWillDisappear:YES];
        [_yellowViewController viewWillAppear:YES];

        [_yellowViewController.view removeFromSuperview];
        [self.view insertSubview:_blueViewController.view atIndex:0];
        
        [_yellowViewController viewDidAppear:YES];
        [_blueViewController viewDidDisappear:YES];

    }
    [UIView commitAnimations];
}
@end

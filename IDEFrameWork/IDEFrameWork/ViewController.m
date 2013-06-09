//
//  ViewController.m
//  IDEFrameWork
//
//  Created by Apple on 13-5-31.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "WGImageView.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        WGImageView *image = [[WGImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
//        image.layer.position = CGPointMake(160, 240);
        [self.view addSubview:image];
        image.image = [UIImage imageNamed:@"Test.png"];
        [image sizeToFit];
        [UIView animateWithDuration:2 animations:^{
            [UIView setAnimationDelay:2.f];
            image.transform = CGAffineTransformMakeTranslation(100, 0);
        } completion:^(BOOL finished) {
            NSLog(@"OK");
        }];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

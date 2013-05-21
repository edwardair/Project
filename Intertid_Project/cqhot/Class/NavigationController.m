//
//  NavigationController.m
//  hmHospital
//
//  Created by ZL on 13-3-18.
//  Copyright (c) 2013年 Gitmac. All rights reserved.
//

#import "NavigationController.h"
#import "EUKitCompat.h"
#import <QuartzCore/QuartzCore.h>

//static UIImage *image = nil;
@interface UINavigationBar (UINavigationBarCategory)

-(void)setBackgroundImage;
@end

@implementation UINavigationBar (UINavigationBarCategory)

- (void)setBackgroundImage{
  
  [[[[self subviews] objectAtIndex:0] layer] setContents:(id )[UIImage imageNamed:@"navbar-bg-blue-cornered.png"].CGImage];
  return;
}

@end

@interface NavigationController ()

@end

@implementation NavigationController

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
  [self.navigationBar setBackgroundImage];

}

@end

//
//  TPhotoController.m
//  cqhot
//
//  Created by ZL on 13-4-2.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "TPhotoController.h"
#import "EUImagePickerController.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"

@interface TPhotoController ()
{
  NSInteger oldTabIndex;
}

- (UINavigationController *)navigationController;
@end

@implementation TPhotoController

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


- (UINavigationController *)navigationController {
  return [(AppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
}

- (void)viewWillAppear:(BOOL)animated {
  
//  AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [self takePicture];
//  [[ad tabBarController] takePicture];
}

- (void)imagePickerControllerDidDisappear:(EUImagePickerController *)controller {
  if (controller.tempPath == nil) {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TabBarViewController *tb = [ad tabBarController];
    tb.selectedIndex = 1;
//    tb.tbBar.index = 1;
//    self.tabBarController.selectedIndex = 1;
//    [[(TabBarViewController *)self.tabBarController tbBar] setTabIndex:1];
  }
}
@end

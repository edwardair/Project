//
//  AppDelegate.m
//  cqhot
//
//  Created by ZL on 13-4-2.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "AppDelegate.h"

#import "ConfigureController.h"
#import "MFavoritesController.h"
#import "TPhotoController.h"
#import "GuideController.h"
#import "CQHotController.h"

#import "NavigationController.h"

BMKMapManager* _mapManager;

#import "LBSManager.h"


@implementation AppDelegate



#pragma mark -
#pragma mark TabBarController <- UITabBarController


- (NSArray *)tbControllers{
    CQHotController *cc       = [[CQHotController alloc] init];
    GuideController *gc       = [[GuideController alloc] init];
    TPhotoController *tc      = [[TPhotoController alloc] init];
    MFavoritesController *fc  = [[MFavoritesController alloc] init];
    ConfigureController *cf   = [[ConfigureController alloc] init];
    
    cc.title = @"123解放碑";
    gc.title = @"导航";
    fc.title = @"收藏";
    cf.title = @"更多";
    
    __autoreleasing NSArray *rs = [[NSArray alloc] initWithObjects:cc,gc,tc,fc,cf, nil];
    return rs;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _mapManager = [[BMKMapManager alloc] init];
	BOOL ret = [_mapManager start:@"SFk2mvdiI4qi5gDeeRV64fa8" generalDelegate:self];
    if (!ret) {
		NSLog(@"manager start failed!");
	}
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    [[LBSManager sharedManager] startUpdatingLocation];
    
    
    
    self.tabBarController = [[TabBarViewController alloc] init];
    //  self.tabBarController.view.frame = [UIScreen mainScreen].applicationFrame;
    self.tabBarController.viewControllers = [self tbControllers];
    
    
    self.navigationController = (EUNavigationController *)[[NavigationController alloc] initWithRootViewController:self.tabBarController];
    self.navigationController.navigationBarHidden = NO;
    
    self.window.rootViewController = self.navigationController;
    
    //  NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].applicationFrame));
    NSLog(@"%@",NSStringFromCGRect(self.tabBarController.view.frame));
    NSLog(@"%@",NSStringFromCGRect(self.navigationController.view.frame));
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onGetNetworkState:(int)iError
{
}

- (void)onGetPermissionState:(int)iError
{
}

@end

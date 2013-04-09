//
//  AppDelegate.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "AppDelegate.h"
#import "CreateNewMeetingViewController.h"
#import "SMS_ViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
//    MainMenuViewController *mainMenu = [[MainMenuViewController alloc]initWithNibName:@"MainMenuViewController" bundle:nil];
//    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainMenu];
    
    UIViewController *createNewMeeting = [[CreateNewMeetingViewController alloc]initWithNibName:@"CreateNewMeetingViewController" bundle:nil];
    UIViewController *smsNotification = [[SMS_ViewController alloc]initWithNibName:@"SMS_ViewController" bundle:nil];

    UITabBarController *rootController = [[UITabBarController alloc]init];
    rootController.viewControllers = @[createNewMeeting,smsNotification];
    rootController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    createNewMeeting.parentViewController.navigationItem.title = @"新建会议";

    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    int index = tabBarController.selectedIndex;
    NSString *title = nil;
    switch (index) {
        case 0:
            title = @"新建会议";
            break;
        case 1:
            title = @"会议通知";
            break;
        default:
            break;
    }
    viewController.parentViewController.navigationItem.title = title;
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

@end

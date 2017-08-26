//
//  AppDelegate.m
//  好梦学车教练端
//
//  Created by haomeng on 2017/8/10.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LaunchIntroductionView.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate{
     MainViewController *main;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置主题window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    main = [[MainViewController alloc] init];
    self.window.rootViewController = main;
    [self.window makeKeyAndVisible];
    main.delegate = self;
//    [LaunchIntroductionView sharedWithImages:@[@"welcome01.jpg",@"welcome02.jpg",@"welcome031.jpg"] buttonImage:@"" buttonFrame:CGRectMake(kScreen_width/2 - 150/2, kScreen_height - 100, 150, 45)];
    return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController.title isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showChoosedStduents" object:nil];
        
        return NO;
    }else
        return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

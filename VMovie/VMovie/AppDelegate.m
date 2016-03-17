//
//  AppDelegate.m
//  VMovie
//
//  Created by wyz on 16/3/12.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "EaseStartView.h"
#import "NewFeatureViewController.h"
#import "VMNavigationController.h"
#import "DetailViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *sandboxVersion = [UserDefaults stringForKey:@"AppVersion"];
    NSString *currentVersion = APP_VERSION;
    
    if ([currentVersion isEqualToString:sandboxVersion]) {
        VMNavigationController *vmNav = [[VMNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
        self.window.rootViewController =vmNav;
    } else {
        self.window.rootViewController = [[NewFeatureViewController alloc] init];
        [UserDefaults setObject:currentVersion forKey:@"AppVersion"];
        [UserDefaults synchronize];
    }
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:SwitchRootViewControllerNotification object:nil] subscribeNext:^(id x) {
        VMNavigationController *vmNav = [[VMNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
        self.window.rootViewController = vmNav;
    }];
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //启动动画
//    EaseStartView *startView = [EaseStartView startView];
//    [startView startAnimation];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

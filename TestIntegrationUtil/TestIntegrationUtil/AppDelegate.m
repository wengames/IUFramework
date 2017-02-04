//
//  AppDelegate.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]].setBackgroundColor([UIColor colorWithWhite:0.7 alpha:1]).setRootViewController([[UINavigationController alloc] initWithRootViewController:[[IndexViewController alloc] init]]);
    [(UINavigationController *)self.window.rootViewController fullScreenInteractivePopGestureRecognizer].enabled = YES;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

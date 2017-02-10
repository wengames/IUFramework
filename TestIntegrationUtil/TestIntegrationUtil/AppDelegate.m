//
//  AppDelegate.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"

@interface Father : NSObject

@end

@implementation Father

- (void)call {
    NSLog(@"father call");
}

@end

@interface Son : Father

@end

@implementation Son

+ (void)load {
    [self swizzleInstanceSelector:@selector(call) toSelector:@selector(_call)];
}

- (void)_call {
    [self _call];
    NSLog(@"son call");
}

@end

@interface Grandson : Son

@end

@implementation Grandson

+ (void)load {
    [self swizzleInstanceSelector:@selector(call) toSelector:@selector(__call)];
}

- (void)__call {
    [self __call];
    NSLog(@"grandson call");
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDate *date = [NSDate date];
    NSLog(@"今天星期%ld, %@", [date weekday], [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]);
    
    id obj = [NSNull null];
    NSLog(@"obj[0] = %@", obj[0]);
    NSLog(@"[[NSNull null] integerValue] = %ld", [obj integerValue]);
    NSLog(@"[[NSNull null] length] = %ld", [obj length]);
    NSLog(@"[[NSNull null] count] = %ld", [obj count]);
    NSLog(@"[[NSNull null] firstObject] = %@", [obj firstObject]);
    
    [[Father new] call];
    [[Son new] call];
    [[Grandson new] call];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[
                                         [[UINavigationController alloc] initWithRootViewController:[[IndexViewController alloc] init]],
                                         [[UINavigationController alloc] initWithRootViewController:[[IndexViewController alloc] init]]
                                         ];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]].setBackgroundColor([UIColor colorWithWhite:0.7 alpha:1]).setRootViewController(tabBarController);
    [self.window makeKeyAndVisible];
        
    return YES;
}

@end

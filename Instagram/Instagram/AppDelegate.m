//
//  AppDelegate.m
//  Instagram
//
//  Created by zcs on 2017/5/28.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"2kYOlpO9dDmsnqu2vUtinFqs-gzGzoHsz" clientKey:@"CNLhdVToROW2z6sPH3NuP0Eb"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [self login];
    [self.window setBackgroundColor:[UIColor whiteColor]];
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

- (void)login {
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
/*
    if (str != nil) {
        [[AVUser currentUser] follow:@"592ec8870ce4630057abaa61" andCallback:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"成功关注");
            }
            else {
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
*/
    if (str != nil) {
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController* myTabBar = [storyBoard instantiateViewControllerWithIdentifier:@"TabBar"];
        self.window.rootViewController = myTabBar;
    }

}


@end

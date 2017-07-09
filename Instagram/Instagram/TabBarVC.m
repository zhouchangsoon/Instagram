//
//  TabBarVC.m
//  Instagram
//
//  Created by zcs on 2017/6/25.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import "TabBarVC.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    设置标签栏中的字体为白色
    [self.tabBar setTintColor:[UIColor whiteColor]];
//    设置标签栏的背景为黑色
    [self.tabBar setBarTintColor:[UIColor colorWithRed:37.0 / 255.0 green:39.0 / 255.0 blue:42.0 / 255.0 alpha:1]];
//    设置标签栏为不透明
    [self.tabBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

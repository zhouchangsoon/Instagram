//
//  ShowPicture.m
//  Instagram
//
//  Created by zcs on 2017/6/22.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import "ShowPicture.h"

@interface ShowPicture ()

@end

@implementation ShowPicture

- (void)viewDidLoad {
    [super viewDidLoad];
//    加载图片
    [self.img getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error == nil) {
            self.imgView.image = [UIImage imageWithData:data];
        }
        else {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"警告 " message:[NSString stringWithFormat:@"加载图片出错, %@",error.localizedDescription]preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
//    设置图片位置
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat heigth = [UIScreen mainScreen].bounds.size.height;
    self.imgView.frame = CGRectMake(0, heigth / 2 - width / 2, width, width);
    
//    设置背景颜色为黑色
    self.view.backgroundColor = [UIColor blackColor];
    
//    重新设置返回按钮
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
//    设置滑动返回
    UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwipe];
//    添加删除按钮
    UIBarButtonItem* deleteButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(remove:)];
    self.navigationItem.rightBarButtonItem = deleteButtonItem;
    
}


/**
 删除图片，成功则返回上一层，失败则弹出警告

 @param item 右上角的删除按钮
 */
- (void)remove:(UIBarButtonItem *)item {
    AVQuery* query = [AVQuery queryWithClassName:@"Posts"];
    [query whereKey:@"username" equalTo:[AVUser currentUser].username];
    [query whereKey:@"pic" equalTo:self.img];
    [query deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error == nil) {
            self.img = nil;
            self.imgView.image = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploaded" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"警告 " message:[NSString stringWithFormat:@"删除图片出错, %@",error.localizedDescription]preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}


/**
 返回上一层

 @param item 坐上角的返回按钮
 */
- (void)back:(UIBarButtonItem *)item {
    self.img = nil;
    self.imgView.image = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)imgTap:(UITapGestureRecognizer *)gesture {
    self.imgView.image = nil;
    self.img = nil;
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

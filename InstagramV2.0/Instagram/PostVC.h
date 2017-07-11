//
//  PostVC.h
//  Instagram
//
//  Created by zcs on 2017/6/23.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "PostCell.h"
#import "HomeVC.h"
#import "GuestVC.h"
#import "CommentVC.h"

@interface PostVC : UITableViewController
//属性
@property (strong, nonatomic) NSString* post;
@property (strong, nonatomic) NSMutableArray<NSString *> *postuuid;
@property (strong, nonatomic) NSMutableArray<AVFile *> *avaArray;
@property (strong, nonatomic) NSMutableArray<NSString *> *usernameArray;
@property (strong, nonatomic) NSMutableArray<NSDate *> *dateArray;
@property (strong, nonatomic) NSMutableArray<AVFile *> *picArray;
@property (strong, nonatomic) NSMutableArray<NSString *> *puuidArray;
@property (strong, nonatomic) NSMutableArray<NSString *> *titleArray;
//点击用户名按钮
- (IBAction)username_clicked:(UIButton *)sender;
//点击评论按钮
- (IBAction)commentBtn_clicked:(UIButton *)sender;
- (IBAction)more_clicked:(UIButton *)sender;

@end

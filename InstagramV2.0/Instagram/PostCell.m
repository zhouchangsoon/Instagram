//
//  PostCell.m
//  Instagram
//
//  Created by zcs on 2017/6/23.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    将所有组件设置为autolayout,启用约束
    self.avaImg.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.picImg.translatesAutoresizingMaskIntoConstraints = NO;
    self.likeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.commentBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.moreBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.puuidLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.likeLbl.translatesAutoresizingMaskIntoConstraints = NO;
//    获取屏幕宽度
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    int picWidth = width - 20;
//    设置垂直约束
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-10-[ava(30)]-10-[pic(%d)]-10-[like(25)]", picWidth] options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.avaImg, @"ava", self.picImg, @"pic", self.likeBtn, @"like", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-10-[username]"] options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.usernameBtn, @"username", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[pic]-10-[comment(25)]"] options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.picImg, @"pic", self.commentBtn, @"comment", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[dateLbl]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.dateLbl, @"dateLbl", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[like]-5-[title]-5-|" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.likeBtn, @"like", self.titleLbl, @"title", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pic]-13-[more(15)]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.picImg, @"pic", self.moreBtn, @"more", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pic]-12-[likes]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.picImg, @"pic", self.likeLbl, @"likes", nil]]];
//     设置水平约束
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[ava(30)]-10-[username]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.avaImg, @"ava", self.usernameBtn, @"username", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pic]-0-|" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.picImg, @"pic", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[like(25)]-10-[likes(30)]-20-[comment(25)]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.likeBtn, @"like", self.likeLbl, @"likes", self.commentBtn, @"comment", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[more(30)]-15-|" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.moreBtn, @"more", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[title]-15-|" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLbl, @"title", nil]]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[date]-15-|" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.dateLbl, @"date", nil]]];
//    将头像设置为圆形
    self.avaImg.layer.cornerRadius = self.avaImg.frame.size.width / 2;
    self.avaImg.layer.masksToBounds = YES;
//    将likeBtn的字体设置为透明
    [self.likeBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    为图片添加双击事件，双击后变成喜欢
    UITapGestureRecognizer* imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [imageTap setNumberOfTapsRequired:2];
    [imageTap setNumberOfTouchesRequired:1];
    [self.picImg setUserInteractionEnabled:YES];
    [self.picImg addGestureRecognizer:imageTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 点击图片

 @param gesture 点击
 */
- (void)imageTap:(UITapGestureRecognizer *)gesture {
    UIImageView* loveImg = [[UIImageView alloc] init];
    loveImg.frame = CGRectMake(self.picImg.center.x - self.picImg.frame.size.width / 3, self.picImg.center.y - self.picImg.frame.size.width / 3, self.picImg.frame.size.width / 1.5, self.picImg.frame.size.width / 1.5);
    [self addSubview:loveImg];
//    如果现在的状态是不喜欢，则双击变成喜欢
    if ([[self.likeBtn titleForState:UIControlStateNormal] isEqualToString:@"dislike"]) {
        loveImg.image = [UIImage imageNamed:@"dislike.png"];
        AVObject* likeObject = [AVObject objectWithClassName:@"Likes"];
        [likeObject setObject:[AVUser currentUser].username forKey:@"from"];
        [likeObject setObject:self.puuidLbl.text forKey:@"to"];
        [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil) {
                [self.likeBtn setTitle:@"like" forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                [UIView animateWithDuration:0.4 animations:^{
                    loveImg.alpha = 0;
                    [loveImg setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
                }];
            }
            else {
                NSLog(@"上传喜欢出错，imageTap：,%@", error.localizedDescription);
            }
        }];
        AVObject* likeNews = [AVObject objectWithClassName:@"News"];
        [likeNews setObject:[AVUser currentUser].username forKey:@"by"];
        [likeNews setObject:[self.usernameBtn titleForState:UIControlStateNormal] forKey:@"to"];
        [likeNews setObject:self.puuidLbl.text forKey:@"puuid"];
        [likeNews setObject:@"no" forKey:@"checked"];
        [likeNews setObject:@" " forKey:@"message"];
        [likeNews setObject:[[AVUser currentUser] objectForKey:@"ava"] forKey:@"ava"];
        [likeNews setObject:@"like" forKey:@"type"];
        [likeNews setObject:[self.usernameBtn titleForState:UIControlStateNormal] forKey:@"owner"];
        [likeNews saveEventually];
    }
    else {
        loveImg.image = [UIImage imageNamed:@"love.png"];
        [UIView animateWithDuration:0.4 animations:^{
            loveImg.alpha = 0;
            [loveImg setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
        }];
    }
}

/**
 点击喜欢按钮，原来不喜欢就变成喜欢，喜欢则不变

 @param sender 按钮
 */
- (IBAction)likeBtn_clicked:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"like"]) {
        AVQuery* likeQuery = [AVQuery queryWithClassName:@"Likes"];
        [likeQuery whereKey:@"from" equalTo:[AVUser currentUser].username];
        [likeQuery whereKey:@"to" equalTo:self.puuidLbl.text];
        [likeQuery deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil) {
//                改变喜爱的图片并通知tableView
                [self.likeBtn setTitle:@"dislike" forState:UIControlStateNormal];
                [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"dislike.png"] forState:UIControlStateNormal];
                AVQuery* deleteLikeQuery = [AVQuery queryWithClassName:@"Likes"];
                [deleteLikeQuery whereKey:@"from" equalTo:[AVUser currentUser].username];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            }
            else {
                NSLog(@"取消喜爱出错, %@", error.localizedDescription);
            }
        }];
//        删除喜爱消息
        AVQuery* likeNewsQuery = [AVQuery queryWithClassName:@"News"];
        [likeNewsQuery whereKey:@"by" equalTo:[AVUser currentUser].username];
        [likeNewsQuery whereKey:@"puuid" equalTo:self.puuidLbl.text];
        [likeNewsQuery whereKey:@"to" equalTo:[self.usernameBtn titleForState:UIControlStateNormal]];
        [likeNewsQuery whereKey:@"type" equalTo:@"like"];
        [likeNewsQuery deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
    }
    else {
        AVObject* likeObject = [AVObject objectWithClassName:@"Likes"];
        [likeObject setObject:[AVUser currentUser].username forKey:@"from"];
        [likeObject setObject:self.puuidLbl.text forKey:@"to"];
        [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                [self.likeBtn setTitle:@"like" forState:UIControlStateNormal];
                [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"love.png"] forState:UIControlStateNormal];
            }
            else {
                NSLog(@"添加喜爱出错,%@", error.localizedDescription);
            }
        }];
//        将喜爱的消息上传
        AVObject* likeNews = [AVObject objectWithClassName:@"News"];
        [likeNews setObject:[AVUser currentUser].username forKey:@"by"];
        [likeNews setObject:[self.usernameBtn titleForState:UIControlStateNormal] forKey:@"to"];
        [likeNews setObject:self.puuidLbl.text forKey:@"puuid"];
        [likeNews setObject:@"no" forKey:@"checked"];
        [likeNews setObject:@" " forKey:@"message"];
        [likeNews setObject:[[AVUser currentUser] objectForKey:@"ava"] forKey:@"ava"];
        [likeNews setObject:@"like" forKey:@"type"];
        [likeNews setObject:[self.usernameBtn titleForState:UIControlStateNormal] forKey:@"owner"];
        [likeNews saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"上传发生错误");
            }
        }];
    }
}



@end

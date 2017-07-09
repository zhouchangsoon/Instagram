//
//  NewsCell.m
//  Instagram
//
//  Created by zcs on 2017/7/8.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    使用自动布局
    self.avaImg.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLbl.translatesAutoresizingMaskIntoConstraints = NO;
    [self autoLayout];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 为newscell添加位置约束
 */
- (void)autoLayout {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[ava(30)]-10-[username]-7-[info]-50-|" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.avaImg, @"ava", self.usernameBtn, @"username", self.infoLbl, @"info", nil]]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[date(30)-10-|]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.dateLbl, @"date", nil]]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[ava(30)-10-|]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.avaImg, @"ava", nil]]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[username(30)]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.usernameBtn, @"username", nil]]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[info]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.infoLbl, @"info", nil]]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[date]" options:0 metrics:nil views:[NSDictionary dictionaryWithObjectsAndKeys:self.dateLbl, @"date", nil]]];
}

@end

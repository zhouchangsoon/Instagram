//
//  UploadVC.m
//  Instagram
//
//  Created by zcs on 2017/6/20.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import "UploadVC.h"

@interface UploadVC ()

@end

@implementation UploadVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    点击图片转到照片库选择图片
    [self imgTap];
//    点击任意地方使键盘消失
    [self hideKeyboard];
//    设置图片为默认图片
    self.picImg.image = [UIImage imageNamed:@"头像.png"];
//    清空图片简介
    self.introText.text = nil;
//    设置提交按钮标题
    self.publishBtn.titleLabel.text = @"提交";
//    还没有选择照片的时候隐藏删除和上传按钮
    [self.deleteBtn setUserInteractionEnabled:NO];
    [self.deleteBtn setHidden:YES];
    [self.publishBtn setUserInteractionEnabled:NO];
    [self.deleteBtn setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
//    设置图片、简介、上传按钮和删除按钮的位置
    [self alignment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击任意地方使键盘消失
- (void)hideKeyboard {
    UITapGestureRecognizer* hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    [hideTap setNumberOfTapsRequired:1];
    [hideTap setNumberOfTouchesRequired:1];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:hideTap];
}

//点击任意地方后，键盘消失
- (void)keyboardHide:(UITapGestureRecognizer *)gesture {
    [self.introText resignFirstResponder];
}

//点击图片转到照片库选择图片
- (void)imgTap {
    UITapGestureRecognizer* tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
    [tapImg setNumberOfTapsRequired:1];
    [tapImg setNumberOfTouchesRequired:1];
    [self.picImg setUserInteractionEnabled:YES];
    [self.picImg addGestureRecognizer:tapImg];
}

//点击图片后转到照片库
- (void)tapImg:(UITapGestureRecognizer *)gesture {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [imagePicker setAllowsEditing:YES];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//用户取消选择，返回上层
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//用户选择照片后，显示图片并返回上层
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    用户选择照片后，显示图片并返回上层
    self.picImg.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
//    更改上传按钮的颜色，并设置其可以点击
    [self.publishBtn setEnabled:YES];
    [self.publishBtn setBackgroundColor:[UIColor colorWithRed:52.0 / 255.0 green:169.0 / 255.0 blue:255.0 / 255.0 alpha:1]];
    [self.publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    添加点击图片事件，使点击图片后图片放大
    UITapGestureRecognizer* zoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
    [zoomTap setNumberOfTouchesRequired:1];
    [zoomTap setNumberOfTapsRequired:1];
    [self.picImg setUserInteractionEnabled:YES];
    [self.picImg addGestureRecognizer:zoomTap];
//    选择图片后显示删除和上传按钮
    [self.deleteBtn setHidden:NO];
    [self.deleteBtn setUserInteractionEnabled:YES];
    [self.publishBtn setHidden:NO];
    [self.publishBtn setUserInteractionEnabled:YES];
}

//第二次点击图片后，使图片放大
- (void)zoomTap:(UITapGestureRecognizer *)gesture {
    CGRect unZoom = CGRectMake(15, 15, self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5);
    CGRect zoom = CGRectMake(0, self.view.frame.size.height / 2 - self.view.center.x, self.view.frame.size.width, self.view.frame.size.width);
//    当图为缩略图时，点击后放大
    if (CGRectEqualToRect(self.picImg.frame, unZoom)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.picImg.frame = zoom;
            self.view.backgroundColor = [UIColor blackColor];
//            隐藏介绍文本框和按钮（透明度为0）
            self.introText.alpha = 0;
            self.publishBtn.alpha = 0;
            self.deleteBtn.alpha= 0;
        }];
    }
//    当图为放大的状态时点击后变回原来的缩略图
    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.picImg.frame = unZoom;
            self.view.backgroundColor = [UIColor whiteColor];
//            显示回文本框和按钮
            self.introText.alpha = 1;
            self.publishBtn.alpha = 1;
            self.deleteBtn.alpha = 1;
        }];
    }
}

//设置图片、简介和上传按钮的位置
- (void)alignment {
    CGFloat width = self.view.frame.size.width;
    self.picImg.frame = CGRectMake(15, 15, width / 4.5, width / 4.5);
    self.introText.frame = CGRectMake(self.picImg.frame.size.width + 25, self.picImg.frame.origin.y, width - self.picImg.frame.size.width - 40, self.picImg.frame.size.height);
    self.publishBtn.frame = CGRectMake(0, self.view.frame.size.height - width / 8, width, width / 8);
//    设置button的title
    self.publishBtn.titleLabel.text = @"上传";
//    设置introText的边框
    self.introText.layer.borderWidth = 1;
    self.introText.layer.borderColor = [[UIColor grayColor] CGColor];
//    设置删除按钮的位置
    self.deleteBtn.frame = CGRectMake(self.picImg.frame.origin.x, self.picImg.frame.origin.y + self.picImg.frame.size.height, self.picImg.frame.size.width, 30);
}


/**
 publish method

 @param sender 点击按钮
 点击了上传按钮后上传内容到Posts上
*/
- (IBAction)publish:(UIButton *)sender {
    
//添加一条Post，并设置其用户名、头像、puuid和title
    AVObject* post = [AVObject objectWithClassName:@"Posts"];
    [post setObject:[AVUser currentUser].username forKey:@"username"];
    [post setObject:[[AVUser currentUser] objectForKey:@"ava"] forKey:@"ava"];
    NSString* puuid = [NSString stringWithFormat:@"%@ %@", [AVUser currentUser].username, [NSUUID UUID].UUIDString];
    [post setObject:puuid forKey:@"puuid"];
    
//当introText为空的时候，传送一个空格
    if (self.introText.text == nil) {
        [post setObject:@" " forKey:@"title"];
    }
    else {  //否则，传送的时候去除首位的空格和换行符
        NSString* title = [self.introText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [post setObject:title forKey:@"title"];
    }
//    上传图片
    NSData* imageData = UIImagePNGRepresentation(self.picImg.image);
    AVFile* imageFile = [AVFile fileWithData:imageData];
    [post setObject:imageFile forKey:@"pic"];
//    上传消息
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error == nil) {
//            上传成功后向通知中心发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploaded" object:nil];
//            返回主界面
            [self.tabBarController setSelectedIndex:0];
//            从新调用viewDidLoad方法，使得图片变回回来的默认图片
            [self viewDidLoad];
        }
    }];
    
//    监测hashtag内容，若有hashtag，则将相关内容上传
    NSString* message = self.introText.text;
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray<NSString *>* words = [message componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString* word in words) {
        NSString* pattern = @"#[^#]+";
        NSRegularExpression* regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray<NSTextCheckingResult *>* matches = [regular matchesInString:word options:NSMatchingReportProgress range:NSMakeRange(0, [word length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            NSString* hashTagWord = [word substringWithRange:matchRange];
            hashTagWord = [hashTagWord stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
            hashTagWord = [hashTagWord stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
            AVObject* hashTagOBj = [AVObject objectWithClassName:@"Hashtags"];
            [hashTagOBj setObject:[AVUser currentUser].username forKey:@"from"];
            [hashTagOBj setObject:puuid forKey:@"to"];
            [hashTagOBj setObject:hashTagWord forKey:@"hashtag"];
            [hashTagOBj setObject:self.introText.text forKey:@"comment"];
            [hashTagOBj saveEventually];
        }
    }
}
- (IBAction)deleteImg:(UIButton *)sender {
    self.picImg.image = [UIImage imageNamed:@"头像.png"];
    [self.publishBtn setUserInteractionEnabled:NO];
    [self.publishBtn setHidden:YES];
    [self.deleteBtn setUserInteractionEnabled:NO];
    [self.deleteBtn setHidden:YES];
//    从新加载点击事件，使得点击后能够选择图片 
    [self imgTap];
}
@end

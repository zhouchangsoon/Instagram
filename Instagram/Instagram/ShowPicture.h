//
//  ShowPicture.h
//  Instagram
//
//  Created by zcs on 2017/6/22.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface ShowPicture : UIViewController

@property (strong, nonatomic)AVFile* img;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end

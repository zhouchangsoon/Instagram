//
//  FeedVC.m
//  Instagram
//
//  Created by zcs on 2017/7/3.
//  Copyright © 2017年 周昌盛. All rights reserved.
//

#import "FeedVC.h"

@interface FeedVC ()

@end

@implementation FeedVC
{
//    存储云端的数据
    NSMutableArray<NSString *> *usernameArray;
    NSMutableArray<AVFile *> *avaImgArray;
    NSMutableArray<NSDate *> *dateArray;
    NSMutableArray<AVFile *> *picImgArray;
    NSMutableArray<NSString *> *titleArray;
    NSMutableArray<NSString *> *puuidArray;
//    首次加载帖子的数目
    int pages;
//    用户关注的人
    NSMutableArray<NSString *> *followArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    数据初始化
    [self initData];
//    设置导航栏
    self.navigationItem.title = @"聚合";
//    预估行高，加快加载速度
    [self.tableView setEstimatedRowHeight:450];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    下拉刷新
    self.refreasher = [[UIRefreshControl alloc] init];
    [self.refreasher addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.refreasher];
//    加载数据
    [self loadData];
//    监听喜爱信息是否改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"reloadData" object:nil];
//    监听是否有新的帖子
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploaded:) name:@"uploaded" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)uploaded:(NSNotification *)notification {
    [self loadData];
}

/**
 下拉到尽头加载更多的数据

 @param scrollView scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height) {
        [self loadmore];
    }
}

- (void)loadData {
//    首先查找用户关注的人并添加入followArray中
    [[AVUser currentUser] getFollowees:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil) {
            [followArray removeAllObjects];
            NSLog(@"测试一下收到用户名的个数: %lu", [objects count]);
            for (AVUser* object in objects) {
                [followArray addObject:[object objectForKey:@"username"]];
            }
            //            把自己也添加进去
            [followArray addObject:[AVUser currentUser].username];
            //            寻找这些人的所有帖子
            AVQuery* postQuery = [AVQuery queryWithClassName:@"Posts"];
            [postQuery whereKey:@"username" containedIn:followArray];
            [postQuery addAscendingOrder:@"createdAt"];
            [postQuery setLimit:pages];
            [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error == nil) {
                    [usernameArray removeAllObjects];
                    [avaImgArray removeAllObjects];
                    [titleArray removeAllObjects];
                    [picImgArray removeAllObjects];
                    [puuidArray removeAllObjects];
                    [dateArray removeAllObjects];
                    for (AVObject* object in objects) {
                        [usernameArray addObject:[object objectForKey:@"username"]];
                        [avaImgArray addObject:[object objectForKey:@"ava"]];
                        [picImgArray addObject:[object objectForKey:@"pic"]];
                        [titleArray addObject:[object objectForKey:@"title"]];
                        [puuidArray addObject:[object objectForKey:@"puuid"]];
                        [dateArray addObject:[object objectForKey:@"createdAt"]];
                    }
                    //                    停止刷新器并重新加载cell
                    [self.refreasher endRefreshing];
                    [self.tableView reloadData];
                }
                else {
                    [self alert:@"Alert" message:error.localizedDescription];
                }
            }];
        }
        else {
            [self alert:@"Alert" message:error.localizedDescription];
        }

    }];
}

- (void)loadmore {
    if (pages <= [picImgArray count]) {
        [self.indicator startAnimating];
        AVQuery* postQuery = [AVQuery queryWithClassName:@"Posts"];
        [postQuery whereKey:@"username" containedIn:followArray];
        [postQuery addAscendingOrder:@"createdAt"];
        [postQuery setSkip:pages];
        [postQuery setLimit:12];
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (error == nil) {
                for (AVObject* object in objects) {
                    [usernameArray addObject:[object objectForKey:@"username"]];
                    [avaImgArray addObject:[object objectForKey:@"ava"]];
                    [picImgArray addObject:[object objectForKey:@"pic"]];
                    [titleArray addObject:[object objectForKey:@"title"]];
                    [puuidArray addObject:[object objectForKey:@"puuid"]];
                    [dateArray addObject:[object objectForKey:@"createdAt"]];
                }
//                    重新加载cell
                [self.indicator stopAnimating];
                [self.tableView reloadData];
            }
            else {
                [self alert:@"Alert" message:error.localizedDescription];
            }
        }];
        pages += 12;
    }
}

/**
 初始化数据
 */
- (void)initData {
    usernameArray = [[NSMutableArray alloc] init];
    avaImgArray = [[NSMutableArray alloc] init];
    dateArray = [[NSMutableArray alloc] init];
    picImgArray = [[NSMutableArray alloc] init];
    titleArray = [[NSMutableArray alloc] init];
    puuidArray = [[NSMutableArray alloc] init];
    
    pages = 6;
    
    followArray = [[NSMutableArray alloc] init];
}


/**
 显示警告信息

 @param title 警告标题
 @param message 警告信息
 */
- (void)alert:(NSString *)title message:(NSString *)message {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [picImgArray count];
}


/**
 设置tablecell样式

 @param tableView tableView
 @param indexPath indexPath
 @return return PostCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //    加载头像
    [[avaImgArray objectAtIndex:indexPath.row] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error == nil) {
            cell.avaImg.image = [UIImage imageWithData:data];
        }
        else {
            [self alert:@"警告" message:error.localizedDescription];
        }
    }];
    //    加载用户名
    [cell.usernameBtn setTitle:[usernameArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    NSLog(@"输出用户名:%@", cell.usernameBtn.titleLabel.text);
    //    加载帖子发布了多久
    NSDate* from = [dateArray objectAtIndex:indexPath.row];
    NSDate* to = [NSDate date];
    NSCalendarUnit unit = NSCalendarUnitWeekOfMonth | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [calendar components:unit fromDate:from toDate:to options:0];
    NSLog(@"相隔时间输出:WeakOfMonth:%ld, Day:%ld, Hour:%ld, Minute:%ld, Second:%ld", (long)dateComponents.day, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second);
    if (dateComponents.weekOfMonth > 0) {
        cell.dateLbl.text = [NSString stringWithFormat:@"%ld周", dateComponents.weekOfMonth];
    }
    else if (dateComponents.day > 0) {
        cell.dateLbl.text = [NSString stringWithFormat:@"%ld天", dateComponents.day];
    }
    else if (dateComponents.hour > 0) {
        cell.dateLbl.text = [NSString stringWithFormat:@"%ld小时", dateComponents.hour];
    }
    else if (dateComponents.minute > 0) {
        cell.dateLbl.text = [NSString stringWithFormat:@"%ld分钟", dateComponents.minute];
    }
    else if (dateComponents.second > 0) {
        cell.dateLbl.text = [NSString stringWithFormat:@"%ld秒", dateComponents.second];
    }
    else {
        cell.dateLbl.text = @"现在";
    }
    //    加载图片
    [[picImgArray objectAtIndex:indexPath.row] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error == nil) {
            cell.picImg.image = [UIImage imageWithData:data];
        }
        else {
            [self alert:@"警告" message:error.localizedDescription];
        }
    }];
    //    加载标题
    cell.titleLbl.text = [titleArray objectAtIndex:indexPath.row];
    //    加载puuid
    cell.puuidLbl.text = [puuidArray objectAtIndex:indexPath.row];
    //    动态调整usernameBtn和titleLbl的大小
    [cell.usernameBtn sizeToFit];
    [cell.titleLbl sizeToFit];
    //    根据用户是否喜爱来维护likeBtn按钮
    AVQuery* didLike = [AVQuery queryWithClassName:@"Likes"];
    [didLike whereKey:@"from" equalTo:[AVUser currentUser].username];
    [didLike whereKey:@"to" equalTo:cell.puuidLbl.text];
    [didLike countObjectsInBackgroundWithBlock:^(NSInteger number, NSError * _Nullable error) {
        if (error == nil) {
            if (number > 0) {
                [cell.likeBtn setTitle:@"like" forState:UIControlStateNormal];
                [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"love.png"] forState:UIControlStateNormal];
            }
            else {
                [cell.likeBtn setTitle:@"dislike" forState:UIControlStateNormal];
                [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"dislike.png"] forState:UIControlStateNormal];
            }
        }
        else {
            [self alert:@"警告" message:error.localizedDescription];
        }
    }];
    //    统计喜爱总数
    AVQuery* likesQuery = [AVQuery queryWithClassName:@"Likes"];
    [likesQuery whereKey:@"to" equalTo:cell.puuidLbl.text];
    [likesQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError * _Nullable error) {
        if (error == nil) {
            cell.likeLbl.text = [NSString stringWithFormat:@"%ld", (long)number];
        }
        else {
            [self alert:@"警告" message:error.localizedDescription];
        }
    }];
    //    当用户点击@的内容的时候
    [cell.titleLbl setUserHandleLinkTapHandler:^(KILabel *label, NSString *string, NSRange range) {
        //        去除@，取@里面的内容
        NSString* message = [string substringFromIndex:1];
        //        如果是当前用户本人，则跳到主页
        if ([message isEqualToString:[AVUser currentUser].username]) {
            HomeVC* home = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
            [self.navigationController pushViewController:home animated:YES];
        }
        else {
            AVQuery* userQuery = [AVUser query];
            [userQuery whereKey:@"username" equalTo:message];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error == nil && [objects count] > 0) {
                    GuestVC* guestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestVC"];
                    guestVC.user = [objects lastObject];
                    guestVC.username = [[objects lastObject] objectForKey:@"username"];
                }
                else if (error){
                    [self alert:@"Alert" message:error.localizedDescription];
                }
                else {
                    [self alert:@"提示" message:[NSString stringWithFormat:@"小编用尽洪荒之力都没有发现%@用户存在", message]];
                }
            }];
        }
    }];
    //    当用户点击hashtag内容时，跳转到所有有关hashtag的内容页面
    [cell.titleLbl setHashtagLinkTapHandler:^(KILabel* label, NSString* string, NSRange range) {
        HashtagsVC* hashtagsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HashtagsVC"];
        hashtagsVC.hashtag = [string substringFromIndex:1];
        [self.navigationController pushViewController:hashtagsVC animated:YES];
    }];
    //    设置userNameBtn的layer名字
    [cell.usernameBtn.layer setValue:indexPath forKey:@"index"];
    //    设置commentBtn的layer名字
    [cell.commentBtn.layer setValue:indexPath forKey:@"index"];
    //    设置moreBtn的layer名字
    [cell.moreBtn.layer setValue:indexPath forKey:@"index"];
    return cell;
}


- (IBAction)moreBtn_clicked:(UIButton *)sender {
    NSIndexPath* index = [sender.layer valueForKey:@"index"];
    PostCell* cell = [self.tableView cellForRowAtIndexPath:index];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"选项" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //    删除选项
    UIAlertAction* delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //        删除相应的帖子
        AVQuery* postQuery = [AVQuery queryWithClassName:@"Posts"];
        [postQuery whereKey:@"puuid" equalTo:cell.puuidLbl.text];
        [postQuery deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [self alert:@"Alert" message:error.localizedDescription];
            }
            else {
                //        通知主界面更新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"uploaded" object:nil];
                //        退到上一级
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        //        删除相应的评论
        AVQuery* commentQuery = [AVQuery queryWithClassName:@"Comments"];
        [commentQuery whereKey:@"to" equalTo:cell.puuidLbl.text];
        [commentQuery deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [self alert:@"Alert" message:error.localizedDescription];
            }
        }];
        //        删除相应的喜欢
        AVQuery* likeQuery = [AVQuery queryWithClassName:@"Likes"];
        [likeQuery whereKey:@"to" equalTo:cell.puuidLbl.text];
        [likeQuery deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [self alert:@"Alert" message:error.localizedDescription];
            }
        }];
        //        删除相应的Hashtag
        AVQuery* hashtagQuery = [AVQuery queryWithClassName:@"Hashtags"];
        [hashtagQuery whereKey:@"to" equalTo:cell.puuidLbl.text];
        [hashtagQuery deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [self alert:@"Alert" message:error.localizedDescription];
            }
        }];
        //        删除相应的投诉
        AVQuery* complainQuery = [AVQuery queryWithClassName:@"Complains"];
        [complainQuery whereKey:@"post" equalTo:cell.puuidLbl.text];
        [complainQuery deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [self alert:@"Alert" message:error.localizedDescription];
            }
        }];
        //        删除相应的数据
        [avaImgArray removeObjectAtIndex:index.row];
        [usernameArray removeObjectAtIndex:index.row];
        [dateArray removeObjectAtIndex:index.row];
        [picImgArray removeObjectAtIndex:index.row];
        [puuidArray removeObjectAtIndex:index.row];
        [titleArray removeObjectAtIndex:index.row];
    }];
    //    投诉选项
    UIAlertAction* complain = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        先查询是否存在相同的投诉
        AVQuery* complainQuery = [AVQuery queryWithClassName:@"Complains"];
        [complainQuery whereKey:@"post" equalTo:cell.puuidLbl.text];
        [complainQuery whereKey:@"by" equalTo:[AVUser currentUser].username];
        [complainQuery whereKey:@"owner" equalTo:[cell.usernameBtn titleForState:UIControlStateNormal]];
        [complainQuery whereKey:@"to" equalTo:cell.titleLbl.text];
        [complainQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError * _Nullable error) {
            if (error == nil) {
                //                若存在相同的投诉
                if (number > 0) {
                    [self alert:@"提示" message:@"你已经投诉过了"];
                }
                //                若不存在相同的投诉，则添加此投诉
                else {
                    AVObject* complianObject = [AVObject objectWithClassName:@"Complains"];
                    [complianObject setObject:cell.puuidLbl.text forKey:@"post"];
                    [complianObject setObject:[AVUser currentUser].username forKey:@"by"];
                    [complianObject setObject:[cell.usernameBtn titleForState:UIControlStateNormal]  forKey:@"owner"];
                    [complianObject setObject:cell.titleLbl.text forKey:@"to"];
                    [complianObject saveInBackground];
                    [self alert:@"提示" message:@"您的投诉已被处理"];
                }
            }
            else {
                [self alert:@"Alert" message:error.localizedDescription];
            }
        }];
    }];
    //    取消按钮
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    if ([[AVUser currentUser].username isEqualToString:[cell.usernameBtn titleForState:UIControlStateNormal]]) {
        [alertController addAction:delete];
        [alertController addAction:cancle];
    }
    else {
        [alertController addAction:complain];
        [alertController addAction:cancle];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)usernameBtn_clicked:(UIButton *)sender {
    NSIndexPath* path = [sender.layer valueForKey:@"index"];
    PostCell* cell = [self.tableView cellForRowAtIndexPath:path];
    if ([[cell.usernameBtn titleForState:UIControlStateNormal] isEqualToString:[AVUser currentUser].username]) {
        HomeVC* home = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        [self.navigationController pushViewController:home animated:YES];
    }
    else {
        GuestVC* guest = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestVC"];
        [self.navigationController pushViewController:guest animated:YES];
    }
}

- (IBAction)commentBtn_clicked:(UIButton *)sender {
    NSIndexPath* path = [sender.layer valueForKey:@"index"];
    PostCell* cell = [self.tableView cellForRowAtIndexPath:path];
    CommentVC* comment = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentVC"];
    comment.commentUuid = cell.puuidLbl.text;
    comment.commentOwner = [cell.usernameBtn titleForState:UIControlStateNormal];
    [comment feedInitData];
    comment.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comment animated:YES];
}
@end

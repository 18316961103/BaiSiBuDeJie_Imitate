//
//  FriendTrendsViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "FriendTrendsViewController.h"
#import "LoginViewController.h"

@interface FriendTrendsViewController ()

@end

@implementation FriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 设置导航条
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    
    // 设置导航条左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highlightImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecommentClick)];
    // 设置导航条标题
    self.navigationItem.title = @"我的关注";;
    
}

#pragma mark - 点击立即登陆注册
- (IBAction)loginClick:(UIButton *)sender {
    
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    
    [self presentViewController:loginVc animated:YES completion:nil];
    
}

#pragma mark - 导航条左边按钮的点击
- (void)friendsRecommentClick {
    
    WYFunc;
    
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

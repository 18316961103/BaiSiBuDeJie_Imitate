//
//  AdViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "AdViewController.h"
#import "TabBarController.h"
#import "AdItem.h"

#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface AdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *adPlaceView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
/**    广告的数据模型    */
@property (strong, nonatomic) AdItem *item;
/**    显示广告的ImageView    */
@property (strong, nonatomic) UIImageView *adImageView;
/**    定时器，用来倒数广告时间    */
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置启动图片
    [self setupLaunchImage];
    
    // 请求广告数据
    [self loadData];
    
    // 创建定时器，倒数广告时间
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
}

#pragma mark - 倒数
- (void)timeChange {
    
    static int i = 5;
    
    if (i == 0) {
        // 当倒数完毕的时候,跳转到首页
        [self jumpClick:self.jumpBtn];
    }
    
    i--;
    
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳转 (%d)",i] forState:UIControlStateNormal];
    
}

- (UIImageView *)adImageView {
    
    if (_adImageView == nil) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.adPlaceView addSubview:imageView];
        // 添加点击手势，跳转广告
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        
        [imageView addGestureRecognizer:tap];
        
        // 允许用户点击，以便跳转广告
        imageView.userInteractionEnabled = YES;
        
        _adImageView = imageView;
        
    }
    
    return _adImageView;
}

#pragma mark - 点击广告跳转
- (void)tapClick {
    
    // 先判断URL是否可以跳转
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_item.ori_curl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_item.ori_curl] options:nil completionHandler:nil];
    }
    
}

#pragma mark - 设置启动图片
- (void)setupLaunchImage {
    
    if (iPhone6p) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    } else if (iPhone6) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (iPhone5) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h"];
    } else if (iPhone4) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-700"];
    }
    
}

#pragma mark - 请求广告数据
- (void)loadData {
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"code2"] = code2;
    
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dataDict = (NSDictionary *)responseObject;
        
        _item = [AdItem mj_objectWithKeyValues:[dataDict[@"ad"] lastObject]];
        
        // 将图片按比例拉伸
        CGFloat adH = kScreenW / _item.w * _item.h;
        
        self.adImageView.frame = CGRectMake(0, 0, kScreenW, adH);
        
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:_item.w_picurl]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WYLog(@"%@",error);
    }];
    
}

#pragma mark - 跳过广告
- (IBAction)jumpClick:(UIButton *)sender {
    
    TabBarController *tabBarC = [[TabBarController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarC;
    
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

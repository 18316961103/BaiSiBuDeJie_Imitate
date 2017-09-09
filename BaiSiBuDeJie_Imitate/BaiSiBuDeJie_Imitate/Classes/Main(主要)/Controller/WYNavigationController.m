//
//  WYNavigationController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "WYNavigationController.h"

@interface WYNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation WYNavigationController

+ (void)load {
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    // 通过富文本设置标题大小
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    
    [navBar setTitleTextAttributes:dict];
    
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 直接设置代理为自己只能解决边缘滑动返回不了的问题，但是最好的效果的是可以全屏滑动返回，所以使用下面的方法
//    self.interactivePopGestureRecognizer.delegate = self;
    
    // 自定义手势替换系统的边缘手势滑动返回，达到全屏滑动返回的效果
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    // 控制手势什么时候触发，只有非根控制器才能触发手势
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    // 禁止系统的边缘手势返回
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 只有非根控制器才有手势返回的功能，否则会造成程序假死
    return self.childViewControllers.count > 1;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) { // 排除根控制器
        // 统一设置返回按钮，非根控制器
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highlightImage:[UIImage imageNamed:@"navigationButtonReturnClick"]  target:self action:@selector(backClick) title:@"返回"];
    }
    
    [super pushViewController:viewController animated:animated];
    
}

#pragma mark - 返回按钮的点击
- (void)backClick {
    
    [self popViewControllerAnimated:YES];
    
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

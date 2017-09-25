//
//  EssenseViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "EssenseViewController.h"
#import "AllTableViewController.h"
#import "VideoTableViewController.h"
#import "PictureTableViewController.h"
#import "VoiceTableViewController.h"
#import "WordTableViewController.h"

@interface EssenseViewController () <UIScrollViewDelegate>

/**    存放子控制器的scrollView    */
@property (strong, nonatomic) UIScrollView *scrollView;
/**    标题栏    */
@property (strong, nonatomic) UIView *titleView;

/**    上次点击的按钮    */
@property (strong, nonatomic) UIButton *previousClickButton;

/**    标题按钮的下划线    */
@property (strong, nonatomic) UIView *titleButtonUnderLine;

@end

@implementation EssenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = Color(234, 234, 234);
    
    // 设置导航条
    [self setupNavBar];
    // 添加子控制器
    [self setupChildVc];
    // 添加scrollView
    [self setupScrollView];
    // 添加标题栏
    [self setupTitleView];
}

#pragma mark - 添加子控制器
- (void)setupChildVc{
    
    [self addChildViewController:[[AllTableViewController alloc] init]];
    [self addChildViewController:[[VideoTableViewController alloc] init]];
    [self addChildViewController:[[VoiceTableViewController alloc] init]];
    [self addChildViewController:[[PictureTableViewController alloc] init]];
    [self addChildViewController:[[WordTableViewController alloc] init]];

}

#pragma mark - 设置导航条
- (void)setupNavBar {
    
    // 设置导航条左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highlightImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(gameClick)];
    // 设置导航条右边的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highlightImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:self action:@selector(randomClick)];
    // 设置导航条标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

#pragma mark - 导航条左边按钮的点击
- (void)gameClick {
    
    WYFunc;
    
}

#pragma mark - 导航条右边按钮的点击
- (void)randomClick {
    // 刷新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:TitleButtonDidRepeatClickNotificationName object:nil];

    
    WYFunc;
    
}

#pragma mark - 设置scrollView
- (void)setupScrollView {
    // 禁止系统为scrollView添加额外的上边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    scrollView.backgroundColor = Color(234, 234, 234);
    // 设置分页
    scrollView.pagingEnabled = YES;
    // 隐藏垂直滚动条
    scrollView.showsVerticalScrollIndicator = NO;
    // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    scrollView.delegate = self;
    // 当点击状态栏的时候，禁止scrollView滑动到顶部
    scrollView.scrollsToTop = NO;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    NSInteger count = self.childViewControllers.count;
//    
//    CGFloat childViewW = scrollView.width;
//    CGFloat childViewH = scrollView.height;
//    
//    for (NSInteger i = 0; i < count; i++) {
//        
//        UIView *childV = self.childViewControllers[i].view;
//        
//        childV.frame = CGRectMake(i * childViewW, 0, childViewW, childViewH);
//
//        [scrollView addSubview:childV];
//    }
    
    scrollView.contentSize = CGSizeMake(count * scrollView.width, 0);
}

#pragma mark - 设置标题栏
- (void)setupTitleView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, NavMaxY, kScreenW, TitleViewH)];
    
    self.titleView = titleView;
    
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:titleView];
    
    // 设置标题按钮
    [self setupTitleButton];
    // 添加标题按钮的下划线
    [self setupTitleBtnUnderLine];
    
    // 默认开始点击第一个标题
    UIButton *button = self.titleView.subviews[0];

    [self titleButtonClick:button];
}

#pragma mark - 添加标题按钮
- (void)setupTitleButton {
    
    NSArray *titleArray = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    
    NSInteger count = titleArray.count;
    
    CGFloat buttonW = kScreenW / count;
    CGFloat buttonH = self.titleView.height;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(i * buttonW , 0, buttonW, buttonH);
        
        button.tag = i;
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:button];
    }
    
}

#pragma mark - 添加标题下划线
- (void)setupTitleBtnUnderLine {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView.height - 1.5, 50, 1.5)];
    
    line.backgroundColor = [UIColor redColor];
    
    self.titleButtonUnderLine = line;
    
    [self.titleView addSubview:line];
    
}

#pragma mark - 标题的点击事件
- (void)titleButtonClick:(UIButton *)sender {
    // 重复点击标题的时候，执行刷新当前页面的操作，发送通知
    if (self.previousClickButton == sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TitleButtonDidRepeatClickNotificationName object:nil];
    }
    
    [self titleButtonClickWhenScroll:sender];
    
}

#pragma mark - 处理滑动时调用的点击标题按钮事件
- (void)titleButtonClickWhenScroll:(UIButton *)sender {
    
    self.previousClickButton.selected = NO;
    sender.selected = YES;
    self.previousClickButton = sender;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        // 设置下划线平移
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = sender.titleLabel.font;
        // 获取按钮标题的宽度
        CGFloat buttonwidth = [sender.currentTitle sizeWithAttributes:attr].width;
        // 下划线宽度比按钮标题的宽度宽一点，有点突出感
        self.titleButtonUnderLine.width = buttonwidth + 10;
        
        self.titleButtonUnderLine.centerX = sender.centerX;
        
        // 设置scrollView平移
        self.scrollView.contentOffset = CGPointMake(sender.tag * self.scrollView.width, self.scrollView.contentOffset.y);
        
    } completion:^(BOOL finished) {
        
        UIView *childView = self.childViewControllers[sender.tag].view;
        
        childView.frame = CGRectMake(sender.tag * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
        
        [self.scrollView addSubview:childView];
        
    }];
    
    // 当点击状态栏的时候，把当前显示的tableView滑动到顶部，只要设置scrollView的scrollsToTop为yes即可，但前提是只有一个scrollView设置为yes，其他都设置为no
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        UIViewController *childVc = self.childViewControllers[i];
        // 如果控制器的View还没加载，则不需要处理
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        // 如果控制器的View不是scrollView也不需要处理
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        scrollView.scrollsToTop = (i == sender.tag);
        
    }
    
}

#pragma mark - UIScrollViewDelegate
// scrollView滑动结束时会调用该方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 找到偏移后的按钮的索引
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    
    UIButton *button = self.titleView.subviews[index];
    
    [self titleButtonClickWhenScroll:button];
    
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

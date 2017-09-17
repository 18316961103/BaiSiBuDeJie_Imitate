//
//  TabBarController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TabBarController.h"
#import "EssenseViewController.h"
#import "FriendTrendsViewController.h"
#import "MeTableViewController.h"
#import "NewViewController.h"
#import "PublishViewController.h"
#import "TabBar.h"
#import "BaiSiBuDeJie.pch"
#import "WYNavigationController.h"

@interface TabBarController ()

@end

@implementation TabBarController

+ (void)load {
    
    // 获取整个应用下的UITabBarItem
//    UITabBarItem *tabbarItem = [UITabBarItem appearance];
    
    // 获取指定类的UITabBarItem
    UITabBarItem *tabbarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    // 创建一个描述颜色属性的字典
    NSMutableDictionary *colorDict = [[NSMutableDictionary alloc] init];
    colorDict[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    [tabbarItem setTitleTextAttributes:colorDict forState:UIControlStateSelected];
    
    // 设置字体大小：只有设置正常状态下的字体，才会生效
    // 创建一个描述字体大小属性的字典
    NSMutableDictionary *fontDict = [[NSMutableDictionary alloc] init];
    fontDict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    [tabbarItem setTitleTextAttributes:fontDict forState:UIControlStateNormal];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1设置子控制器
    [self setupAllChildControllers];
    
    // 设置对应的tabarItem
    [self setupAllTabbarItem];
    
    // 自定义tabBar
    [self setupTabBar];
    
}

#pragma mark - 自定义tabBar
- (void)setupTabBar {
    
    TabBar *tabBar = [[TabBar alloc] init];
    // 使用KVC强制赋值，因为系统的tabBar属性是readOnly
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}

#pragma mark - 添加子控制器
- (void)setupAllChildControllers {
    // 精华
    EssenseViewController *essenseVc = [[EssenseViewController alloc] init];
    
    WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:essenseVc];
    
    [self addChildViewController:nav];
    // 新帖
    NewViewController *newVc = [[NewViewController alloc] init];
    
    WYNavigationController *nav1 = [[WYNavigationController alloc] initWithRootViewController:newVc];
    
    [self addChildViewController:nav1];
    // 发布
//    PublishViewController *publishVc = [[PublishViewController alloc] init];
//    
//    [self addChildViewController:publishVc];
    // 关注
    FriendTrendsViewController *friendTrendsVc = [[FriendTrendsViewController alloc] init];
    
    WYNavigationController *nav3 = [[WYNavigationController alloc] initWithRootViewController:friendTrendsVc];
    
    [self addChildViewController:nav3];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([MeTableViewController class]) bundle:nil];
    // 我
    MeTableViewController *meTableVc = [storyBoard instantiateInitialViewController];
    
    WYNavigationController *nav4 = [[WYNavigationController alloc] initWithRootViewController:meTableVc];
    
    [self addChildViewController:nav4];
}

#pragma mark - 设置对应的tabbarItem
- (void)setupAllTabbarItem {
    // 精华
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_essence_click_icon"];
    
    // 新帖
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_new_click_icon"];
//    // 发布
//    PublishViewController *publishVc = self.childViewControllers[2];
//    publishVc.tabBarItem.image = [UIImage imageOriginalWithNamed:@"tabBar_publish_icon"];
//    publishVc.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_publish_click_icon"];
    // 设置图片位置
//    publishVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    // 关注
    UINavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_friendTrends_click_icon"];
    // 我
    UINavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_me_click_icon"];
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

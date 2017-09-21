//
//  TabBar.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TabBar.h"

@interface TabBar ()

/**    发布按钮    */
@property (strong, nonatomic) UIButton *publishBtn;

@end

@implementation TabBar

- (UIButton *)publishBtn {
    
    if (_publishBtn == nil) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        [button sizeToFit];
        
        [self addSubview:button];
        
        _publishBtn = button;
        
    }
    
    return _publishBtn;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
        
    CGFloat tabBarButtonX = 0;
    CGFloat tabBarButtonW = self.frame.size.width / (self.items.count + 1);
    CGFloat tabBarButtonH = self.frame.size.height;

    NSInteger index = 0;
    
    for (UIControl *tabBarButton in self.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 刚开始的时候，默认把第0个tabBarButton赋值给previousTabBarButton，而且赋值一次就够了
            if (index == 0 && self.previousTabBarButton == nil) {
                self.previousTabBarButton = tabBarButton;
            }
            
            if (index == 2) {
                index += 1;
            }
            
            tabBarButtonX = index * tabBarButtonW;
            
            tabBarButton.frame = CGRectMake(tabBarButtonX, 0, tabBarButtonW, tabBarButtonH);
            
            index++;
            
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    self.publishBtn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}

#pragma mark - tabBarButton的点击事件,主要是为了当重复点击的时候，刷新当前页面
- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    
    if (self.previousTabBarButton == tabBarButton) {
        // 发出通知，让对应的控制器刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:WYTabBarDidRepeatClickNotificationName object:nil];
    }
    
    self.previousTabBarButton = tabBarButton;
}

@end

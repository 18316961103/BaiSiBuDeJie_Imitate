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
    
    for (UIView *tabBarButton in self.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            if (index == 2) {
                index += 1;
            }
            
            tabBarButtonX = index * tabBarButtonW;
            
            tabBarButton.frame = CGRectMake(tabBarButtonX, 0, tabBarButtonW, tabBarButtonH);
            
            index++;
            
        }
    }
    
    self.publishBtn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}

@end

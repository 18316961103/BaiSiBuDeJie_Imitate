//
//  UIBarButtonItem+Item.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    // 设置内容自适应
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:button.bounds];
    
    [containerView addSubview:button];
    // 直接把UIButton包装成UIBarButtonItem会导致点击区域扩大，所以需要将UIButton先经过UIView包装。
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    // 设置内容自适应
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:button.bounds];
    
    [containerView addSubview:button];
    // 直接把UIButton包装成UIBarButtonItem会导致点击区域扩大，所以需要将UIButton先经过UIView包装。
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action title:(NSString *)title {
    
    // 设置返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImage:highlightImage forState:UIControlStateHighlighted];
    
    [backBtn setTitle:title forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    // 让按钮左移
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn sizeToFit];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    return barButtonItem;
}

@end

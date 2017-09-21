//
//  UIView+Frame.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setWidth:(CGFloat)width {
    
    CGRect rect = self.frame;
    
    rect.size.width = width;
    
    self.frame = rect;
    
}

- (CGFloat)width {
   
    return self.frame.size.width;

}

- (void)setHeight:(CGFloat)height {
    
    CGRect rect = self.frame;
    
    rect.size.height = height;
    
    self.frame = rect;
    
}

- (CGFloat)height {
    
    return self.frame.size.height;
    
}

- (void)setX:(CGFloat)x {
    
    CGRect rect = self.frame;
    
    rect.origin.x = x;
    
    self.frame = rect;
    
}

- (CGFloat)x {
    
    return self.frame.origin.x;
    
}

- (void)setY:(CGFloat)y {
    
    CGRect rect = self.frame;
    
    rect.origin.y = y;
    
    self.frame = rect;
    
}

- (CGFloat)y {
    
    return self.frame.origin.y;
    
}

- (void)setSize:(CGSize)size {
    
    CGRect rect = self.frame;
    
    rect.size = size;
    
    self.frame = rect;
    
}

- (CGSize)size {
    
    return self.frame.size;
    
}

- (void)setPoint:(CGPoint)point {
    
    CGRect rect = self.frame;
    
    rect.origin = point;
    
    self.frame = rect;
    
}

- (CGPoint)point {
    
    return self.frame.origin;
    
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    
    center.x = centerX;
    
    self.center = center;
    
}

- (CGFloat)centerX {
    
    return self.center.x;
    
}

- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint center = self.center;
    
    center.y = centerY;
    
    self.center = center;
    
}

- (CGFloat)centerY {
    
    return self.center.y;

}


/**
 * 从xib加载UIView
 */
+ (instancetype)loadViewFromXib {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
}

@end

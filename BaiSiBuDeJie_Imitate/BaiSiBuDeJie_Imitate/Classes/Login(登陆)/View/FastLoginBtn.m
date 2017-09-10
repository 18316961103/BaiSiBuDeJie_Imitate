//
//  FastLoginBtn.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/10.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "FastLoginBtn.h"

@implementation FastLoginBtn

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 先设置内容自适应，然后再设置位置，如果先设置位置再设置内容自适应，会有问题，标题会偏移
    [self.titleLabel sizeToFit];

    self.titleLabel.y = self.height - self.titleLabel.height;
    self.titleLabel.centerX = self.width * 0.5;
    
}
@end

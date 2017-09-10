//
//  FastLoginView.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/10.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "FastLoginView.h"

@implementation FastLoginView

+ (instancetype)fastLoginView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    
}

@end

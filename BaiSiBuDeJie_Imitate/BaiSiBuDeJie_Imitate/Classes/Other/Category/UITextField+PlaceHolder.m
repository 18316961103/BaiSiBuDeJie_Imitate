//
//  UITextField+PlaceHolder.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/16.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "UITextField+PlaceHolder.h"
#import <objc/message.h>

@implementation UITextField (PlaceHolder)

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeHolderColor;
    
}

- (UIColor *)placeHolderColor {
    return nil;
}

@end

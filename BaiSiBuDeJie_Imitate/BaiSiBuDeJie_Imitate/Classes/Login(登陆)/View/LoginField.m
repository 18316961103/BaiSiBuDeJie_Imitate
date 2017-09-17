//
//  LoginField.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/16.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "LoginField.h"
#import "UITextField+PlaceHolder.h"

@implementation LoginField

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 设置光标的颜色为白色
    self.tintColor = [UIColor whiteColor];
    
    // 监听文本框编辑
    // 开始编辑时调用
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    // 结束编辑时调用
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    // 设置占位文字默认灰色
    // 方法一：通过KVC或者使用runtime拿到占位文字的label，直接设置颜色
//    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
//    placeholderLabel.textColor = [UIColor lightGrayColor];
    // 方法二：通过富文本属性设置
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    // 方法三：封装方法一
    self.placeHolderColor = [UIColor lightGrayColor];
}

#pragma mark - 文本框开始编辑时调用
- (void)textBegin {
    // 开始编辑时，占位文字变白色
    // 方法一：通过KVC或者使用runtime拿到占位文字的label，直接设置颜色
//    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
//    placeholderLabel.textColor = [UIColor whiteColor];
    // 方法二：通过富文本属性设置
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    // 方法三：封装方法一
    self.placeHolderColor = [UIColor whiteColor];
    
}

#pragma mark - 文本框结束编辑时调用
- (void)textEnd {
    // 结束编辑时，占位文字变灰色
    // 方法一：通过KVC或者使用runtime拿到占位文字的label，直接设置颜色
//    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
//    placeholderLabel.textColor = [UIColor lightGrayColor];
    // 方法二：通过富文本属性设置
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    // 方法三：封装方法一
    self.placeHolderColor = [UIColor lightGrayColor];
    
}

@end

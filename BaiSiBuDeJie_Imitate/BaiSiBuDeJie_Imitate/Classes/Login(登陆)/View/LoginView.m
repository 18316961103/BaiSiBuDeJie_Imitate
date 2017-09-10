//
//  LoginView.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/10.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation LoginView

+ (instancetype)loginView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    
}

+ (instancetype)registerView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];

}

- (void)awakeFromNib {
    // 获取登陆按钮的背景图片
//    UIImage *backgroundImage = _loginBtn.currentBackgroundImage;
    UIImage *backgroundImage = [UIImage imageNamed:@"login_register_button"];

    // 设置图片不被拉伸
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width * 0.5 topCapHeight:backgroundImage.size.height * 0.5];
    
    [_loginBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [_loginBtn setBackgroundImage:[[UIImage imageNamed:@"login_register_button_click"] stretchableImageWithLeftCapWidth:backgroundImage.size.width * 0.5 topCapHeight:backgroundImage.size.height * 0.5] forState:UIControlStateHighlighted];;
}

@end

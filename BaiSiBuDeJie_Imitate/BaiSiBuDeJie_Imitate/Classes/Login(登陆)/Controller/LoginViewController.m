//
//  LoginViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/10.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "FastLoginView.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadConstrains;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
        发现Xcode8对xib和storyboard做出了一些修改，似的在awakeFromNib和viewDidLoad方法中拿自己拖上去的控件的frame均变成了(0, 0, 1000, 1000)，若直接在此使用控件frame进行二次修改，如：修改A控件的宽为B控件的一半，则B控件实际当前的宽是1000，就会造成混乱。解决办法是在使用原控件frame之前调一次layoutIfNeeded方法。
     */
    [self.middleView layoutIfNeeded];
    
    // 创建登陆框
    LoginView *loginView = [LoginView loginView];
    
    loginView.frame = CGRectMake(0, 0, self.middleView.width * 0.5, self.middleView.height);
    
    [self.middleView addSubview:loginView];
    // 创建注册框
    LoginView *registerView = [LoginView registerView];

    [self.middleView addSubview:registerView];
    
    // 创建快速登陆view
    FastLoginView *fastLoginView = [FastLoginView fastLoginView];
    
    [self.bottomView addSubview:fastLoginView];
    
}

#pragma mark - 点击关闭按钮
- (IBAction)closeClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 点击注册账号按钮
- (IBAction)registerClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    // 左滑的效果不能通过修改frame实现，因为设置了约束，如果设置了约束，那就一定是改约束，否则会有问题
    _leadConstrains.constant = _leadConstrains.constant == 0 ? -self.middleView.width * 0.5:0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - 根据布局调整控件的尺寸
- (void)viewDidLayoutSubviews {
    // 设置登陆框的frame
    LoginView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.width * 0.5, self.middleView.height);
    
    // 设置注册框的frame
    LoginView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.width * 0.5, 0, self.middleView.width * 0.5, self.middleView.height);

    // 设置快速登陆view的frame
    FastLoginView *fastLoginView = self.bottomView.subviews[0];
    fastLoginView.frame = self.bottomView.bounds;
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

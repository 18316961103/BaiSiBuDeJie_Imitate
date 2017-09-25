//
//  TopicPictureView.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/21.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicPictureView.h"
#import "TopicItem.h"
#import "SeeBigPictureViewController.h"

@interface TopicPictureView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;


@end

@implementation TopicPictureView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)];
    
    [self.imageView addGestureRecognizer:tap];
}
#pragma mark - 点击查看大图
- (IBAction)seeBigButtonClick:(UIButton *)sender {
    
    [self seeBigPicture];
    
}

#pragma mark - 点击查看大图
- (void)seeBigPicture {
    
    SeeBigPictureViewController *seeBigPictureVc = [[SeeBigPictureViewController alloc] init];
    
    seeBigPictureVc.topicItem = self.item;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBigPictureVc animated:YES completion:nil];
    
}

- (void)setItem:(TopicItem *)item {
    
    _item = item;
    
    self.imageView.image = nil;
    
    // 根据网络状态加载相应的图片
    [self.imageView setOriginImage:_item.image1 thumbnailImage:_item.image0 placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 如果下载失败，直接return
        if (image == nil) return ;
        
        if (_item.bigPicture) { // 主要是为了防止图片不够大或者太大的情况，下面主要是为了将图片等比例缩放
            
            CGFloat imageW = _item.middleFrame.size.width;
            CGFloat imageH = imageW * _item.height / _item.width;
            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            // 获取图片
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
            
        }
        
    }];
    
    self.gifImageView.hidden = !_item.is_gif;
        
    if (_item.bigPicture) {
        
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
        
    } else {
        
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
        
    }    
}


@end

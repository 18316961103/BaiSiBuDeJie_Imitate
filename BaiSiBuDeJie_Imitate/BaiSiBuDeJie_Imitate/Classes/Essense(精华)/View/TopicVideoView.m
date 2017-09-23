//
//  TopicVideoView.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/21.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicVideoView.h"
#import "TopicItem.h"
#import "SeeBigPictureViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TopicVideoView () <AVPlayerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
/**    播放视频的控制器    */
@property (strong, nonatomic) AVPlayerViewController *playerVc;

@end

@implementation TopicVideoView

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)];
    
    [self.imageView addGestureRecognizer:tap];
}

#pragma mark - 点击查看大图
- (void)seeBigPicture {
    
    SeeBigPictureViewController *seeBigPictureVc = [[SeeBigPictureViewController alloc] init];
    
    seeBigPictureVc.topicItem = self.item;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBigPictureVc animated:YES completion:nil];
    
}

#pragma mark - 点击按钮播放视频
- (IBAction)playButtonClick:(UIButton *)sender {
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    
    if ([systemVersion integerValue] < 9) {
        // iOS9 之前的用法
        MPMoviePlayerController *mpPlayerVc = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.item.videouri]];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:mpPlayerVc animated:YES];
        
    } else {
        // iOS9 苹果推荐使用的方法
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:self.item.videouri]];
        
        AVPlayerViewController *playerVc = [[AVPlayerViewController alloc] init];
        
        playerVc.player = player;
        // 一点进去就开始播放
        [playerVc.player play];
        
        playerVc.delegate = self;
        
        self.playerVc = playerVc;
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVc animated:YES completion:nil];
        // 监听播放完后关闭播放器
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissVc)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
    }
    
}

- (void)dealloc {
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - 关闭播放器
- (void)dismissVc {
    WYFunc;
    
    [self.playerVc dismissViewControllerAnimated:YES completion:nil];
}

- (void)setItem:(TopicItem *)item {
    
    _item = item;
    // 设置播放数量
    if (_item.playcount >= 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万播放",_item.playcount / 10000.0];
    } else if (_item.playcount > 0) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放",_item.playcount];
    }
    
    // 音频时长
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",_item.videotime / 60,_item.videotime % 60];
    
    // 根据网络状态加载相应的图片
    [self.imageView setOriginImage:_item.image1 thumbnailImage:_item.image0 placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}


@end

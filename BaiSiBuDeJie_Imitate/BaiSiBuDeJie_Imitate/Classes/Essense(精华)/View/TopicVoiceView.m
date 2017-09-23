//
//  TopicVoiceView.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/21.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicVoiceView.h"
#import "TopicItem.h"
#import "SeeBigPictureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playVoiceButton;

/**    播放语音    */
@property (strong, nonatomic) AVPlayer *player;
/**    上一次播放的模型    */
@property (strong, nonatomic) TopicItem *lastTopicItem;
/**    上一次点击的播放按钮    */
@property (strong, nonatomic) UIButton *lastButton;

@end

@implementation TopicVoiceView

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

- (void)setItem:(TopicItem *)item {
    
    _item = item;
    // 设置播放数量
    if (_item.playcount >= 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万播放",_item.playcount / 10000.0];
    } else if (_item.playcount > 0) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放",_item.playcount];
    }
    
    // 音频时长
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",_item.voicetime / 60,_item.voicetime % 60];
    
    // 根据网络状态加载相应的图片
    [self.imageView setOriginImage:_item.image1 thumbnailImage:_item.image0 placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    [self.playVoiceButton setImage:[UIImage imageNamed:self.item.voiceIsPlaying ? @"playButtonPause":@"playButtonPlay"] forState:UIControlStateNormal];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化player
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.item.voiceuri]];
        
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        self.player = player;
    });
}

#pragma mark - 播放语音
- (IBAction)playVoiceButtonClick:(UIButton *)sender {
    
    if (self.lastTopicItem != self.item) { // 点击的不是同一个声音
        
        // 暂停播放
        [self.player pause];

        AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.item.voiceuri]];
        
        [self.player replaceCurrentItemWithPlayerItem:playItem];
        
        [self.player play];
        
        self.lastTopicItem.voiceIsPlaying = NO;
        self.item.voiceIsPlaying = YES;
        
        [self.lastButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];

        [sender setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
        
    } else {  // 点击的是同一个声音
        
        if (self.item.voiceIsPlaying) {
            
            self.item.voiceIsPlaying = NO;
            // 暂停播放
            [self.player pause];
            
            [sender setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
        } else {
            
            self.item.voiceIsPlaying = YES;
            
            // 开始播放
            [self.player play];
            
            [sender setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
        }
    }
    
    self.lastTopicItem = self.item;
    
    self.lastButton = sender;
    
}

@end

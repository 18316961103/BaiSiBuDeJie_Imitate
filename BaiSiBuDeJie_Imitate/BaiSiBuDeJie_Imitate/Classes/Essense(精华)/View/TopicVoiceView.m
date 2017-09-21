//
//  TopicVoiceView.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/21.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicVoiceView.h"
#import "TopicItem.h"

@interface TopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@end

@implementation TopicVoiceView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
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
}

@end

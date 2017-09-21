//
//  TopicCell.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/20.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicCell.h"
#import "TopicItem.h"
#import "TopicVideoView.h"
#import "TopicVoiceView.h"
#import "TopicPictureView.h"

@interface TopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_Label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIView *topCommentView;
@property (weak, nonatomic) IBOutlet UILabel *topCommentLabel;

/**    视频View    */
@property (strong, nonatomic) TopicVideoView *videoView;
/**    声音View    */
@property (strong, nonatomic) TopicVoiceView *voiceView;
/**    图片View    */
@property (strong, nonatomic) TopicPictureView *pictureView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonViewBottom;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomSuperViewBottom;


@end

@implementation TopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

#pragma mark - 懒加载
- (TopicVideoView *)videoView {
    
    if (_videoView == nil) {
        
        TopicVideoView *view = [TopicVideoView loadViewFromXib];
        
        [self addSubview:view];
        
        _videoView = view;
        
    }
    return _videoView;
}

- (TopicVoiceView *)voiceView {
    
    if (_voiceView == nil) {
        
        TopicVoiceView *view = [TopicVoiceView loadViewFromXib];
        
        [self addSubview:view];
        
        _voiceView = view;
        
    }
    return _voiceView;
}

- (TopicPictureView *)pictureView {
    
    if (_pictureView == nil) {
        
        TopicPictureView *view = [TopicPictureView loadViewFromXib];
        
        [self addSubview:view];
        
        _pictureView = view;
        
    }
    return _pictureView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

#pragma mark - 设置模型数据
- (void)setItem:(TopicItem *)item {
    
    _item = item;
    
    self.nameLabel.text = _item.name;
    self.passtimeLabel.text = _item.passtime;
    self.text_Label.text = _item.text;
    
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:_item.profile_image] placeholderImage:[UIImage circleImageWithImage:[UIImage imageNamed:@"defaultUserIcon"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 如果图片下载失败，直接返回，不做处理
        if (image == nil) return ;
        
        self.profileImageView.image = [UIImage circleImageWithImage:image];
        
    }];
    
    [self setupBottomButton:self.dingButton number:_item.ding placeHoderStr:@"顶"];
    [self setupBottomButton:self.caiButton number:_item.cai placeHoderStr:@"踩"];
    [self setupBottomButton:self.shareButton number:_item.repost placeHoderStr:@"分享"];
    [self setupBottomButton:self.commentButton number:_item.comment placeHoderStr:@"评论"];
    
    // 隐藏是防止重用
    if (_item.type == TopicCellTypeVideo) { // 视频
        self.videoView.hidden = NO;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
        
        self.videoView.item = item;

    } else if (_item.type == TopicCellTypeVoice) { // 声音
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
        
        self.voiceView.item = item;
        
    } else if (_item.type == TopicCellTypePicture) { // 图片
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        
        self.pictureView.item = item;

    } else { // 段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    if (_item.top_cmt.count) {
        self.topCommentView.hidden = NO;
        
        NSDictionary *commentDict = _item.top_cmt.firstObject;
        NSString *content = commentDict[@"content"];
        // 如果文字内容为空，那就是语音评论
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        
        NSString *user = commentDict[@"user"][@"username"];
        
        NSString *allComment = [NSString stringWithFormat:@"%@ : %@",user,content];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allComment];
        // 找出评论者的位置设置文字颜色
        NSRange range = [allComment rangeOfString:user];
        
        [attr addAttribute:NSForegroundColorAttributeName value:Color(71, 180, 250) range:range];
        
        self.topCommentLabel.attributedText = attr;
        // 当有评论的时候，buttonView的底部约束就是和评论view的顶部做约束
        self.buttonViewBottom.priority = UILayoutPriorityDefaultHigh;
        self.buttomSuperViewBottom.priority = UILayoutPriorityDefaultLow;
        
    } else { // 没有最新评论需要隐藏评论View
        self.topCommentView.hidden = YES;
        // 当没有评论的时候，buttonView的底部约束就是和父view的底部做约束
        self.buttonViewBottom.priority = UILayoutPriorityDefaultLow;
        self.buttomSuperViewBottom.priority = UILayoutPriorityDefaultHigh;
        
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.item.type == TopicCellTypeVideo) { // 视频
        
        self.videoView.frame = self.item.middleFrame;
        
    } else if (self.item.type == TopicCellTypeVoice) { // 声音
       
        self.voiceView.frame = self.item.middleFrame;

    } else if (self.item.type == TopicCellTypePicture) { // 图片

        self.pictureView.frame = self.item.middleFrame;

    }
    
}

#pragma mark - 设置底部栏标题
- (void)setupBottomButton:(UIButton *)button number:(NSInteger)number placeHoderStr:(NSString *)placeHoderStr {
    
    if (number > 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f",number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd",number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeHoderStr forState:UIControlStateNormal];
    }
    
}

//- (void)setFrame:(CGRect)frame {
//    // 重写setFrame方法，为了每个cell之间有空隙
//    frame.size.height -= 10;
//    
//    [super setFrame:frame];
//    
//}

@end

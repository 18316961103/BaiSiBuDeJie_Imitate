//
//  TopicCell.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/20.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicCell.h"
#import "TopicItem.h"

@interface TopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_Label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@end

@implementation TopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    
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

- (void)setFrame:(CGRect)frame {
    // 重写setFrame方法，为了每个cell之间有空隙
    frame.size.height -= 10;
    
    [super setFrame:frame];
    
}

@end

//
//  SubTagCell.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "SubTagCell.h"
#import "SubTagItem.h"

@interface SubTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end

@implementation SubTagCell

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setItem:(SubTagItem *)item {
    
    _item = item;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_item.image_list] placeholderImage:[UIImage circleImageWithImage:[UIImage imageNamed:@"defaultUserIcon"]] options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 如果图片下载失败，就直接返回，不做处理
        if (image == nil) return ;
        
        _headImageView.image = [UIImage circleImageWithImage:image];
        
    }];

    _title.text = _item.theme_name;
    
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅",_item.sub_number];
    
    NSInteger num = _item.sub_number.integerValue;
    
    if (num > 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f人订阅",numF];
        // 替换.0
        [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    _number.text = numStr;
    
    
}

- (void)awakeFromNib {
    
    // 设置图片圆角,iOS9之前这样设置会导致卡顿，如果图片多的话，iOS9之后，苹果已经修复这个问题了
//    _headImageView.layer.cornerRadius = 30;
//    _headImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

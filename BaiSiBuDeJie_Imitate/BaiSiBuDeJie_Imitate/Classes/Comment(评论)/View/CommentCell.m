//
//  CommentCell.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/25.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "CommentCell.h"
#import "CommentItem.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(CommentItem *)item {
    
    _item = item;
    
    self.contentLabel.text = [item.content isEqualToString:@""] ? @"语音评论" : item.content;
    
    self.nameLabel.text = item.user[@"username"];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.user[@"profile_image"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) return;
        
        self.headImageView.image = [UIImage circleImageWithImage:image]; ;
        
    }];
    
    if ([item.user[@"sex"] isEqualToString:@"m"]) {
        self.sexImageView.image = [UIImage imageNamed:@"Profile_manIcon"];
    } else {
        self.sexImageView.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
    
    if (item.like_count > 0) {
        [self.likeButton setTitle:[NSString stringWithFormat:@"%zd",item.like_count] forState:UIControlStateNormal];
    } else {
        [self.likeButton setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    }
}

@end

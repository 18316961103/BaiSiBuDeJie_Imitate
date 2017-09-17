//
//  MeSquareCell.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/16.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "MeSquareCell.h"
#import "MeSquareItem.h"

@interface MeSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MeSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(MeSquareItem *)item {
    
    _item = item;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_item.icon]];
    _nameLabel.text = _item.name;
    
}

@end

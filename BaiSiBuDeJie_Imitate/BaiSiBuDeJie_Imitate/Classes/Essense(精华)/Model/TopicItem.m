//
//  TopicItem.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/19.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicItem.h"

@implementation TopicItem

- (CGFloat)cellHeight {
    
    // 如果已经有缓存，则直接返回
    if (_cellHeight) return _cellHeight;
    
    // 文字的Y值
    _cellHeight += 60;
    // 文字的高度
    // 方法已过期，推荐使用下面这个
//    _cellHeight += [self.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreenW - 20, MAXFLOAT)].height + 10;
    
    CGSize size = CGSizeMake(kScreenW - 20, MAXFLOAT);
    
    _cellHeight += [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height + 10;
    
    // 中间内容
    if (self.type != TopicCellTypeWord) {
        
        CGFloat middleH = size.width * self.height / self.width;
        // 如果图片比屏幕高度还长，要限制高度，最多显示250
        if (middleH > kScreenH) {
           
            middleH = 300;
            
            self.bigPicture = YES;
            
        } else {
            self.bigPicture = NO;
        }
        
        self.middleFrame = CGRectMake(10, _cellHeight, size.width, middleH);
        
        _cellHeight += middleH + 10;
    }
    
    // 工具条
    _cellHeight += 35;
    
    // 最新评论
    if (self.top_cmt.count) {
        
        NSDictionary *commentDict = self.top_cmt.firstObject;
        NSString *content = commentDict[@"content"];
        // 如果文字内容为空，那就是语音评论
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        
        NSString *user = commentDict[@"user"][@"username"];
        
        NSString *topCommentText = [NSString stringWithFormat:@"%@ : %@",user,content];
        
        _cellHeight += [topCommentText boundingRectWithSize:CGSizeMake(kScreenW - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height + 20 + 10;
        
    } else { // 没有最新评论需要隐藏评论View

    }
 
    return _cellHeight;
}

@end

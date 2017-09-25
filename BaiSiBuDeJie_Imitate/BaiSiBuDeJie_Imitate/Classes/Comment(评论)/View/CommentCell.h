//
//  CommentCell.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/25.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentItem;

@interface CommentCell : UITableViewCell

/**    数据模型    */
@property (strong, nonatomic) CommentItem *item;

@end

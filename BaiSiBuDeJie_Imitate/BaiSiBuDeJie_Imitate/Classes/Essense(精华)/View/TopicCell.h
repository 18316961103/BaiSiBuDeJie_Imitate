//
//  TopicCell.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/20.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicItem;

@interface TopicCell : UITableViewCell

/**    数据模型    */
@property (strong, nonatomic) TopicItem *item;

@end

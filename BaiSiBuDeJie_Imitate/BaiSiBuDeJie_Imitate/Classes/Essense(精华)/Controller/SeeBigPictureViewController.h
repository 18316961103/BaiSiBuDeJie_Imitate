//
//  SeeBigPictureViewController.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/22.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicTableViewController.h"

@class TopicItem;

@interface SeeBigPictureViewController : UIViewController

/**    数据模型    */
@property (strong, nonatomic) TopicItem *topicItem;

@end

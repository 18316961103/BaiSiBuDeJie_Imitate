//
//  TopicTableViewController.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/22.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopicItem.h"

@interface TopicTableViewController : UITableViewController

/**    帖子类型    */
- (TopicCellType)type;

@end

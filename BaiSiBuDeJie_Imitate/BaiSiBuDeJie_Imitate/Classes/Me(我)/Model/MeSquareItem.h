//
//  MeSquareItem.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/17.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeSquareItem : NSObject

/**    标题    */
@property (strong, nonatomic) NSString *name;
/**    图片URL    */
@property (strong, nonatomic) NSString *icon;
/**    跳转URL    */
@property (strong, nonatomic) NSString *url;

@end

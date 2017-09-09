//
//  AdItem.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdItem : NSObject

/**    广告的图片URL    */
@property (strong, nonatomic) NSString *ori_curl;
/**    点击广告的跳转URL    */
@property (strong, nonatomic) NSString *w_picurl;

/**    广告图片的宽度    */
@property (assign, nonatomic) CGFloat w;
/**    广告图片的高度    */
@property (assign, nonatomic) CGFloat h;

@end

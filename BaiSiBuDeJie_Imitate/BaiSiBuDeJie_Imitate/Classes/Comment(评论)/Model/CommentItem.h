//
//  CommentItem.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/24.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentItem : NSObject

/** id */
@property (nonatomic, copy) NSString *ID;

/** 内容 */
@property (nonatomic, copy) NSString *content;

/** 用户 */
@property (strong , nonatomic)NSDictionary *user;

/** 被点赞数 */
@property (nonatomic, assign) NSInteger like_count;

/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;

/** 音频路径 */
@property (nonatomic, copy) NSString *voiceuri;

/**    额外增加的属性，缓存cell的高度    */
@property (assign, nonatomic) CGFloat cellHeight;

@end

//
//  TopicItem.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/19.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,TopicCellType) {
    /**  全部  */
    TopicCellTypeAll = 1,
    /**  图片  */
    TopicCellTypeVideo = 41,
    /**  段子  */
    TopicCellTypeVoice = 31,
    /**  声音  */
    TopicCellTypePicture = 10,
    /**  视频  */
    TopicCellTypeWord = 29,
};

@interface TopicItem : NSObject

/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;

/** 段子类型 */
@property (nonatomic, assign) NSInteger type;

@end

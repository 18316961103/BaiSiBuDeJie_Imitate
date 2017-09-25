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

/**    帖子ID    */
@property (strong, nonatomic) NSString *ID;

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
/** 中间内容的宽度 */
@property (nonatomic, assign) NSInteger width;
/** 中间内容的高度 */
@property (nonatomic, assign) NSInteger height;
/**    最新评论    */
@property (strong, nonatomic) NSArray *top_cmt;

/**    小图    */
@property (strong, nonatomic) NSString *image0;
/**    中图    */
@property (strong, nonatomic) NSString *image2;
/**    大图    */
@property (strong, nonatomic) NSString *image1;

/**    是否是GIF动图    */
@property (assign, nonatomic) BOOL is_gif;

/**    音频时长    */
@property (assign, nonatomic) NSInteger voicetime;
/**    视频时长    */
@property (assign, nonatomic) NSInteger videotime;
/**    音频/视频的播放数量    */
@property (assign, nonatomic) NSInteger playcount;
/**    视频的播放URL    */
@property (strong, nonatomic) NSString *videouri;
/**    音频的播放URL    */
@property (strong, nonatomic) NSString *voiceuri;

/** 段子类型 */
@property (nonatomic, assign) NSInteger type;

/**    额外增加的属性，缓存cell的高度    */
@property (assign, nonatomic) CGFloat cellHeight;

/**    中间内容的frame    */
@property (assign, nonatomic) CGRect middleFrame;

/**    是否是长图    */
@property (assign, nonatomic) BOOL bigPicture;

/**    声音是否正在播放    */
@property (assign, nonatomic) BOOL voiceIsPlaying;

@end

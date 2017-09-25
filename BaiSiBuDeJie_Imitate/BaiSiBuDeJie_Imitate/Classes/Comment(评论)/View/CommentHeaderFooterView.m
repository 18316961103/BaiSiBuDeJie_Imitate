//
//  CommentHeaderFooterView.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/24.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "CommentHeaderFooterView.h"

@implementation CommentHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        
        self.contentView.backgroundColor = Color(206, 206, 206);
        
    }
    return self;
}

@end

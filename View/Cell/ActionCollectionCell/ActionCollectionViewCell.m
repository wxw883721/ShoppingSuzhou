//
//  ActionCollectionViewCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ActionCollectionViewCell.h"

@implementation ActionCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-30, SCREEN_HEIGHT/6)];
        [self.contentView addSubview:_iconImageView];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-30, SCREEN_HEIGHT/6)];
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.font = [UIFont boldSystemFontOfSize:20];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.4];
        [self.contentView addSubview:_desLabel];
        
    }
    return self;
}

@end

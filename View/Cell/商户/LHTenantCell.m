//
//  LHTenantCell.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHTenantCell.h"
#import "StarView.h"

@implementation LHTenantCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _starView = [[StarView alloc] initWithFrame:CGRectMake(110, 70, 120, 25)];
        [self addSubview:_starView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

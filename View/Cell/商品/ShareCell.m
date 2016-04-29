//
//  ShareCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ShareCell.h"

@implementation ShareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        
        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, SCREEN_WIDTH-40, 30)];
        [self.contentView addSubview:_titleLabel];
        
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

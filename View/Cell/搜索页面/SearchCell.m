//
//  SearchCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.contentView.frame.size.height)];
        [self.contentView addSubview:_backView];
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 40, _backView.frame.size.height)];
        _leftImageView.image = [UIImage imageNamed:@"histroy.png"];
        [_backView addSubview:_leftImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, SCREEN_WIDTH-55, _backView.frame.size.height)];
        [_backView addSubview:_titleLabel];
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

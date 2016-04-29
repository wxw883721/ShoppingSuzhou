//
//  ThreeCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ThreeCell.h"

@implementation ThreeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/6*2.2)];
        [self.contentView addSubview:_backView];
        
        _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _backView.frame.size.height)];
        [_backView addSubview:_adImageView];
        
        
        
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

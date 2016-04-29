//
//  NewsCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [self.contentView addSubview:_backView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-20, 25)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_backView addSubview:_titleLabel];
        
        _datelabel = [[UILabel alloc]initWithFrame:CGRectMake(20,60,SCREEN_WIDTH-20,20)];
        _datelabel.font = [UIFont systemFontOfSize:Text_Normal];
        [_backView addSubview:_datelabel];
        
        UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 40, 15, 20)];
        moreImageView.image = [UIImage imageNamed:@"30-40"];
        [_backView addSubview:moreImageView];

        
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

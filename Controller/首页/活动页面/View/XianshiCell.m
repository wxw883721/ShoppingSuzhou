
//
//  XianshiCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "XianshiCell.h"

@implementation XianshiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //  图片
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self.contentView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH-200, 40)];
        _titleLabel.font = [UIFont systemFontOfSize:Text_Big];
        _titleLabel.numberOfLines = 0;
        _timeLabel.backgroundColor = [UIColor yellowColor];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_titleLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, SCREEN_WIDTH-100, 20)];
        _addressLabel.font = [UIFont systemFontOfSize:Text_Big];
        
        _addressLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_addressLabel];
        
        // 现价
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, (SCREEN_WIDTH-150)/2, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:Text_Big];
        _priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceLabel];
        
//        // 原价
//        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+50, 40, 100, 20)];
//        _oldPriceLabel.font = [UIFont systemFontOfSize:12];
//        _oldPriceLabel.textColor = [UIColor grayColor];
//        [self.contentView addSubview:_oldPriceLabel];
//        
//        // 原价删去线
//        _deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+50, 50, 35, 1)];
//        _deleteLabel.backgroundColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:_deleteLabel];
        
        
        
        _saleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_WIDTH-100, 100, 20)];
        _saleCountLabel.textColor= [UIColor darkGrayColor];
        _saleCountLabel.textAlignment = NSTextAlignmentRight;
        _saleCountLabel.font = [UIFont systemFontOfSize:Text_Big];
        [self.contentView addSubview:_saleCountLabel];
        
        //        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 100, SCREEN_WIDTH-125, 20)];
        //        _timeLabel.font = [UIFont systemFontOfSize:15];
        //        [self.contentView addSubview:_timeLabel];
        
        // 添加星星
        _starView = [[StarView alloc] initWithFrame:CGRectMake(100, 75, 150, 25)];
        [self.contentView addSubview:_starView];
        
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 75, 150, 25)];
        _discountLabel.font = [UIFont systemFontOfSize:Text_Normal];
        _discountLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_discountLabel];
        
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

//
//  DazheCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "DazheCell.h"
#import "StarView.h"

@implementation DazheCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self.contentView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, SCREEN_WIDTH-120, 50)];
        _titleLabel.font = [UIFont systemFontOfSize:Text_Big];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 100, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:Text_Normal];
        _priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceLabel];
        
        
//        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+20, 60, (SCREEN_WIDTH-120)/2, 20)];
//        _oldPriceLabel.font = [UIFont systemFontOfSize:13];
//        _oldPriceLabel.textColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:_oldPriceLabel];
//        
//        // 原价删除线
//        UILabel * label = [[UILabel alloc] init];
//        label.backgroundColor = [UIColor lightGrayColor];
//        label.frame =CGRectMake(CGRectGetMinX(_oldPriceLabel.frame), CGRectGetMidY(_oldPriceLabel.frame), CGRectGetWidth(_oldPriceLabel.frame)-, 1);
//        [self.contentView addSubview:label];
        
        
        _dazheLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 80, 100, 30)];
        _dazheLabel.textColor = [UIColor lightGrayColor];
        _dazheLabel.font = [UIFont systemFontOfSize:Text_Normal];
        [self.contentView addSubview:_dazheLabel];
        
        
        _saleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 80, 140, 20)];
        _saleCountLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_saleCountLabel];
        
        // 添加星星
        _starView = [[StarView alloc] initWithFrame:CGRectMake(120, 85, 150, 30)];
        [self.contentView addSubview:_starView];
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

//
//  ManjianCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ManjianCell.h"
#import "StarView.h"
@implementation ManjianCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self.contentView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, SCREEN_WIDTH-95-60, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_titleLabel];
        
        
        _saleNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-55, 10, 55, 20)];
        _saleNumLbl.backgroundColor = [UIColor clearColor];
        _saleNumLbl.font = [UIFont systemFontOfSize:Text_Normal];
        _saleNumLbl.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_saleNumLbl];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 40, SCREEN_WIDTH-95, 20)];
        _addressLabel.font = [UIFont systemFontOfSize:Text_Normal];
        _addressLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_addressLabel];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(95, 65, 60, 20)];
        [self.contentView addSubview:_starView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 65, SCREEN_WIDTH/2-60, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:Text_Normal];
        _contentLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_contentLabel];
        
        /*
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 100, SCREEN_WIDTH-95, 20)];
        _descriptionLabel.font = [UIFont boldSystemFontOfSize:14];
        _descriptionLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_descriptionLabel];
         */
        
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

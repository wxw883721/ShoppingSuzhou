//
//  LHShopDetail2TableViewCell.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHShopDetail2TableViewCell.h"
#import "StarView.h"
#import "LHImageView.h"

@implementation LHShopDetail2TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

//        LHImageView *tuImage;
//        UILabel *numberLabel;
//        LHImageView *reduceImage;
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH*0.45, 40)];
        [self.contentView addSubview:_titleLabel];
        
        _pingjiaImage = [[StarView alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH*0.3, 30)];
        [self.contentView addSubview:_pingjiaImage];
        
        _fengshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.3, 15, SCREEN_WIDTH*0.2, 20)];
        [self.contentView addSubview:_fengshuLabel];
        
        _intoLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.62-60, 15, SCREEN_WIDTH*0.38, 20)];
        [self.contentView addSubview:_intoLabel];
        
        _tuImage = [[LHImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 15, 15,20)];
        [self.contentView addSubview:_tuImage];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, 15, 20, 20)];
        _numberLabel.font = [UIFont systemFontOfSize:Text_Small];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numberLabel];

        _reduceImage = [[LHImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-115, 12, 25, 25)];
        [self.contentView addSubview:_reduceImage];
    }
    return self;
}

+ (LHShopDetail2TableViewCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ident = @"cell";
    LHShopDetail2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[LHShopDetail2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

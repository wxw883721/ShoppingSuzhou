//
//  ActShopCell.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/7/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ActShopCell.h"
#import "StarView.h"
#import "ActShopModel.h"

@implementation ActShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图片
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
        [self.contentView addSubview:_headView];
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame)+5, 5, SCREEN_WIDTH-200, 30)];
        [self.contentView addSubview:_titleLabel];
        //出售数量
        _salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 5, 200, 30)];
        [self.contentView addSubview:_salesLabel];
        //价格
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame)+5, CGRectGetMaxY(_titleLabel.frame), 100, 30)];
        _priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceLabel];
        //市场价格
        _marketPriceLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame), CGRectGetMaxY(_titleLabel.frame), 120, 30)];
        [self.contentView addSubview:_marketPriceLabel];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame)+5, CGRectGetMaxY(_priceLabel.frame), 120, 30)];
        [self.contentView addSubview:_starView];
        
        _evaluationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_starView.frame), CGRectGetMaxY(_priceLabel.frame), 120, 30)];
        [self.contentView addSubview:_evaluationLabel];
    }
    return self;
}

- (void)setShopModel:(ActShopModel *)shopModel {
    _shopModel = shopModel;
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:shopModel.goods_image]placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    _titleLabel.text = shopModel.goods_name;
    _salesLabel.text = [NSString stringWithFormat:@"已售%@", shopModel.goods_salenum];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", shopModel.goods_price];
    
    CGFloat _marketLabelW = [shopModel.goods_marketprice boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil].size.width;
    _marketPriceLabel.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame), CGRectGetMaxY(_titleLabel.frame), _marketLabelW, 30);
    _marketPriceLabel.text = shopModel.goods_marketprice;
    _marketPriceLabel.font = [UIFont systemFontOfSize:Text_Big];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_marketPriceLabel.frame), CGRectGetMidY(_marketPriceLabel.frame), CGRectGetWidth(_marketPriceLabel.frame), 1)];
    lineLabel.backgroundColor = [UIColor hexChangeFloat:@"e2e2e2"];
    [self.contentView addSubview:lineLabel];
    
    [_starView setStar:[shopModel.evaluation_good_star floatValue]];
    _evaluationLabel.text = [NSString stringWithFormat:@"%@人评价", shopModel.evaluation_count];
    
}

+ (ActShopCell *)cellWithTable:(UITableView *)tableView {
    static NSString *ident = @"cell";
    ActShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[ActShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
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

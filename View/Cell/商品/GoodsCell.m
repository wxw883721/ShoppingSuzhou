//
//  GoodsCell.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/29.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "GoodsCell.h"
#import "LHGoodsModel.h"
#import "StarView.h"

@implementation GoodsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 80)];
        [self.contentView addSubview:_headView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame), CGRectGetMinY(_headView.frame), SCREEN_WIDTH-140, 30)];
        [self.contentView addSubview:_titleLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame), CGRectGetMaxY(_titleLabel.frame), 15, 25)];
        label.text = @"￥";
        [self.contentView addSubview:label];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMaxY(_titleLabel.frame), 80, 25)];
        _priceLabel.textColor = [UIColor blueColor];
        _priceLabel.font = [UIFont systemFontOfSize:Text_Big];
        [self.contentView addSubview:_priceLabel];
        
        _marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame), CGRectGetMaxY(_titleLabel.frame), 60, 25)];
        _marketPriceLabel.textColor = [UIColor blueColor];
        _marketPriceLabel.font = [UIFont systemFontOfSize:Text_Normal];
        [self.contentView addSubview:_marketPriceLabel];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame)-5, CGRectGetMidY(_marketPriceLabel.frame), CGRectGetWidth(_marketPriceLabel.frame), 1)];
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.borderWidth = 1;
        [self.contentView addSubview:view];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame)+5, CGRectGetMaxY(_priceLabel.frame), 100, 30)];
        [self.contentView addSubview:_starView];
        
        _evaluationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_starView.frame), CGRectGetMaxY(_priceLabel.frame), 120, 30)];
        _evaluationLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_evaluationLabel];
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_starView.frame), CGRectGetMaxY(_evaluationLabel.frame), 40, 25)];
        label1.text = @"已售";
        label1.font = [UIFont systemFontOfSize:Text_Big];
        [self.contentView addSubview:label1];
        
        _saleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), CGRectGetMaxY(_evaluationLabel.frame), 80, 25)];
        _saleCountLabel.textColor = [UIColor redColor];
        _saleCountLabel.font = [UIFont systemFontOfSize:Text_Big];
        [self.contentView addSubview:_saleCountLabel];
        
    }
    return self;
}

- (void)setGoodsModel:(LHGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_image_url] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    self.titleLabel.text = goodsModel.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", goodsModel.goods_price];
    self.marketPriceLabel.text = goodsModel.goods_marketprice;
    [self.starView setStar:[goodsModel.evaluation_good_star floatValue]];
    self.evaluationLabel.text = [NSString stringWithFormat:@"%@人评价", goodsModel.evaluation_count];
    self.saleCountLabel.text = [NSString stringWithFormat:@"%@", goodsModel.goods_salenum];
}

+ (GoodsCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ident = @"cell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
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

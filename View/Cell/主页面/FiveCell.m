//
//  FiveCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "FiveCell.h"
#import "LHFirstPageModel.h"

@implementation FiveCell

//首页推荐商品

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0  blue:244/255.0  alpha:1.0];
        //view1
        _myView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/2-15, SCREEN_WIDTH/2-30+30+30)];

        [self addSubview:_myView1];
        
        
        _pic1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_myView1.frame), CGRectGetWidth(_myView1.frame))];
        [_myView1 addSubview:_pic1];
        
        _titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pic1.frame), CGRectGetWidth(_pic1.frame), 20)];
        _titleLabel1.font = [UIFont systemFontOfSize:Text_Big];
        [_myView1 addSubview:_titleLabel1];
        
        _priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel1.frame), CGRectGetWidth(_titleLabel1.frame), 20)];
        _priceLabel1.textColor = [UIColor redColor];
        _priceLabel1.font = [UIFont systemFontOfSize:14];
        [_myView1 addSubview:_priceLabel1];
        
        //view2
        _myView2 = [[UIView alloc] initWithFrame:CGRectMake(KScr_W/2+5, CGRectGetMinY(_myView1.frame), CGRectGetWidth(_myView1.frame), CGRectGetHeight(_myView1.frame))];
        [self addSubview:_myView2];
        
        _pic2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_myView2.frame), CGRectGetHeight(_pic1.frame))];
        [_myView2 addSubview:_pic2];
        
        _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pic2.frame), CGRectGetWidth(_pic2.frame), CGRectGetHeight(_titleLabel1.frame))];
        _titleLabel2.font = [UIFont systemFontOfSize:Text_Big];
        [_myView2 addSubview:_titleLabel2];
        
        _priceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel2.frame), CGRectGetWidth(_titleLabel2.frame), 20)];
        _priceLabel2.textColor = [UIColor redColor];
        _priceLabel2.font = [UIFont systemFontOfSize:14];
        [_myView2 addSubview:_priceLabel2];
        
     
    }
    return self;
}

- (void)setArray:(NSArray *)array {
    _array = array;
    
    LHFirstPageModel *model = array[0];
    LHFirstPageModel *model1 = array[1];
    
    [_pic1 sd_setImageWithURL:[NSURL URLWithString:model.goods_image]placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    _titleLabel1.text = model.goods_name;
    _priceLabel1.text = [NSString stringWithFormat:@"￥%@", model.goods_price];
    
    [_pic2 sd_setImageWithURL:[NSURL URLWithString:model1.goods_image] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    _titleLabel2.text = model1.goods_name;
    _priceLabel2.text = [NSString stringWithFormat:@"￥%@", model1.goods_price];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

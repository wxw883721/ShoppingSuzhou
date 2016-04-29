//
//  orderDetailCell.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/1.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "orderDetailCell.h"

@implementation orderDetailCell

- (void)awakeFromNib {

}

-(void)configDetailOrder:(NSDictionary *)dic
{
    
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0,99 , KScr_W , 1)];
    imageLine.backgroundColor = kLineImage;
    [self addSubview:imageLine];
    
    UIImageView *detailGoodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 80, 80)];
    [detailGoodsImage sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"goods_image"]] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
    [self addSubview:detailGoodsImage];
    
    UILabel *detailGoodsName = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, KScr_W - 170, 21)];
    detailGoodsName.font = [UIFont systemFontOfSize:Text_Big];
    [detailGoodsName setTextColor:[UIColor blackColor]];
    detailGoodsName.text = [dic valueForKey:@"goods_name"];
    //    goodsName.numberOfLines = 0;
    //    goodsName.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:detailGoodsName];
    
    UILabel *detailGoodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 75, 10, 65, 21)];
    detailGoodsPrice.font = [UIFont systemFontOfSize:Text_Big];
    [detailGoodsPrice setTextColor:[UIColor blackColor]];
    detailGoodsPrice.textAlignment = NSTextAlignmentCenter;
    if ([[dic valueForKey:@"goods_price"] floatValue] == 0) {
        detailGoodsPrice.text = @"赠品";
        [detailGoodsPrice setTextColor:[UIColor lightGrayColor]];
    }
    else
    {
    detailGoodsPrice.text = [NSString stringWithFormat:@"￥%.1f",[[dic valueForKey:@"goods_price"] floatValue]];
    }
    [self addSubview:detailGoodsPrice];

    UILabel *detailGoodsTaste = [[UILabel alloc]initWithFrame:CGRectMake(90, 65,KScr_W - 170 , 21)];
    [detailGoodsTaste setTextColor:[UIColor lightGrayColor]];
    detailGoodsTaste.font = [UIFont systemFontOfSize:Text_Normal];
    if ([dic valueForKey:@"goods_name"]) {
        
        detailGoodsTaste.text = @"无规格";
    }
    else
    {
        NSArray *array1 = [[dic valueForKey:@"goods_name"] componentsSeparatedByString:@","];
        NSArray *array2 = [[dic valueForKey:@"goods_spec"] componentsSeparatedByString:@","];
        
        detailGoodsTaste.text = [NSString stringWithFormat:@"%@:%@ %@:%@",array1[0],array2[0],array1[1],array2[1]];
    }
    [self addSubview:detailGoodsTaste];
    
    UILabel *detailGoodsNum = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 75, 65, 65, 21)];
    [detailGoodsNum setTextColor:[UIColor blackColor]];
    detailGoodsNum.textAlignment = NSTextAlignmentCenter;
    detailGoodsNum.font = [UIFont systemFontOfSize:Text_Normal];
    detailGoodsNum.text = [NSString stringWithFormat:@"x%@",[dic valueForKey:@"goods_num"]];
    [self addSubview:detailGoodsNum];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
   
}

@end

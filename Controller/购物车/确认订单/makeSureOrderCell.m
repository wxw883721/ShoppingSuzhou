//
//  makeSureOrderCell.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/24.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "makeSureOrderCell.h"
#import "Size.h"
#import "voucherVC.h"

@implementation makeSureOrderCell

- (void)awakeFromNib {
   
}


-(void)configCellWith:(NSDictionary *)dic
{
    //商品图片
    UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 80, 80)];
    [goodsImage sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"goods_image_url"]] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    [self addSubview:goodsImage];
    
    //商品名称
    UILabel *goodsName = [[UILabel alloc]initWithFrame:CGRectMake(103, 10, KScr_W - 200, 24)];
    goodsName.text = [dic valueForKey:@"goods_name"];
    goodsName.font = [UIFont systemFontOfSize:Text_Big];
    [goodsName setTextColor:[UIColor blackColor]];
    [self addSubview:goodsName];
    
    //商品价格
    UILabel *goodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 100, 10, 95, 24)];
    goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",[[dic valueForKey:@"goods_price"]floatValue]];
    goodsPrice.textAlignment = NSTextAlignmentRight;
    goodsPrice.font = [UIFont systemFontOfSize:Text_Normal];
    [goodsPrice setTextColor:[UIColor blackColor]];
    [self addSubview:goodsPrice];
   
    //规格
    UILabel *ficationLabel = [[UILabel alloc]initWithFrame:CGRectMake(103, 65, KScr_W - 180, 24)];
    [ficationLabel setTextColor:[UIColor lightGrayColor]];
    
    if ([dic[@"spec_name"] isKindOfClass:[NSString class]])
    {
        ficationLabel.text = @"无规格";
    }
    else
    {
        
    }
    
    ficationLabel.font = [UIFont systemFontOfSize:Text_Normal];
    [self addSubview:ficationLabel];
    
    //商品数量
    UILabel *goodsNum = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 70, 65, 60, 24)];
    goodsNum.textAlignment = NSTextAlignmentCenter;
    goodsNum.text = [NSString stringWithFormat:@"x%d",[[dic valueForKey:@"goods_num"] intValue]];
    goodsNum.font = [UIFont systemFontOfSize:Text_Normal];
    [goodsNum setTextColor:[UIColor blackColor]];
    [self addSubview:goodsNum];
    
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(15, 92,KScr_W - 30 , 1)];
    imageLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    [self addSubview:imageLine];

}



@end

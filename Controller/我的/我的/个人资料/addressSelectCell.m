//
//  addressSelectCell.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/8/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "addressSelectCell.h"

@implementation addressSelectCell

- (void)awakeFromNib {
    }

-(void)config:(NSDictionary *)dic
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, KScr_W - 16, 40)];
    label.text = [dic valueForKey:@"area_name"];
    label.font = [UIFont systemFontOfSize:Text_Big];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    [self addSubview:label];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, KScr_W, 1)];
    image.backgroundColor = kLineImage;
    [self addSubview:image];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

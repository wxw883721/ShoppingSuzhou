//
//  myMessCell.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "myMessCell.h"

@implementation myMessCell

- (void)awakeFromNib {
    
//    self.isEditor = NO;
//    self.isSelect = NO;
//    self.isSelectAll = NO;
}

-(void)createCell:(NSDictionary *)dic
{
    self.selectedDic = dic;
    UILabel *label = [[UILabel alloc]init];
    label.text = [dic valueForKey:@"message_body"];
    label.font = [UIFont systemFontOfSize: Text_Big];
    [label setTextColor:[UIColor blackColor]];
    
    _selectBtn = [[UIButton alloc]init];
   _selectBtn.frame = CGRectMake(10, 10, 20, 20);
    //[_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (self.isEditor) {
        
        _selectBtn.hidden = NO;
        label.frame = CGRectMake(35, 8, KScr_W - 55, 24);
        if (self.isSelectAll) {
            
            [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        }
        else
        {
            if (self.isSelect) {
                [_selectBtn setBackgroundImage: [UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
            }
            else
            {
                [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
                
            }
            
        }
        
    }
    else
    {
        
        _selectBtn.hidden = YES;
        label.frame = CGRectMake(8, 8, KScr_W - 28, 24);
    }
    
     [self addSubview:label];
     [self addSubview:_selectBtn];
    

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(KScr_W - 18, 15, 10, 10)];
    image.image = [UIImage imageNamed:@"20-20.png"];
    image.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:image];
    
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(8, 39, KScr_W - 16, 1)];
    imageLine.backgroundColor = kLineImage;
    [self addSubview:imageLine];
    
}

-(void)selectBtn:(UIButton *)btn
{
    if ([[_selectBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_normal"]]) {
        
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        if (_delegate && [_delegate respondsToSelector:@selector(selectItem:isSelected:)]) {
            [_delegate selectItem:self.selectedDic isSelected:YES];
        }
    }
    else if ([[_selectBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_pressed"]])
    {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [_delegate selectItem:self.selectedDic isSelected:NO];
    
    }


}


@end

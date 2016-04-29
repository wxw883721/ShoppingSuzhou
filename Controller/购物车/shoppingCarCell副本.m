
//
//  shoppingCarCell.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/17.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "shoppingCarCell.h"
#import "Size.h"
#import "ShoppingCarViewController.h"


@implementation shoppingCarCell
{

    ShoppingCarViewController *vc;
    NSString *price;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _onClick = NO;
        _circleClick = NO;
        self.calculateArr = [[NSMutableArray alloc]init];
        
        return self;
    }
    return nil;
}

- (void)configCellWith:(NSDictionary*)dic
{
    self.selectedDic = dic;
    
//    NSLog(@"*********%@",dic);
    UIImageView *imageLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 179,KScr_W , 1)];
    imageLine1.backgroundColor = kLineImage;
    [self addSubview:imageLine1];
    
    _shoppingStoreName = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, KScr_W - 16, 25)];
    _shoppingStoreName.font = [UIFont systemFontOfSize:15.0];
    _shoppingStoreName.text = ([dic valueForKey:@"store_name"]!=[NSNull null])?[dic valueForKey:@"store_name"]:@"名称未知";
    [self addSubview:_shoppingStoreName];
    
    UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 40, KScr_W -16, 1)];
    imageLine2.backgroundColor = kLineImage;
    [self addSubview:imageLine2];
    
    _shoppingSelectBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 80, 20, 20)];
    [_shoppingSelectBtn addTarget:self action:@selector(shoppingSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isSelectedAll)
    {
        [_shoppingSelectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];

    }
    else
    {
        if (self.circleClick)
        {
            [_shoppingSelectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
            
        }
        else
        {
            [_shoppingSelectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
            
        }

    }
    [self addSubview:_shoppingSelectBtn];
    
    
    
    _shoppingImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, 50, 80, 80)];
   
    [_shoppingImage sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"goods_image"]] placeholderImage:[UIImage imageNamed:@"rr.png"]];
    
    [self addSubview:_shoppingImage];
    
    _shoppingShopName = [[UILabel alloc]initWithFrame:CGRectMake(128, 50, 120 *kScr_Rate, 21)];
    _shoppingShopName.font = [UIFont systemFontOfSize:15.0];
    _shoppingShopName.text = [dic valueForKey:@"goods_name"];
    [self addSubview:_shoppingShopName];
    
    _shoppingFications = [[UILabel alloc]initWithFrame:CGRectMake(128, 75, 120*kScr_Rate, 21)];
    _shoppingFications.font = [UIFont systemFontOfSize:15.0];
    [_shoppingFications setTextColor:[UIColor lightGrayColor]];
    
    NSLog(@"%@",[dic valueForKey:@"spec_name"]);
  
    if ([[dic valueForKey:@"spec_name"] isKindOfClass:[NSString class]]) {
        
        _shoppingFications.text = @"无规格";
    }
    else if([dic valueForKey:@"spec_name"] )
    {
       NSArray *array1 = [[dic valueForKey:@"spec_name"] componentsSeparatedByString:@","];
        NSArray *array2 = [[dic valueForKey:@"spec_value"] componentsSeparatedByString:@","];
    
        _shoppingFications.text = [NSString stringWithFormat:@"%@:%@ %@:%@",array1[0],array2[0],array1[1],array2[1]];
        
        _shoppingFications.text = [NSString stringWithFormat:@"%@:%@",[dic valueForKey:@"spec_name"],[dic valueForKey:@"spec_value"]];
    }
    NSLog(@"%@",[dic valueForKey:@"spec_name"]);

    [self addSubview:_shoppingFications];
    
    _shoppingNum = [[UILabel alloc]initWithFrame:CGRectMake(128, 109,100*kScr_Rate , 21)];
    _shoppingNum.font = [UIFont systemFontOfSize:15.0];
     _shoppingNum.text = [NSString stringWithFormat:@"x%@",[dic valueForKey:@"goods_num"]];
    [self addSubview:_shoppingNum];
    
    _shoppingPrice = [[UILabel alloc]initWithFrame:CGRectMake(250*kScr_Rate, 50, 62*kScr_Rate, 21)];
    _shoppingPrice.font = [UIFont systemFontOfSize:14.0];
     _shoppingPrice.text = [NSString stringWithFormat:@"￥%@",[dic valueForKey:@"goods_price"]];
    price = [dic valueForKey:@"goods_price"];
    [self addSubview:_shoppingPrice];
    
    
    //点击编辑的方法
    _shoppingEditor = [[UIButton alloc]initWithFrame:CGRectMake(250*kScr_Rate, 105, 59*kScr_Rate, 25)];
    [_shoppingEditor addTarget:self action:@selector(shoppingEditor:) forControlEvents:UIControlEventTouchUpInside];
    //[_shoppingEditor setTitle:@"编辑" forState:UIControlStateNormal];
    [_shoppingEditor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _shoppingEditor.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:_shoppingEditor];
    
    
    
    _shoppingLineImage = [[UIImageView alloc]initWithFrame:CGRectMake(250*kScr_Rate, 105, 1, 25)];
    _shoppingLineImage.backgroundColor = kLineImage;
    [self addSubview:_shoppingLineImage];
    
    UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 138, KScr_W - 16, 1)];
    imageLine3.backgroundColor = kLineImage;
    [self addSubview:imageLine3];
    
    _shoppingTotalNum = [[UILabel alloc]initWithFrame:CGRectMake(40, 147, 120*kScr_Rate, 21)];
    _shoppingTotalNum.font = [UIFont systemFontOfSize:15.0];
    _shoppingTotalNum.text = [NSString stringWithFormat:@"总数：%@件",[dic valueForKey:@"goods_num"]];
    [self addSubview:_shoppingTotalNum];
    
    _shoppingTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(192*kScr_Rate, 147, 120*kScr_Rate, 21)];
    _shoppingTotalPrice.font = [UIFont systemFontOfSize:15.0];
    _shoppingTotalPrice.text = [NSString stringWithFormat:@"合计：%.2f",[[dic valueForKey:@"goods_sum" ]floatValue]];

    [self addSubview:_shoppingTotalPrice];
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(128, 109, 100*kScr_Rate, 21)];
    [self addSubview:_view];
    
    _reductionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3,15 , 15)];
    [_reductionBtn setBackgroundImage:[UIImage imageNamed:@"shop_car_minus_index_enable"] forState:UIControlStateNormal];
    [_reductionBtn addTarget:self action:@selector(reductionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_view addSubview:_reductionBtn];
    
    _shoppingAddNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 3, 30, 15)];
    _shoppingAddNumLabel.font = [UIFont systemFontOfSize: 12.0];
    _shoppingAddNumLabel.text = [dic valueForKey:@"goods_num"];
    _shoppingAddNumLabel.textAlignment = NSTextAlignmentCenter;
    [_shoppingAddNumLabel setTextColor:[UIColor blueColor]];
    [_view addSubview:_shoppingAddNumLabel];
    
    _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(45, 3, 15, 15)];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"shop_car_add_index_enable"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:_addBtn];
    
    
    //判断编辑状态
    if (self.isEditor)
    {
        _view.hidden = NO;
        _shoppingEditor.hidden = YES;
        _shoppingLineImage.hidden = YES;
        _shoppingNum.hidden = YES;
        
    }
    else
    {
        if (self.onClick)
        {
            _view.hidden = NO;
             _shoppingEditor.hidden = YES;
            _shoppingLineImage.hidden = YES;
            _shoppingNum.hidden = YES;
            
        }
        else
        {
            _shoppingLineImage.hidden = NO;
            [_shoppingEditor setTitle:@"编辑" forState:UIControlStateNormal];
            _shoppingNum.hidden = NO;
            _view.hidden = YES;
            
        }
    }

}


//点击事件
-(void)reductionBtn:(UIButton *)btn
{
    int i = [_shoppingAddNumLabel.text intValue];
    if (i >1) {
         i --;
    }
   
    _shoppingAddNumLabel.text = [NSString stringWithFormat:@"%d",i];
    _shoppingTotalPrice.text = [NSString stringWithFormat:@"合计：%.2f",i * [price floatValue
]];
    _shoppingTotalNum.text = [NSString stringWithFormat:@"总数：%d件",i];
    
        
        if (_delegate && [_delegate respondsToSelector:@selector(changeNum:changeSum:andChangeItemDic:)]) {
            
            [_delegate changeNum:[NSString stringWithFormat:@"%d",i] changeSum:[NSString stringWithFormat:@"%f",i * [price floatValue]]andChangeItemDic:self.selectedDic ];
  }

}

-(void)addBtn:(UIButton *)btn
{
    int i = [_shoppingAddNumLabel.text intValue];
    
    if (i >= [[self.selectedDic valueForKey:@"goods_storage"]intValue]) {
        
        [MBProgressHUD showError:@"库存不足"];
        i = [[self.selectedDic valueForKey:@"goods_storage"]intValue];
    }
    else
    {
        i ++;
    }
    _shoppingAddNumLabel.text = [NSString stringWithFormat:@"%d",i];
    _shoppingTotalPrice.text = [NSString stringWithFormat:@"合计：%.2f",i * [price floatValue]];
    
    _shoppingTotalNum.text = [NSString stringWithFormat:@"总数：%d件",i];
    
    if (_delegate && [_delegate respondsToSelector:@selector(changeNum:changeSum:andChangeItemDic:)]) {
        
        [_delegate changeNum:[NSString stringWithFormat:@"%d",i] changeSum:[NSString stringWithFormat:@"%f",i * [price floatValue]]andChangeItemDic:self.selectedDic ];

  }
}

//点击的圈
-(void)shoppingSelectBtn:(UIButton *)btn
{
    
    if ([[_shoppingSelectBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_normal"]])
    {
        [_shoppingSelectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        
        if (_delegate && [_delegate respondsToSelector:@selector(selecteItem:isSelected:)])
        {
            [_delegate   selecteItem:self.selectedDic isSelected:YES];
        }
         
    }
    else
    {
        
        [_shoppingSelectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
       [_delegate   selecteItem:self.selectedDic isSelected:NO];
    }
    
}

//
-(void)shoppingEditor:(UIButton *)btn
{
    if ([_shoppingEditor.titleLabel.text isEqualToString:@"编辑"]) {
        
        //[_shoppingEditor setTitle:@"" forState:UIControlStateNormal];
        _shoppingEditor.hidden = YES;
        _shoppingLineImage.hidden = YES;
        _shoppingNum.hidden = YES;
        _view.hidden = NO;
        
        if (_delegate && [_delegate respondsToSelector:@selector(editBtnPress:)])
        {
            [_delegate   editBtnPress:self.editBtnName];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(clickItem:isSelected:)])
        {
            [_delegate   clickItem:self.selectedDic  isSelected:YES];
        }
        
    }
//    else
//    {
//        _shoppingLineImage.hidden = NO;
//        [_shoppingEditor setTitle:@"" forState:UIControlStateNormal];
//        [_delegate   editBtnPress:self.editBtnName];
//        [_delegate   clickItem:self.selectedDic  isSelected:YES];
//        _view.hidden = YES;
//    }
    
}




@end


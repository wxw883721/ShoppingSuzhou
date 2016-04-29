//
//  orderEvaluationVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "orderEvaluationVC.h"
#import "Size.h"

#define kAnony @"anony"
#define kScore @"score"
#define kTextView @"textView"
#define kGoodsId @"goods_id"

@interface orderEvaluationVC ()
{
    NSString *order_id;
    NSMutableArray *arr;
    UIScrollView * scrollView;
}

//@property (retain, nonatomic)  UITextView *orderEvaluationTextView;
@property (nonatomic,retain) UILabel *orderPromptLabel;
@property (nonatomic,assign) int viewTag;

@end

@implementation orderEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createScorllView];
    [self createBtn];

    [self createView];
    
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评价";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    arr = [[NSMutableArray alloc]init];
    
    if (self.evaluationArr.count == 0) {
       
        [arr addObject:self.evalCellArr];
        
    }
    else
    {
    for (NSDictionary *dict in self.evaluationArr) {
        NSArray *arr1 = [dict objectForKey:@"extend_order_goods"];
        //[arr addObject:[dict objectForKey:@"extend_order_goods"]];
        for (NSDictionary *goodsDic in arr1) {
            [arr addObject:goodsDic];
        }
      }
    }
    self.dataSourceArr = [[NSMutableArray alloc]init];
}
-(void)createScorllView
{
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScr_W,KScr_H - 64)];
    
    scrollView.contentSize = CGSizeMake(0, 215*(arr.count +1)+90);
    NSLog(@"%@",arr);
    scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:scrollView];
}


//创建每个view
-(void)createView
{
    for (int i = 0; i < arr.count + 1; i ++) {
        
        UILabel *goodsName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + 215*i, KScr_W - 20, 25)];
        if (i == 0) {
            
            if (self.evaluationArr.count == 0) {
                for (NSDictionary *dict in arr) {
                    goodsName.text = [NSString stringWithFormat:@"商户名称: %@",[dict objectForKey:@"store_name"]];
                }
            }
            else
            {
            for (NSDictionary *dict in self.evaluationArr) {
                goodsName.text = [NSString stringWithFormat:@"商户名称: %@",[dict objectForKey:@"store_name"]];
             }
            }
        }
        else
        {
            if (self.evaluationArr.count == 0) {
                
                for (NSDictionary *dict in [arr[i - 1] valueForKey:@"extend_order_goods"]) {
                    goodsName.text = [NSString stringWithFormat:@"商品名称: %@",[dict objectForKey: @"goods_name"]];
                }
            }
            else
            {
            goodsName.text = [NSString stringWithFormat:@"商品名称: %@",[arr[i - 1] valueForKey: @"goods_name"]];
            }
            
        }
        goodsName.font = [UIFont systemFontOfSize:Text_Big];
        [goodsName setTextColor:[UIColor blackColor]];
        [scrollView addSubview:goodsName];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 45+ 215*i, 90, 25)];
        if (i == 0) {
            label.text = @"对商户评价:";
        }
        else
        {
            label.text = @"对商品评价:";
        }
        [label setTextColor:[UIColor lightGrayColor]];
        label.font = [UIFont systemFontOfSize:Text_Big];
        [scrollView addSubview:label];
        
        
        TQStarRatingView *starRatingView = [[TQStarRatingView alloc]initWithFrame:CGRectMake(110, 50+ 215*i,75 , 15) numberOfStar:5];
        starRatingView.delegate = self;
        self.score = [NSString stringWithFormat:@"%d",5];
        starRatingView.tag = i;
        [scrollView addSubview:starRatingView];
        
        
        //匿名评价
        UIButton *anonymousBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 90,50+ 215*i , 15, 15)];
        [anonymousBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        self.anony = [NSString stringWithFormat:@"%d",0];
        anonymousBtn.tag = i;
        [anonymousBtn addTarget:self action:@selector(anonymousBtn:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:anonymousBtn];
        
        UILabel *anonymousLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 70,47+ 215*i, 60, 21)];
        anonymousLabel.text = @"匿名评价";
        [anonymousLabel setTextColor:[UIColor blackColor]];
        anonymousLabel.font = [UIFont systemFontOfSize:Text_Normal];
        [scrollView addSubview:anonymousLabel];
        
        //textView创建
        UIImageView *imageLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 80+ 215*i, KScr_W - 16, 1)];
        imageLine1.backgroundColor = kLineImage;
        [scrollView addSubview:imageLine1];
        
        UITextView *orderEvaluationTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 90+ 215*i, KScr_W - 20, 120)];
        orderEvaluationTextView.tag = i;
        orderEvaluationTextView.delegate = self;
        [scrollView addSubview:orderEvaluationTextView];
        
        self.orderPromptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScr_W - 20, 50)];
        self.orderPromptLabel.numberOfLines = 0;
        self.orderPromptLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.orderPromptLabel.text = @"亲,留下您的评论吧,您的评论是其他用户的重要参考。";
        CGSize size = [self.orderPromptLabel sizeThatFits:CGSizeMake(self.orderPromptLabel.frame.size.width, MAXFLOAT)];
        self.orderPromptLabel.frame = CGRectMake(0,0, KScr_W - 20, size.height);
        self.orderPromptLabel.font = [UIFont systemFontOfSize:Text_Normal];
        self.orderPromptLabel.textColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
        self.orderPromptLabel.tag = orderEvaluationTextView.tag;
        [orderEvaluationTextView addSubview:self.orderPromptLabel];
        
        UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 214+ 215*i, KScr_W, 1)];
        imageLine2.backgroundColor = kLineImage;
        [scrollView addSubview:imageLine2];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        if (i == 0) {
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.score,kScore,self.anony,kAnony,orderEvaluationTextView.text,kTextView, nil];
        }
        else
        {
            if (self.evaluationArr.count == 0) {
                
                NSString *goods_id = [[NSString alloc]init];
                for (NSDictionary *dict in [arr[i - 1] valueForKey:@"extend_order_goods"]) {
                    goods_id = [dict objectForKey:@"goods_id"];
                }
                dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:goods_id,kGoodsId,self.score,kScore,self.anony,kAnony,orderEvaluationTextView.text,kTextView, nil];
            }
            else
            {
            dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[arr[i-1] valueForKey:@"goods_id"],kGoodsId,self.score,kScore,self.anony,kAnony,orderEvaluationTextView.text,kTextView, nil];
            }
        }
        [self.dataSourceArr addObject:dict];
    }
}

//星星点击事件
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    NSLog(@"%f",score*10/2);
    NSMutableDictionary *dict = self.dataSourceArr[view.tag];
    [dict setObject:[NSString stringWithFormat:@"%.1f",score*10/2] forKey:kScore];
    [self.dataSourceArr replaceObjectAtIndex:view.tag withObject:dict];
    
}

//匿名评价点击事件
-(void)anonymousBtn:(UIButton *)btn
{
    NSLog(@"%ld",(long)btn.tag);
    if ([[btn  backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_normal"]]) {
        
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        self.anony = [NSString stringWithFormat:@"%d",1];
        
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        self.anony = [NSString stringWithFormat:@"%d",0];
    }
    
    NSMutableDictionary *dict = self.dataSourceArr[btn.tag];
    [dict setObject:self.anony forKey:kAnony];
    [self.dataSourceArr replaceObjectAtIndex:btn.tag withObject:dict];
    
}

//textView点击事件
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    for (id obj in textView.subviews) {
        
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)obj;
            label.hidden = YES;
        }
    }
    return YES;
    
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text == nil || [textView.text isEqual:@""]) {
        for (id obj in textView.subviews) {
            
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)obj;
                label.hidden = NO;
            }
        }
    }
   
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSMutableDictionary *dict = self.dataSourceArr[textView.tag];
    [dict setObject:textView.text forKey:kTextView];
    [self.dataSourceArr replaceObjectAtIndex:textView.tag withObject:dict];

}

-(void)createBtn
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 215*(arr.count + 1), KScr_W, 90)];
    UIButton *comment = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W/2 - 145, 30, 290, 40)];
    [comment setTitle:@"发布评论" forState:UIControlStateNormal];
    [comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comment.backgroundColor = kColor;
    comment.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    comment.layer.cornerRadius = 5.0;
    [comment addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:comment];
    [scrollView addSubview:footView];
}

-(void)commentBtnClick:(UIButton *)btn
{
    NSLog(@"%@",self.dataSourceArr);
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    
    if (self.evaluationArr.count == 0) {
        for (NSDictionary *dic in arr) {
            order_id = [dic objectForKey:@"order_id"];
        }
    }
    else
    {
    for (NSDictionary *dict in self.evaluationArr) {
        order_id = [dict objectForKey:@"order_id"];
     }
        
    }
    NSString *store_comment = [[NSString alloc]init];
    NSString *store_score = [[NSString alloc]init];
    NSString *store_anony = [[NSString alloc]init];
    NSString *goods = [[NSString alloc]init];
    
    for (int i = 0; i < arr.count + 1; i ++) {
        NSString *agoods = [[NSString alloc]init];
        
        if (i == 0 ) {
            //店铺
            NSMutableDictionary *dict = self.dataSourceArr[0];
           store_comment = [dict objectForKey:kTextView];
           store_score = [dict objectForKey:kScore];
           store_anony = [dict objectForKey:kAnony];
        }
        else
        {
            NSMutableDictionary *dict = self.dataSourceArr[i];
            agoods = [NSString stringWithFormat:@"%@|%@|%@|%@",[dict objectForKey:kGoodsId],[dict objectForKey:kScore],[dict objectForKey:kTextView],[dict objectForKey:kAnony]];
        }
        
        if (goods.length == 0) {
            
            goods = agoods;
        }
        else
        {
            NSString *str = [@";" stringByAppendingString:agoods];
            goods = [goods stringByAppendingString:str];
        }
        
    }
   
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id",goods,@"goods",store_comment,@"store_comment",store_score,@"store_score",store_anony,@"store_anony", nil];
    [WXAFNetwork postRequestWithUrl:kEvaluationUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             
            NSNumber *code = [responseObject objectForKey:kCode];
            NSDictionary *data = [responseObject objectForKey:kData];
             
            if ([code integerValue] == 200) {
             
                [MBProgressHUD showSuccess:[data objectForKey:kMessage]];

                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else
                {
             
                [MBProgressHUD showError:[data objectForKey:kMessage]];
            }
        }
        else
            {
             
        [MBProgressHUD showError:kError];
             
        }
             
             
    }];
    
}

-(void)touchBtn:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

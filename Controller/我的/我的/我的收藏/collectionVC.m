//
//  collectionVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "collectionVC.h"
#import "Size.h"
#import "collectionCell.h"
#import "goodsListModel.h"
#import "merchantsModel.h"
#import "MJRefresh.h"
#import "LHGodsDetailViewController.h"
#import "SuShopDetailViewController.h"
#import "SearchViewController.h"



@interface collectionVC ()
{
    BOOL collection;
    UIButton *goodsBtn;
    UIButton *merchantsBtn;
    
    int currentPage;
    
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    
    NSIndexPath *indexPath1;
    
}

@property (nonatomic,retain) NSArray *statusArr;
@property (nonatomic,retain) NSMutableArray *goodsDataArr;
@property (nonatomic,retain) NSMutableArray *merchantsDataArr;

@end

@implementation collectionVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self createBtn];
    [self customCell];
    currentPage = 1;
    isFooterReshing = NO;
    isHeadReshing = NO;
    [self requestData];
    [self setupRefreshing];
    
    self.goodsDataArr = [[NSMutableArray alloc]init];
    self.merchantsDataArr = [[NSMutableArray alloc]init];
}

//上拉，下拉，刷新
-(void)setupRefreshing
{
    //下拉刷新
    [self.customTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    //上拉加载
    [self.customTableView addFooterWithTarget:self action:@selector(footerRefreshing)];

}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    currentPage = 1;
    
    [self.goodsDataArr removeAllObjects];
    [self.merchantsDataArr removeAllObjects];
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self.customTableView headerEndRefreshing];
    });

}

//上拉加载更多
-(void)footerRefreshing
{
   
    isFooterReshing = YES;
   
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self.customTableView footerEndRefreshing];
    });
}


-(void)requestData
{
   
    if (isHeadReshing) {
        
        currentPage = 1;
        isHeadReshing = NO;
    }
    else if(isFooterReshing)
    {
         currentPage ++;
        isFooterReshing = NO;
    }
    else
    {
        //[MBProgressHUD showError:kError];
    }

    
    
    if (collection == YES) {
        
        
        //商品请求
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *key = [info objectForKey:kKey];
        NSString *curpage = [NSString stringWithFormat:@"%i",currentPage];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",curpage,@"curpage", nil];
        [WXAFNetwork getRequestWithUrl:kGoods parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
         {
             if (isSuccessed) {
                 
                 NSNumber *code = [responseObject objectForKey:kCode];
                 
//                 NSNumber *page_total = [responseObject objectForKey:@"page_total"];
//                 NSString *hasmore = [responseObject objectForKey:@"hasmore"];
                 
                 if ([code integerValue] == 200) {
                     
                     if ([[responseObject objectForKey:kData] isKindOfClass:[NSDictionary class]]) {
                         
                         [MBProgressHUD showError:[[responseObject objectForKey:kData]objectForKey:kMessage]];
                     }

                     else
                     {
                      NSArray *data = [responseObject objectForKey:kData];
                      for (NSDictionary *dict in data) {
                         
                         goodsListModel *model = [[goodsListModel alloc]init];
                         [model setValuesForKeysWithDictionary:dict];
                         [self.goodsDataArr addObject:model];
                         
                     }
                    }
                     [self.customTableView reloadData];
                     
                 }
               
                 
                }
             else
             {
                 
                 [MBProgressHUD showError:kError];
            }
             
         }];

        
    }
    else
    {
        
        
          //店铺请求
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *key = [info objectForKey:kKey];
        NSString *page = [NSString stringWithFormat:@"%d",5];
        NSString *curpage = [NSString stringWithFormat:@"%d",currentPage];
        NSString *lng = [info objectForKey:@"lon"];
        NSString *lat = [info objectForKey:@"lat"];
        
        NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:key,@"key",page,@"page",curpage,@"curpage",lng,@"lng",lat,@"lat", nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WXAFNetwork getRequestWithUrl:kStore parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)

         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (isSuccessed) {
                 NSNumber *code = [responseObject objectForKey:kCode];
               // NSString *hasmore = [responseObject objectForKey:@"hasmore"];
               // NSString *page_total = [responseObject objectForKey:@"page_total"];
                 
                 if ([code intValue] == 200) {
                     NSLog(@"%@",responseObject);
                     
                     if ([[responseObject objectForKey:kData] isKindOfClass:[NSDictionary class]]) {
                         
                         [MBProgressHUD showError:[[responseObject objectForKey:kData]objectForKey:kMessage]];
                     }
                    else
                    {
                     
                     NSArray *data = [responseObject objectForKey:kData];
                     for (NSDictionary *dict in data) {
                         
                         merchantsModel *merchantmodel = [[merchantsModel alloc]init];
                         [merchantmodel setValuesForKeysWithDictionary:dict];
                         //[self.merchantsDataArr addObject:model];
                         [self.merchantsDataArr addObject:merchantmodel];
                         
                         NSLog(@"%@",merchantmodel);
                      }
                    }
                     [self.customTableView reloadData];
                     
                 }
                 
             }
             else
             {
                 [MBProgressHUD showError:kError];
                 
             }
         
         }];
    }

}

-(void)createUI
{
    
    collection = YES;
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 40, 0, 20, 20)];
    [button2 setImage:[UIImage imageNamed:@"本店商品列表_搜索.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = item2;    
}


-(void)createBtn
{
    goodsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, KScr_W/2 , 40)];
    [goodsBtn setTitle:@"商品" forState:UIControlStateNormal];
    [goodsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    goodsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    
    [goodsBtn addTarget:self action:@selector(goodsBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:goodsBtn];
    
    merchantsBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W/2, 5, KScr_W/2 , 40)];
    [merchantsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [merchantsBtn setTitle:@"商家" forState:UIControlStateNormal];
    merchantsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [merchantsBtn addTarget:self action:@selector(merchantsBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:merchantsBtn];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, KScr_W, 1)];
    image1.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
    [self.view addSubview:image1];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(KScr_W/2,10 , 1, 30)];
    image.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
    [self.view addSubview:image];
}

-(void)customCell
{
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, KScr_W, KScr_H - 64-45) style:UITableViewStylePlain];
    self.customTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    [self.customTableView registerNib:[UINib nibWithNibName:@"collectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"customCell"];
  
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPressGR.minimumPressDuration = 1.0;
    [self.customTableView addGestureRecognizer:longPressGR];
    
    [self.view addSubview:self.customTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (collection == YES) {
        return self.goodsDataArr.count;
    }
    else
    {
    
        return self.merchantsDataArr.count;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    collectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.moneyNoNumber.adjustsFontSizeToFitWidth = YES;
//    cell.moneyNumber.adjustsFontSizeToFitWidth = YES;
    [cell.moneyNumber setTextColor:[UIColor redColor]];
    
    if (collection == YES) {
        
        cell.pattern.hidden = NO;
        cell.moneyNumber.hidden = NO;
        cell.moneyNoNumber.hidden = NO;
        cell.moneyNoNumberImage.hidden = NO;
        cell.collectionAdress.hidden = YES;
        
        if (self.goodsDataArr.count > 0)
        {
            
            goodsListModel *model = self.goodsDataArr[indexPath.row];
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
            cell.goodsName.text = model.goods_name;
            cell.moneyNumber.text = [NSString stringWithFormat:@"￥%@", model.goods_price] ;
            cell.moneyNoNumber.text = model.goods_marketprice ;
            cell.evaluateNumber.text = [NSString stringWithFormat:@"%@人评价",model.evaluation_count ];
            cell.soldNumber.text = [NSString stringWithFormat:@"已售 %@",model.goods_salenum];
            
            NSString *m = model.evaluation_good_star;
            NSLog(@"%@",m);
            //显示星星
            for (int i = 0; i < 5; i ++)
            {
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(cell.evaluateView.frame.size.width/5 * i, 0, cell.evaluateView.frame.size.width/5, cell.evaluateView.frame.size.height)];
                
                image.image = [UIImage imageNamed:@"本店商品列表_暗五星.png"];
                image.contentMode = UIViewContentModeScaleAspectFit;
                
                [cell.evaluateView addSubview:image];
                
            }
            
            for (int n = 0; n < [m integerValue]; n ++)
            {
                
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(cell.evaluateView.frame.size.width/5 * n, 0, cell.evaluateView.frame.size.width / 5 , cell.evaluateView.frame.size.height)];
                image.image = [UIImage imageNamed:@"本店商品列表_亮五星.png"];
                image.contentMode = UIViewContentModeScaleAspectFit;
                [cell.evaluateView addSubview:image];
            }
            
        }
    
        return cell;
    }
    else
    {
        cell.pattern.hidden = YES;
        cell.moneyNumber.hidden = YES;
        cell.moneyNoNumber.hidden = YES;
        cell.moneyNoNumberImage.hidden = YES;
        cell.collectionAdress.hidden = NO;
       
        cell.collectionAdress.tintColor = kLine;
        cell.collectionAdress.font = [UIFont systemFontOfSize:Text_Big];
        
        [cell.soldNumber setTintColor:[UIColor blackColor]];
        if (self.merchantsDataArr.count > 0) {
            
            merchantsModel *model = self.merchantsDataArr[indexPath.row];
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.store_cover] placeholderImage:[UIImage imageNamed:@"200-200.png"]       options:0  completed:nil];
            cell.goodsName.text = model.store_name;
            cell.collectionAdress.text = model.address;
            if (model&&[model.store_juli floatValue] <= 1000)
            {
                cell.soldNumber.text = [NSString stringWithFormat:@"%@米",model.store_juli];
            }
            else if(model&&[model.store_juli floatValue] > 1000)
            {
                cell.soldNumber.text = [NSString stringWithFormat:@"%.2f千米",[model.store_juli floatValue]/1000];
            }
            else
            {
                cell.soldNumber.text = @"";
            }

            cell.evaluateNumber.text = [NSString stringWithFormat:@"%@人评价",model.evaluation_count];
            NSString *m = model.praise_rate;
            
            //显示星星
            for (int i = 0; i < 5; i ++) {
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(cell.evaluateView.frame.size.width/5 * i, 0, cell.evaluateView.frame.size.width/5, cell.evaluateView.frame.size.height)];
                
                image.image = [UIImage imageNamed:@"本店商品列表_暗五星.png"];
                image.contentMode = UIViewContentModeScaleAspectFit;
                
                [cell.evaluateView addSubview:image];
                
            }
            
            for (int n = 0; n < [m integerValue]; n ++) {
                
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(cell.evaluateView.frame.size.width/5 * n, 0, cell.evaluateView.frame.size.width / 5 , cell.evaluateView.frame.size.height)];
                image.image = [UIImage imageNamed:@"本店商品列表_亮五星.png"];
                image.contentMode = UIViewContentModeScaleAspectFit;
                [cell.evaluateView addSubview:image];
            }

            
        }
        
        return cell;

    }

    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collection == YES) {
        
        goodsListModel *model = self.goodsDataArr[indexPath.row];
        self.goods_id = model.goods_id;
        self.hidesBottomBarWhenPushed = YES;
        LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc]init];
        vc.goods_id = self.goods_id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        merchantsModel *model = self.merchantsDataArr[indexPath.row];
        
        self.hidesBottomBarWhenPushed = YES;
        SuShopDetailViewController *vc = [[SuShopDetailViewController alloc]init];
        vc.store_id = model.store_id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    

}


//长按弹出视图
-(void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:self.customTableView];
        indexPath1 = [self.customTableView indexPathForRowAtPoint:point];
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"删除", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"否", nil) otherButtonTitles:NSLocalizedString(@"是", nil), nil];
      
        [alter show];
        
    }


}

//删除操作
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else if ( buttonIndex == 1)
    {
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *key = [info objectForKey:kKey];
        NSString *collect_id = [[NSString alloc]init];
        NSString *fav_type = [[NSString alloc]init];
        
        if (collection == YES) {
            
           goodsListModel *model = self.goodsDataArr[indexPath1.row];
           collect_id = model.goods_id;
           fav_type = @"goods";
            
        }
        else
        {
            merchantsModel *model = self.merchantsDataArr[indexPath1.row];
            collect_id = model.store_id;
            fav_type = @"store";
        
        }
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",collect_id,@"collect_id",fav_type,@"fav_type", nil];
        [WXAFNetwork getRequestWithUrl:kDeleteKStore parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
         {
             if (isSuccessed) {
                 NSNumber *code = [responseObject objectForKey:kCode];
                 NSDictionary *data = [responseObject objectForKey:kData];
                 
                 if ([code integerValue] == 200) {
                     
                     [MBProgressHUD showSuccess:@"删除成功"];
                     if (collection == YES) {
                         
                         [self.goodsDataArr removeObjectAtIndex:indexPath1.row];
                         
                     }
                     else
                     {
                         [self.merchantsDataArr removeObjectAtIndex:indexPath1.row];
                         
                     }
                    [self.customTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:UITableViewRowAnimationAutomatic];

                 }
                 else
                 {
                     [MBProgressHUD showError:[data objectForKey:kMessage]];
                 
                 }
                 [self.customTableView reloadData];
                 
             }
             else
             {
                 [MBProgressHUD showError:kError];
             }
         }];
    }
}

//button点击事件
//点击商品
-(void)goodsBtn:(UIButton *)btn
{
    //[self.merchantsDataArr removeAllObjects];
    collection = YES;
    [self.customTableView reloadData];
    [self headerRefreshing];
    
    [goodsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
   
    [merchantsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//点击商家
-(void)merchantsBtn:(UIButton *)btn
{
     collection = NO;
    [self.customTableView reloadData];
    [self headerRefreshing];
    
    [merchantsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [goodsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
}


-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBtn:(UIButton *)btn
{
    SearchViewController *vc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

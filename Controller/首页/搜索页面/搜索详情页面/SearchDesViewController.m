//
//  SearchDesViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SearchDesViewController.h"
#import "GodsViewController.h"
#import "GodsCell.h"
#import "LHGoodsModel.h"
#import "LHGodsDetailViewController.h"
#import "GoodsCell.h"
#import "MJRefresh.h"
#import "LLHTenantCell.h"
#import "LHTenantModel.h"
#import "SuShopDetailViewController.h"
#import "StarView.h"

@interface SearchDesViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
    int  curpage;
}

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SearchDesViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    isHeaderRefresh = NO;
    isFooterRefresh = NO;
    curpage = 1;
    
    if (self.segNum == 0) {
        [self setViewTitle:@"商品列表"];

    } else if (self.segNum == 1) {
        [self setViewTitle:@"商户列表"];
    }
    
    /** 2.创建列表*/
    [self creatTableView];
    
    [self request];
    
    /** 4.刷新*/
    [self updataRefreshing];
}

- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableView];
}

/** 4.刷新*/
- (void)updataRefreshing {
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];

}

- (void)headerRefresh
{
    isHeaderRefresh = YES;
    [self request];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRefresh
{
   
    isFooterRefresh = YES;
    
    [self request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView footerEndRefreshing];
    });
}



/** 1.请求数据*/
#pragma mark- 网络请求
- (void)request
{
    if (isHeaderRefresh)
    {
        [self.dataSource removeAllObjects];
        
        curpage = 1;
        
        isHeaderRefresh = NO;
    }
    else if (isFooterRefresh)
    {
        curpage ++;
        isFooterRefresh = NO;
    }
    else
    {
        
    }
    
    NSString *url;
    NSString *keyword = [self.searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (self.segNum == 0)
    {
        url = [NSString stringWithFormat:@"%@&keyword=%@&curpage=%d",SearchGoodsUrl,keyword,curpage];
    }
    else
    {
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *lng = [info objectForKey:@"lon"];
        NSString *lat = [info objectForKey:@"lat"];
        
        url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=index&keyword=%@&lng=%@&lat=%@&curpage=%d",keyword,lng,lat,curpage];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WXAFNetwork getRequestWithUrl:url parameters:nil resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isSuccessed)
        {
            if (self.segNum == 0)
            {
                NSDictionary *dic = (NSDictionary *)responseObject;
                if (dic[@"data"][@"message"] != nil)
                {
                    [MBProgressHUD showError:@"无更多内容"];
                    
                }
                else
                {
                    NSArray* goods_listArray = dic[@"data"][@"goods_list"];
                    
                    if (goods_listArray.count < 1)
                    {
                        [MBProgressHUD showError:@"无更多内容" toView:self.view];
                    }
                    else
                    {
                        for (NSDictionary* appDic in goods_listArray)
                        {
                            LHGoodsModel* model = [[LHGoodsModel alloc] init];
                            [model setValuesForKeysWithDictionary:appDic];
                            [self.dataSource  addObject:model];
                        }
                    }
                    [self.tableView reloadData];
                }
            }
            else
            {
                NSDictionary *dataDic = [responseObject objectForKey:kData];
                
                NSArray *listArr = dataDic[@"list"];
                
                if (listArr.count < 1)
                {
                    [MBProgressHUD showError:@"无更多内容" toView:self.view];
                }
                else
                {
                    for (NSDictionary *listDesDic in listArr)
                    {
                        LHTenantModel *model = [[LHTenantModel alloc] init];
                        
                        [model setValuesForKeysWithDictionary:listDesDic];
                        [self.dataSource addObject:model];
                    }
                }
                [_tableView reloadData];
            }
            
        }
        else
        {
            [MBProgressHUD showError:kError toView:self.view];
        }
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segNum == 0)
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            
            if (self.dataSource.count > 0) {
                LHGoodsModel *model = self.dataSource[indexPath.row];
                
                UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 80, 80)];
                [iconView sd_setImageWithURL:[NSURL URLWithString:model.goods_image_url] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
                [cell.contentView addSubview:iconView];
                
                UILabel * saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 5, 80, 20)];
                saleLabel.font = [UIFont systemFontOfSize:Text_Small];
                saleLabel.textAlignment = NSTextAlignmentRight;
                saleLabel.textColor = [UIColor lightGrayColor];
                saleLabel.text = [NSString stringWithFormat:@"已售%@",model.goods_salenum];
                [cell.contentView addSubview:saleLabel];
                
                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH-100-90, 20)];
                titleLabel.text = model.goods_name;
                [cell.contentView addSubview:titleLabel];
                
                UILabel *priceLabel = [[UILabel alloc] init];
                priceLabel.textColor = [UIColor redColor];
                priceLabel.font = [UIFont systemFontOfSize:Text_Big];
                
                CGRect frame = [model.goods_price boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil];
                priceLabel.frame = CGRectMake(100, 35, frame.size.width+30, 30);
                
                priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.goods_price floatValue]];
                [cell.contentView addSubview:priceLabel];
                
                
                CGRect oldPriceFrame = [model.goods_marketprice boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Normal]} context:nil];
                
                UILabel *oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+10, 35, oldPriceFrame.size.width+20, 30)];
                oldPriceLabel.textColor = [UIColor lightGrayColor];
                oldPriceLabel.font = [UIFont systemFontOfSize:Text_Small];
                oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.goods_marketprice floatValue]];
                [cell.contentView addSubview:oldPriceLabel];
                
                UIImageView *lineImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+10, 49, oldPriceFrame.size.width+10, 1)];
                lineImageView.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lineImageView];
                
                
                StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(100, 75, 150, 25)];
                [starView setStar:[model.evaluation_good_star floatValue]];
                [cell.contentView addSubview:starView];
                
                UILabel * commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 75, 80, 25)];
                commentLabel.font = [UIFont systemFontOfSize:Text_Small];
                commentLabel.textAlignment = NSTextAlignmentRight;
                commentLabel.textColor = [UIColor lightGrayColor];
                commentLabel.text = [NSString stringWithFormat:@"%@人评价",model.goods_salenum];
                [cell.contentView addSubview:commentLabel];
            }
            
            
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            if (self.dataSource.count > 0)
            {
                LHTenantModel *model = self.dataSource[indexPath.row];
                
                UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
                [headerView sd_setImageWithURL:[NSURL URLWithString:model.store_cover] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
                [cell.contentView addSubview:headerView];
                
                /** 标题*/
                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)+5, 10, 120, 30)];
                titleLabel.font = [UIFont systemFontOfSize:20];
                titleLabel.text = model.store_name;
                [cell.contentView addSubview:titleLabel];
                
                /** 距离*/
                UILabel * jiliLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+30, 10, 80, 30)];
                jiliLabel.font = [UIFont systemFontOfSize:Text_Big];
                
                if([model.juli floatValue] >=1000 )
                {
                    jiliLabel.text = [NSString stringWithFormat:@"%.2f千米",[model.juli floatValue]/1000];
                }
                else
                {
                    jiliLabel.text = [NSString stringWithFormat:@"%@米",model.juli ];
                }
                
                [cell.contentView addSubview:jiliLabel];
                
                /** 详细地址*/
                UILabel * detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)+10, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH-CGRectGetMaxX(headerView.frame)-20, 40)];
                detailLabel.font = [UIFont systemFontOfSize:Text_Normal];
                detailLabel.numberOfLines = 0;
                detailLabel.text = model.store_address;
                [cell.contentView addSubview:detailLabel];
                
                /** 评分星级*/
                StarView * starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)+5, CGRectGetMaxY(detailLabel.frame), 100, 25)];
                [starView setStar:[model.seval_total intValue]];
                [cell.contentView addSubview:starView];
                
                /** 评价人数*/
                UILabel * pingjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(detailLabel.frame), 100, 25)];
                pingjiaLabel.textColor = [UIColor grayColor];
                pingjiaLabel.text = [NSString stringWithFormat:@"%@人评价", model.seval_num];
                pingjiaLabel.font = [UIFont systemFontOfSize:Text_Big];
                [cell.contentView addSubview:pingjiaLabel];
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segNum == 0)
    {
        return 100;
    }
    else
    {
        return 120;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segNum == 0)
    {
        LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
        LHGoodsModel* model = self.dataSource[indexPath.row];
        vc.goods_id = model.goods_id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:YES];
     
    }
    else
    {
        /** cell选中后颜色消失*/
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        SuShopDetailViewController* vc = [[SuShopDetailViewController alloc] init];
        LHTenantModel* model = self.dataSource[indexPath.row];
        vc.store_id = model.store_id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 1)];
    imageView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [footerView addSubview:imageView];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

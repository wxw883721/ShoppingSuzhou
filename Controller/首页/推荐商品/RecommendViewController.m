//
//  RecommendViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RecommendViewController.h"
#import "LHFirstPageModel.h"
#import "MBProgressHUD+MJ.h"
#import "LHGodsDetailViewController.h"
#import "LHGoodsModel.h"
#import "StarView.h"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
}
@property (nonatomic,strong) NSMutableArray *goodsArray;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _goodsArray = [[NSMutableArray alloc] init];
    
    currentPage = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createNavgation];
    
    [self createTableView];
    
    [self request];
    
    [self setupRefreshing];
}

//上拉，下拉刷新
-(void)setupRefreshing
{
    
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
//    
//    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    
    currentPage = 1;
    [self request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
        
    });
    
}

//上拉加载更多
-(void)footerRefreshing
{
    isFooterReshing = YES;
    
    [self request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
    });
}


- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain ];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"goodCell"];
    
    [self.view addSubview:self.tableView];
}


- (void)request
{
    if (isHeadReshing) {
        
        currentPage = 1;
        isHeadReshing = NO;
        [_goodsArray removeAllObjects];
        
    }
    else if(isFooterReshing)
    {
        currentPage ++;
        isFooterReshing = NO;
    }
    else
    {
        
    }
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?curpage=%d&page=10",SHOUYE_URL,currentPage];
    
    [self cacheWithUrl:url target:self action:@selector(analyze:)];
    
}

- (void)analyze:(NSData*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary* datasDic = dic[@"data"];
  
    if (datasDic[@"goods"] == nil || datasDic[@"goods"] == [NSNull null])
    {
        [MBProgressHUD showError:@"无更多内容"];
    }
    else
    {
        //解析推荐商品
        NSArray* goodsArray = datasDic[@"goods"];
        
        if (goodsArray.count < 1)
        {
            [MBProgressHUD showError:@"无更多内容"];
        }
        else
        {
            for (NSDictionary* appDic in goodsArray)
            {
                 LHGoodsModel * model = [[LHGoodsModel alloc] init];
                [model setValuesForKeysWithDictionary:appDic];
                [_goodsArray addObject:model];
            
            }
            [_tableView reloadData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _goodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"goodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        if (_goodsArray.count <= 0)
        {
            
        }
        else
        {
            LHGoodsModel *model = _goodsArray[indexPath.row];
            UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 80, 80)];
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@",model.goods_image];
            
            [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
            
            NSLog(@"%@",model.goods_image_url);
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
            priceLabel.font = [UIFont systemFontOfSize:20];
            
            CGRect frame = [model.goods_price boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
            priceLabel.frame = CGRectMake(100, 25, frame.size.width+30, 30);
            
            priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.goods_price floatValue]];
            [cell.contentView addSubview:priceLabel];
            
            
            NSString *oldPriseStr = [NSString stringWithFormat:@"原价:%.2f", [model.goods_marketprice floatValue]];
            CGFloat oldPriseLabelW = [oldPriseStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Normal]} context:nil].size.width;
            
            UILabel * _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+10, 32, oldPriseLabelW, 20)];
            _oldPriceLabel.font = [UIFont systemFontOfSize:Text_Normal];
            _oldPriceLabel.textColor = [UIColor lightGrayColor];
            _oldPriceLabel.text = oldPriseStr;
            [cell.contentView addSubview:_oldPriceLabel];
            
            // 原价删除线
            UILabel * label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor lightGrayColor];
            label.frame =CGRectMake(CGRectGetMinX(_oldPriceLabel.frame), CGRectGetMidY(_oldPriceLabel.frame), CGRectGetWidth(_oldPriceLabel.frame), 1);
            [cell.contentView addSubview:label];
            
            StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(100, 75, 150, 25)];
            [starView setStar:[model.evaluation_good_star floatValue]];
            [cell.contentView addSubview:starView];
            
            UILabel * commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 75, 80, 25)];
            commentLabel.font = [UIFont systemFontOfSize:Text_Small];
            commentLabel.textAlignment = NSTextAlignmentRight;
            commentLabel.textColor = [UIColor lightGrayColor];
            commentLabel.text = [NSString stringWithFormat:@"%@人评价",model.evaluation_count];
            [cell.contentView addSubview:commentLabel];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHFirstPageModel *model = _goodsArray[indexPath.row];
    LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:NO];
}


- (void)createNavgation
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.text = @"推荐商品";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor  = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

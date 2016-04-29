//
//  LHRecommendViewController.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHRecommendViewController.h"
#import "goodsListModel.h"
#import "StarView.h"
#import "LHGodsDetailViewController.h"

@interface LHRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
}

@property (nonatomic,strong) NSMutableArray *tableSource;

@property (nonatomic,strong) NSMutableString *order;

@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UIButton *typeButton;

@property (nonatomic,strong) UITableView *typeTableView;


@end

@implementation LHRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _order = [NSMutableString stringWithFormat:@"%d",1];
    currentPage = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createNavgation];
    
    [self createHeaderView];
    
    self.tableSource = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    [self request:@"1"];
    
    [self setupRefreshing];
}

//上拉，下拉刷新
-(void)setupRefreshing
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
//    
//    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    
    currentPage = 1;
    [self request:_order];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
        
    });
    
}

//上拉加载更多
-(void)footerRefreshing
{
    isFooterReshing = YES;
    [self request:_order];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
    });
}


//创建表格
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-120) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 90002;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"goodCell"];
    
    [self.view addSubview:self.tableView];
}



#pragma mark - 网络请求
- (void)request:(NSString *)order
{
    if (isHeadReshing) {
        
        currentPage = 1;
        isHeadReshing = NO;
        [_tableSource removeAllObjects];
        
    }
    else if(isFooterReshing)
    {
        currentPage ++;
        isFooterReshing = NO;
    }
    else
    {
        
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * url = [NSString stringWithFormat:@"%@%@&order=%@&curpage=%d",SHOP_Recommend_URL,self.store_id,order,currentPage];
    
    NSLog(@"%@",url);
    
    [self cacheWithUrl:url target:self action:@selector(analyze:)];
}

//解析数据
- (void)analyze:(NSData *)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *dataDic = dic[kData];
    NSArray *listArr = dataDic[@"list"];
    
    if (listArr.count < 1) {
        [MBProgressHUD showError:@"无更多内容"];
    }
    
    for (NSDictionary *appDic in listArr) {
        
        goodsListModel *model = [[goodsListModel alloc] init];
        
        [model setValuesForKeysWithDictionary:appDic];
        [self.tableSource addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 90001) {
        return 5;
    }
    else
        return self.tableSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 90001) {
        return 45;
    }
    else
        return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 90001)
    {
        NSArray *titleArr = @[@"销量最高",@"评价最好",@"价格最高",@"价格最低",@"最新上架"];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 45)];
        
        label.textColor = [UIColor blueColor];
        label.text = titleArr[indexPath.row];
        [cell.contentView addSubview:label];
        
        return cell;
    }
    else
    {
        static NSString *identifier = @"goodCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            
            if(self.tableSource.count > 0)
            {
                goodsListModel *model = self.tableSource[indexPath.row];
                
                UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 80, 80)];
                [iconView sd_setImageWithURL:[NSURL URLWithString:model.goods_image]  placeholderImage:[UIImage imageNamed:@"200-200.png"]];
                [cell.contentView addSubview:iconView];
                
                UILabel * saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 5, 80, 20)];
                saleLabel.font = [UIFont systemFontOfSize:Text_Small];
                saleLabel.textAlignment = NSTextAlignmentRight;
                saleLabel.textColor = [UIColor lightGrayColor];
                saleLabel.text = [NSString stringWithFormat:@"已售%@",model.goods_salenum];
                [cell.contentView addSubview:saleLabel];
                
                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH-100-90, 20)];
                titleLabel.text = model.goods_name;
                titleLabel.font = [UIFont systemFontOfSize:Text_Big];
                [cell.contentView addSubview:titleLabel];
                
                UILabel *priceLabel = [[UILabel alloc] init];
                priceLabel.textColor = [UIColor redColor];
                priceLabel.font = [UIFont systemFontOfSize:17];
                
                CGRect frame = [model.goods_price boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
                priceLabel.frame = CGRectMake(100, 25, frame.size.width+30, 30);
                
                priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.goods_price floatValue]];
                [cell.contentView addSubview:priceLabel];
                
                
                UILabel *oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+10, 25, 200, 30)];
                oldPriceLabel.textColor = [UIColor lightGrayColor];
                oldPriceLabel.font = [UIFont systemFontOfSize:Text_Small];
                oldPriceLabel.text = [NSString stringWithFormat:@"￥%2.f",[model.goods_marketprice floatValue]];
                [cell.contentView addSubview:oldPriceLabel];
                
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 90001)
    {
        NSArray *titleArr = @[@"销量最高",@"评价最好",@"价格最高",@"价格最低",@"最新上架"];
        _typeButton.selected = NO;
        _typeLabel.text = @"";
        _typeLabel.text = titleArr[indexPath.row];
        
        [tableView removeFromSuperview];
        
        _order = [NSMutableString stringWithFormat:@"%d",indexPath.row+1];
        currentPage=1;
        if (self.tableSource) {
            [self.tableSource removeAllObjects];
        }
        [self request:_order];
        
    }
    else
    {
        goodsListModel *model = self.tableSource[indexPath.row];
        
        LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
        vc.goods_id = model.goods_id;
        
        [self.navigationController pushViewController:vc animated:NO];
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 顶部视图的创建
- (void)createHeaderView
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.view addSubview:headerView];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2, 49)];
    _typeLabel.text = @"销量最高";
    [headerView addSubview:_typeLabel];
    
    _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeButton.frame = CGRectMake(SCREEN_WIDTH-50, 10, 30, 30);
//    _typeButton.backgroundColor = [UIColor redColor];
    [_typeButton setImage:[UIImage imageNamed:@"grayjiantou"] forState:UIControlStateNormal];
    [_typeButton setImage:[UIImage imageNamed:@"jiantou2"] forState:UIControlStateSelected];
    _typeButton.layer.cornerRadius = 10;
    [_typeButton addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_typeButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    imageView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [headerView addSubview:imageView];
}

//点击headerView的按钮触发的方法
- (void)typeAction:(UIButton *)sender
{
    //如果self.view中存在_typeTableView
    if ([self.view viewWithTag:90001])
    {
        [_typeTableView removeFromSuperview];
        _typeButton.selected = YES;
    }
    else
    {
        _typeButton.selected = NO;
//        _typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 50, SCREEN_WIDTH/2-30, 180) style:UITableViewStylePlain];
        _typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 225) style:UITableViewStylePlain];
        _typeTableView.delegate = self;
        _typeTableView.dataSource = self;
        
        [_typeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"typeCell"];
        _typeTableView.tag = 90001;
        
        [self.view addSubview:_typeTableView];
    }
    _typeButton.selected = !_typeButton.selected;
}

//创建导航栏
- (void)createNavgation
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.text = @"推荐商品";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor  = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLabel;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITableView *tableView = (UITableView *)[self.view viewWithTag:90001];
    [tableView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  XianShiViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "XianShiViewController.h"
#import "LHGodsDetailViewController.h"
#import "XianshiModel.h"
#import "XianshiCell.h"
#import "StarView.h"

@interface XianShiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
}

@property (nonatomic,strong) NSMutableArray *tableSource;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XianShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewTitle:@"限时活动"];
    
    
    _tableSource = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    currentPage = 1;
    isFooterReshing = NO;
    isHeadReshing = NO;
    [self requestData];
    [self setupRefreshing];
    
}

//上拉，下拉刷新
-(void)setupRefreshing
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
//    
//    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    
    currentPage = 1;
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
    
}

//上拉加载更多
-(void)footerRefreshing
{
    isFooterReshing = YES;
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
    });
}

- (void)requestData
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
    
    NSString *page = [NSString stringWithFormat:@"%d",currentPage];
    
    NSString *url = [NSString stringWithFormat:@"%@&curpage=%@",XianShi_URL,page];
    NSLog(@"%@",url);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self cacheWithUrl:url target:self action:@selector(ansylized:)];
}

- (void)ansylized:(NSData *)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *dataDic = dic[@"data"];
    
    NSLog(@"%@",dataDic);
    
    NSString *message = [dataDic objectForKey:kMessage];
    
    if (!message||message.length < 1) {
        
        NSArray *listArr = dataDic[@"list"];
        for (NSDictionary *dic in listArr) {
            
            XianshiModel *model = [[XianshiModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_tableSource addObject:model];
        }
        [self.tableView reloadData];
        
    }
    
    else
    {
        [MBProgressHUD showError:@"暂无活动"];
    }
    
    
}


- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[XianshiCell class] forCellReuseIdentifier:@"xianshiCell"];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    static NSString *identifier = @"xianshiCell";
    
    XianshiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[XianshiCell alloc] init];
    }
    else
    {
        
        XianshiModel *model = _tableSource[indexPath.row];
        
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
        
        cell.titleLabel.text = model.goods_name;
        //  添加星星
        [cell.starView setStar:[model.star floatValue]];
        
        cell.discountLabel.text = model.discount;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",model.cur_price];
//        cell.oldPriceLabel.text = [NSString stringWithFormat:@"￥ %@",model.goods_price];
        
        NSString *oldPriseStr = [NSString stringWithFormat:@"原价:%@", model.goods_price];
        CGFloat oldPriseLabelW = [oldPriseStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Normal]} context:nil].size.width;
        
        UILabel * _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+20, 40, oldPriseLabelW, 20)];
        _oldPriceLabel.font = [UIFont systemFontOfSize:Text_Normal];
        _oldPriceLabel.textColor = [UIColor lightGrayColor];
        _oldPriceLabel.text = oldPriseStr;
        [cell.contentView addSubview:_oldPriceLabel];
        
        // 原价删除线
        UILabel * label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.frame =CGRectMake(CGRectGetMinX(_oldPriceLabel.frame), CGRectGetMidY(_oldPriceLabel.frame), CGRectGetWidth(_oldPriceLabel.frame), 1);
        [cell.contentView addSubview:label];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 99, SCREEN_WIDTH-15, 1)];
        lineImageView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [cell.contentView addSubview:lineImageView];
        
        cell.timeLabel.text = [NSString stringWithFormat:@"截止时间：%@",model.end_time];
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     XianshiModel *model = _tableSource[indexPath.row];
    LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:NO];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 1)];
    footerView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (void)didReceiveMemoryWarning {
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

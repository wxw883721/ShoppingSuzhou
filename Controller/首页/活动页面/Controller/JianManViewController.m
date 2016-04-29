//
//  JianManViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "JianManViewController.h"
#import "ManjianModel.h"
#import "ManjianCell.h"
#import "UIImageView+WebCache.h"
#import "StarView.h"
#import "SuShopDetailViewController.h"

@interface JianManViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
}
@property (nonatomic,strong) NSMutableArray *tableSource;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation JianManViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewTitle:@"减满优惠"];
    
    
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
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
        
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
    
    NSString *url = [NSString stringWithFormat:@"%@&curpage=%@",ManJian_URL,page];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self cacheWithUrl:url target:self action:@selector(ansylized:)];
}

- (void)ansylized:(NSData *)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
     if ([dic[@"data"] isKindOfClass:[NSArray class]])
     {
         NSArray *dataArr = dic[@"data"];
         
         for (NSDictionary *dic in dataArr) {
             ManjianModel *model = [[ManjianModel alloc] init];
             [model setValuesForKeysWithDictionary:dic];
             [_tableSource addObject:model];
         }
         [self.tableView reloadData];
     }
    
    else
    {
        NSDictionary *dataDic = dic[@"data"];
        
        NSString *message = dataDic[kMessage];
        
        [MBProgressHUD showError:message];
    }
}


- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[ManjianCell class] forCellReuseIdentifier:@"manjianCell"];
    
    [self.view addSubview:_tableView];
}

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
    static NSString *identifier = @"manjianCell";
    
    ManjianCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ManjianCell alloc] init];
    }
    else
    {
        ManjianModel *model = _tableSource[indexPath.row];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.store_cover] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
        cell.titleLabel.text = model.store_name;
        cell.saleNumLbl.text = [NSString stringWithFormat:@"已售%@",model.store_sales];
        cell.addressLabel.text = model.store_address;
        [cell.starView setStar:[model.total_score floatValue]];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@人评价",model.total_num];
        //cell.descriptionLabel.text = model.store_description;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManjianModel *model = _tableSource[indexPath.row];
    
    SuShopDetailViewController *vc = [[SuShopDetailViewController alloc] init];
    vc.store_id = model.store_id;
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
    return 1;
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

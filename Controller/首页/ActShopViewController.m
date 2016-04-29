//
//  ActShopViewController.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/7/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ActShopViewController.h"
#import "ActShopCell.h"
#import "ActShopModel.h"
#import "LHGodsDetailViewController.h"

@interface ActShopViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isHeadReshing;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) ActShopModel *model;

@end

@implementation ActShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setViewTitle:self.titleStr];
    
    isHeadReshing = NO;
    
    [self creatTableView];
    [self request];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefersh)];
}

- (void)headerRefersh
{
    [self.dataSource removeAllObjects];
    
    isHeadReshing = YES;
    [self request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
    });
}


- (void)creatHeadLabel {
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 24)];
    label1.font = [UIFont systemFontOfSize:Text_Normal];
    label1.textColor = [UIColor blueColor];
    [self.view addSubview:label1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_HEIGHT, 1)];
    imageView.backgroundColor = [UIColor hexChangeFloat:@"e2e2e2"];
    [self.view addSubview:imageView];
    
     label1.text = (_model.activity_start_date == nil || _model.activity_start_date.length == 0) ? @"未知日期" : [NSString stringWithFormat:@"%@ 至 %@", _model.activity_start_date,_model.activity_end_date];

}

- (void)creatTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, SCREEN_HEIGHT-40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)request
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self cacheWithUrl:[NSString stringWithFormat:ACT_URL, self.myId] target:self action:@selector(analyze:)];
}

- (void)analyze:(NSData *)data {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *dict = dic[@"data"][@"activity"];
    _timeArray = [NSMutableArray array];
    _model = [[ActShopModel alloc] init];
    [_model setValuesForKeysWithDictionary:dict];
    [self creatHeadLabel];
    
    
    if (dic[@"data"][@"list"] != [NSNull null])
    {
        NSArray *array = dic[@"data"][@"list"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *listDict in array)
        {
            ActShopModel *model = [[ActShopModel alloc] init];
            [model setValuesForKeysWithDictionary:listDict];
            [arr addObject:model];
        }
        [self.dataSource addObject:arr];
    }
    
    if (self.dataSource)
    {
        [self.tableView reloadData];
    }
    if (dic[@"data"][@"list"] == [NSNull null])
    {
        [MBProgressHUD showError:@"暂无数据"];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActShopCell *cell = [ActShopCell cellWithTable:tableView];
    ActShopModel *model = [self.dataSource lastObject][indexPath.row];
    cell.shopModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSource lastObject] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];

    fmt.dateFormat = @"yyyy-MM-dd";
    
    //开始时间
    NSDate *creatDate = [fmt dateFromString:_model.activity_start_date];
    //当前时间
    NSDate *nowDate = [NSDate date];
    
    NSDate *date = [creatDate laterDate:nowDate];
    
    if ([date isEqualToDate:nowDate])
    {
        LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
        ActShopModel *model = [self.dataSource lastObject][indexPath.row];
        vc.goods_id = model.goods_id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [MBProgressHUD showError:@"活动未开始"];
    }
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

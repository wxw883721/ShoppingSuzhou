//
//  NewsViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "NewsDesViewController.h"
#import "LHNewsModel.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.HideTarbar = YES;
    [self getHeight:100];
    [self createNavgation];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self request:1];
    [self registCellWithClass:[NewsCell class] identifer:@"NewsCell"];
    
    
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
}

- (void)headerRefresh
{
    [self.dataSource removeAllObjects];
    [self request:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRefresh {
    static int page = 2;
    [self request:page];
    page++;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView footerEndRefreshing];
    });
    
}

- (void)request:(int)page
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self RequestWithURL:[NSString stringWithFormat:NEWS_URL,page] target:self action:@selector(analyze:)];
}

- (void)analyze:(NSData*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
        [MBProgressHUD showError:@"无更多内容"];
        [self.tableView footerEndRefreshing];
    } else {
        NSArray* dataArray = dic[@"data"];
        for (NSDictionary* appDic in dataArray) {
            LHNewsModel* model = [[LHNewsModel alloc] init];
            [model setValuesForKeysWithDictionary:appDic];
            [self.dataSource addObject:model];
            
        }
        [self.tableView reloadData];
    }
    
    
    [self.tableView headerEndRefreshing];
}

- (void)updataWithCell:(UITableViewCell *)cell WithModel:(RootModel *)model
{
    if ([cell isMemberOfClass:[NewsCell class]] && [model isMemberOfClass:[LHNewsModel class]]) {
        LHNewsModel* model1 = (LHNewsModel*)model;
        NewsCell* cell1 = (NewsCell*)cell;
        cell1.titleLabel.text = model1.news_title;
        cell1.datelabel.text = model1.news_addtime;
       
    }
}

- (void)createNavgation
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.text = @"资讯新闻";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor  = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLabel;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDesViewController *vc = [[NewsDesViewController alloc] init];
    
    LHNewsModel *model = self.dataSource[indexPath.row];
    vc.news_id = model.news_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ChoiceShopViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ChoiceShopViewController.h"
#import "LHTenantCell.h"
#import "LLHTenantCell.h"

#import "LHTenantModel.h"
#import "SuShopDetailViewController.h"
#import "StarView.h"
@interface ChoiceShopViewController ()
{
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
}


@end

@implementation ChoiceShopViewController


- (void)viewDidLoad {
    self.HideTarbar = YES;
//        self.headerHeight = 45;
//        self.headerView = [self getHeaderView];
    [self setViewTitle:@"精选商户"];
        
    self.y = 0;
        
    [self request];
    currentPage = 1;
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self getHeight:120];
    
    [self setupRefreshing];
}

//上拉，下拉刷新
-(void)setupRefreshing
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    
    currentPage = 1;
    [self request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
        
    });
    
}

//上拉加载更多
-(void)footerRefreshing
{
    isFooterReshing = YES;
    
    [self request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.tableView footerEndRefreshing];
    });
}


#pragma mark- 网络请求
- (void)request
{
    if (isHeadReshing) {
        
        currentPage = 1;
        isHeadReshing = NO;
        [self.dataSource removeAllObjects];
        
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
    NSString *url = [NSString stringWithFormat:@"http://bgsz.tv/mobile/index.php?act=stores&op=store_choiceness&curpage=%d&page=10", currentPage];
    
    [self cacheWithUrl:url target:self action:@selector(analyze:)];
    //    [self cacheWithUrl:[NSString stringWithFormat:TENANT_URL, page, self.okword] target:self action:@selector(analyze:)];
}

#pragma mark- 解析数据
- (void)analyze:(NSData*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",dic);
    
    
    NSArray *arr = (NSArray *)dic[@"data"][@"list"];
    
    if ( arr.count < 1)
    {
        [MBProgressHUD showError:@"已是最后一页"];
    }
    else
    {
        NSArray* listArray = dic[@"data"][@"list"];
        for (NSDictionary* appDic in listArray)
        {
            LHTenantModel* model = [[LHTenantModel alloc] init];
            [model setValuesForKeysWithDictionary:appDic];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLHTenantCell *cell = (LLHTenantCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[LLHTenantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@",indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataSource.count > 0)
    {
        LHTenantModel *model = self.dataSource[indexPath.row];
        cell.tenantModel = model;
        
        cell.jiliLabel.hidden = YES;
        
        UILabel *salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScr_W-65, 10, 65, 20)];
        salesLabel.text = ([model.store_sales integerValue] > 0 || model.store_sales != nil || model.store_sales.length > 0) ? [NSString stringWithFormat:@"已售%d", [model.store_sales intValue]] : @"0";
        salesLabel.textAlignment = NSTextAlignmentLeft;
        salesLabel.font = [UIFont systemFontOfSize:Text_Normal];
        [cell.contentView addSubview:salesLabel];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** cell选中后颜色消失*/
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SuShopDetailViewController* vc = [[SuShopDetailViewController alloc] init];
    LHTenantModel* model = self.dataSource[indexPath.row];
    vc.store_id = model.store_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:YES];
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

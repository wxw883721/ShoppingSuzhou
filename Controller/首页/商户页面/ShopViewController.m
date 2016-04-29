//
//  ShopViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ShopViewController.h"
#import "LHTenantCell.h"
#import "LLHTenantCell.h"

#import "LHTenantModel.h"
#import "SuShopDetailViewController.h"
#import "StarView.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

- (void)viewDidLoad {
    self.HideTarbar = YES;
    if (self.id == nil) {
//        self.headerHeight = 45;
//        self.headerView = [self getHeaderView];
        [self setViewTitle:@"商户"];
        
        self.y = 40;
        
        [self request:0];
        [self creatButton];
    } else {
        [self createNavgation1];
        [self request1];
    }
    
    
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    [self getHeight:120];
    
//    [self registCellWithNibName:@"LHTenantCell" identifer:@"lhTenantCell"];
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    
}

- (void)headerRefresh {
    [self request:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
}
- (void)footerRefresh {
    static int page = 1;
    [self request:page];
    page ++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.tableView footerEndRefreshing];
    });
}

- (void)request1
{
    [self cacheWithUrl:[NSString stringWithFormat:STREET_URL,self.id] callback:^(NSData *data) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSArray* listArr = dic[@"data"][@"list"];
//        for (NSDictionary* appDic in listArr) {
//            LHTenantModel* model = [[LHTenantModel alloc] init];
//            [self.dataSource addObject:model];
//        }
        [self analyze:data];
        
    }];
}

#pragma mark- 网络请求
- (void)request:(int)page
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self cacheWithUrl:[NSString stringWithFormat:TENANT_URL_1, page] target:self action:@selector(analyze:)];
//    [self cacheWithUrl:[NSString stringWithFormat:TENANT_URL, page, self.okword] target:self action:@selector(analyze:)];
}

#pragma mark- 解析数据
- (void)analyze:(NSData*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray* listArray = dic[@"data"][@"list"];
    if (listArray.count < 1) {
        [MBProgressHUD showError:@"已是最后一页"];
         [self.tableView footerEndRefreshing];
    } else {
        
        for (NSDictionary* appDic in listArray) {
            LHTenantModel* model = [[LHTenantModel alloc] init];
            [model setValuesForKeysWithDictionary:appDic];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
}

#pragma mark- 获取表格头
- (UIView*)getHeaderView
{
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    backView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    NSArray* textArray = @[@"全部分类",@"全部分类"];
    for (int i=0; i<2; i++) {
        UIButton* btn = [LHTool ButtonWithFrame:CGRectMake(SCREEN_WIDTH/2*i+5, 0, SCREEN_WIDTH/2-10, 45) image:nil title:nil titleColor:[UIColor grayColor] target:self action:@selector(btnPress:)];
        btn.tag = 11+i;
        UILabel* label = [LHTool LabelWithFrame:CGRectMake((SCREEN_WIDTH/4-55), 5, 100, 35) Font:[UIFont boldSystemFontOfSize:20] TextColor:[UIColor grayColor] TextPosin:NSTextAlignmentCenter BackgourndColor:nil text:textArray[i]];
        label.alpha = 1;
        if (i ==0) {
            label.textColor = [UIColor redColor];
        }
        label.tag = 21+i;
        [btn addSubview:label];
        UIImageView* smallView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+65, 12, 20, 20)];
        smallView.image = [UIImage imageNamed:@"商户_03"];
        smallView.tag = 31+i;
        if (i == 0) {
            smallView.image = [UIImage imageNamed:@"商户_05"];
        }
        [btn addSubview:smallView];
        [backView addSubview:btn];
    }
    return backView;
}

- (void)creatButton {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-5, 40)];
    [button1 setTitle:@"店铺分类" forState:UIControlStateNormal];
    button1.tag = 20;
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+5, 0, SCREEN_WIDTH/2-1, 40)];
    [button2 setTitle:@"商圈" forState:UIControlStateNormal];
    button2.tag = 21;
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor grayColor];
    [view addSubview:button2];
    
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)sender {
    
    if (sender.tag == 20) {
        
    } else {
        
    }
}

- (void)btnPress:(UIButton*)sender
{
    UILabel* label1 = (UILabel*)[self.view viewWithTag:21];
    UILabel* label2 = (UILabel*)[self.view viewWithTag:22];
    UIImageView* smallView1 = (UIImageView*)[self.view viewWithTag:31];
    UIImageView* smallView2 = (UIImageView*)[self.view viewWithTag:32];
    if (sender.tag == 11) {
        label1.textColor = [UIColor redColor];
        label2.textColor = [UIColor grayColor];
        smallView1.image = [UIImage imageNamed:@"商户_05"];
        smallView2.image = [UIImage imageNamed:@"商户_03"];
    }else{
        label1.textColor = [UIColor grayColor];
        label2.textColor = [UIColor redColor];
        smallView1.image = [UIImage imageNamed:@"商户_03"];
        smallView2.image = [UIImage imageNamed:@"商户_05"];
    }
}

////重写父类填充数据
//- (void)updataWithCell:(UITableViewCell*)cell WithModel:(RootModel*)model
//{
//    if ([cell isMemberOfClass:[LHTenantCell class]]&& [model isMemberOfClass:[LHTenantModel class]]) {
//        LHTenantCell* tenantCell = (LHTenantCell*)cell;
//        LHTenantModel* tenantModel = (LHTenantModel*)model;
//       
//        [tenantCell.headerImage sd_setImageWithURL:[NSURL URLWithString:tenantModel.store_cover]];
//        tenantCell.titleLabel.text = tenantModel.store_name;
//        tenantCell.detailLabel.text = tenantModel.store_address;
//        if (tenantModel.juli) {
//            tenantCell.juliLabel.text = [NSString stringWithFormat:@"%@m",[tenantModel.juli stringValue]];
//        }
//        
//        tenantCell.pinjiaLabel.text = [NSString stringWithFormat:@"%@人评价",tenantModel.seval_num];
//        [tenantCell.starView setStar:[tenantModel.seval_total floatValue]];
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLHTenantCell *cell = (LLHTenantCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[LLHTenantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@",indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    LLHTenantCell *cell = [LLHTenantCell cellWithtableView:tableView];
    
    LHTenantModel *model = self.dataSource[indexPath.row];
    cell.tenantModel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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

- (void)createNavgation1
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.text = @"推荐商户";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor  = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLabel;
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

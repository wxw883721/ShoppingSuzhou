//
//  GodsViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "GodsViewController.h"
#import "GodsCell.h"
#import "LHGoodsModel.h"
#import "LHGodsDetailViewController.h"
#import "GoodsCell.h"
#import "zijian2Model.h"
#import "zijianModel.h"
//#import "SortView.h"
#import "MJRefresh.h"

@interface GodsViewController ()

{
    BOOL flag1;
    BOOL flag2;
}

@end


@implementation GodsViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}




- (void)viewDidLoad {
    
    [self setViewTitle:@"商品"];
    self.HideTarbar = YES;
    self.y = 40;
    self.headerHeight = 45;
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self registCellWithNibName:@"GodsCell" identifer:@"GodsCell"];
    [self getHeight:120];
   
    /** 1.请求数据*/
    [self request:1];
//    [self creatSortView];
    /** 2.创建顶部按钮*/
    [self creatButton];
    /** 3.创建ziview*/
    [self creatSubTableView];
    
    /** 4.刷新*/
    [self updataRefreshing];
    
    /** 5.请求分类数据*/
    [self requestData];
}
/** 5.请求分类数据*/
- (void)requestData {
    self.businessArr = [[NSArray alloc]init];
    self.businessArr = @[@"默认",@"销量",@"浏览量",@"价格"];
    
    if (!self.classificationArr) {
        self.classificationArr = [[NSMutableArray alloc]init];
    }
    [self.classificationArr removeAllObjects];
    
    [self cacheWithUrl:[NSString stringWithFormat:SORT_URL, self.gc_id] target:self action:@selector(downloaddata:)];
    
}


- (void)downloaddata:(NSData *)data {
     NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *sortArray = dic[@"data"][@"class_list"];
 
        _classificationArr = [NSMutableArray array];
        for (NSDictionary *dic in sortArray) {
            zijianModel *model = [[zijianModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_classificationArr addObject:model];
        }
        
        [_oneCustomTableView reloadData];

}
 /** 4.刷新*/
- (void)updataRefreshing {
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)headerRefreshing {
    [self request:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing {
    static int page = 1;
    [self request:page];
    page++;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView footerEndRefreshing];
    });
}


/** 3.创建子view*/
- (void)creatSubTableView {
    self.tableView.tag = 4;
    
    self.oneCustomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/2, 200)];
    self.oneCustomTableView.dataSource = self;
    self.oneCustomTableView.delegate = self;
    self.oneCustomTableView.hidden = YES;
//    self.oneCustomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.oneCustomTableView.tag = 1;
    self.oneCustomTableView.showsHorizontalScrollIndicator = NO;
    self.oneCustomTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.oneCustomTableView];
    
    self.twoCustomTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 40, SCREEN_WIDTH/2, 200)];
    self.twoCustomTableView.dataSource = self;
    self.twoCustomTableView.delegate = self;
    self.twoCustomTableView.hidden = YES;
    self.twoCustomTableView.tag = 2;
//    self.twoCustomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.twoCustomTableView.showsHorizontalScrollIndicator = NO;
    self.twoCustomTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.twoCustomTableView];
    
    self.businessCustomTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 40, SCREEN_WIDTH/2, 200)];
    self.businessCustomTableView.dataSource = self;
    self.businessCustomTableView.delegate = self;
    self.businessCustomTableView.hidden = YES;
    self.businessCustomTableView.tag = 3;
//    self.businessCustomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.businessCustomTableView.showsHorizontalScrollIndicator = NO;
    self.businessCustomTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.businessCustomTableView];

}



//- (void)creatSortView {
//
//    _sortView = [[SortView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-64)];
//    _sortView.hidden = YES;
//    [self.view addSubview:_sortView];
////    NSLog(@"%@",_sortView.gc_id);
//}

/** 1.请求数据*/
#pragma mark- 网络请求
- (void)request:(int)page
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self cacheWithUrl:[NSString stringWithFormat:GOODS_URL,page, self.okwords, self.order, self.gc_id_1, self.gc_id_2] target:self action:@selector(analyze:)];
}

#pragma mark- 解析数据
- (void)analyze:(NSData*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if ([dic[@"data"][@"goods_list"] isKindOfClass:[NSNull class]]) {
        [MBProgressHUD showError:@"无更多内容"];
        [self.tableView footerEndRefreshing];
    
    } else {
//        [self.dataSource removeAllObjects];
        NSArray* goods_listArray = dic[@"data"][@"goods_list"];
        
        for (NSDictionary* appDic in goods_listArray) {
            LHGoodsModel* model = [[LHGoodsModel alloc] init];
            [model setValuesForKeysWithDictionary:appDic];
            [self.dataSource  addObject:model];
        }
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
}

//- (void)updataWithCell:(UITableViewCell *)cell WithModel:(RootModel *)model
//{
//    if ([cell isMemberOfClass:[GodsCell class]]&& [model isMemberOfClass:[LHGoodsModel class]]) {
//        GodsCell* goodsCell = (GodsCell*)cell;
//        LHGoodsModel* goddsModel = (LHGoodsModel*)model;
//        goodsCell.titleLabel.text = goddsModel.goods_name;
//        goodsCell.priceLabel.text = goddsModel.goods_price;
//    }
//}

 /** 2.创建顶部按钮*/
- (void)creatButton {
    
    flag1 = NO;
    flag2 = NO;
    
    UIButton *button = [LHTool ButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40) image:nil title:@"全部分类" titleColor:[UIColor blackColor] target:self action:@selector(buttonPress:)];
    button.tag = 11;
    
    UIButton *btton1 = [LHTool ButtonWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40) image:nil title:@"默认" titleColor:[UIColor blackColor] target:self action:@selector(buttonPress:)];
    btton1.tag = 12;
    
    [self.view addSubview:button];
    [self.view addSubview:btton1];
}

- (void)buttonPress:(UIButton *)button
{
    if (button.tag == 11) {

        self.businessCustomTableView.hidden = YES;
        self.twoCustomTableView.hidden = YES;
        flag2 = NO;
        
        if (flag1 == YES) {
            
            self.oneCustomTableView.hidden = YES;
        } else {

            self.oneCustomTableView.hidden = NO;
        }
        
        flag1 = !flag1;
        
    } else if (button.tag == 12) {
        self.oneCustomTableView.hidden = YES;
        self.twoCustomTableView.hidden = YES;
        flag1 = NO;
        if (flag2 == YES) {
    
            self.businessCustomTableView.hidden = YES;
     
        } else {
  
            self.businessCustomTableView.hidden = NO;
        }
        
        flag2 = !flag2;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1) {
        return self.classificationArr.count;
    } else if (tableView.tag == 2) {
        return self.classificationArr2.count;
    } else if (tableView.tag == 3) {
        return self.businessArr.count;
    } else {
        return self.dataSource.count;
    }
//    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        
        static NSString *ident = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        zijianModel *model = _classificationArr[indexPath.row];
        cell.textLabel.text = model.gc_name;
        return cell;
        
    } else if (tableView.tag == 2) {
        static NSString *ident = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        
        zijian2Model *model = _classificationArr2[indexPath.row];
        cell.textLabel.text = model.gc_name;
        return cell;
    } else if (tableView.tag == 3) {
        static NSString *ident = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        cell.textLabel.text = self.businessArr[indexPath.row];
        return cell;
    } else {
        GoodsCell *cell = [GoodsCell cellWithTableView:tableView];
        LHGoodsModel *myModel = self.dataSource[indexPath.row];
        cell.goodsModel = myModel;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 4) {
        return 120;
    }
    
    return 30;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        self.twoCustomTableView.hidden = NO;
        
        zijianModel *model = self.classificationArr[indexPath.row];
        self.gc_id_1 = model.gc_id;
        
        if (!self.classificationArr2) {
            self.classificationArr2 = [[NSMutableArray alloc] init];
        }
        [self.classificationArr2 removeAllObjects];
        
        [self cacheWithUrl:[NSString stringWithFormat:SORT_URL, self.gc_id_1] target:self action:@selector(downloadData1:)];
        
    } else if (tableView.tag == 2) {
        self.oneCustomTableView.hidden = YES;
        self.twoCustomTableView.hidden = YES;
        flag1 = NO;
        
        zijian2Model *model = _classificationArr2[indexPath.row];
        self.gc_id_2 = model.gc_id;
        [self.dataSource removeAllObjects];
        [self request:1];
        
    } else if (tableView.tag == 3) {
        self.businessCustomTableView.hidden = YES;
        flag2 = NO;
        self.okwords = [NSString stringWithFormat:@"%d", indexPath.row];
        [self.dataSource removeAllObjects];
        [self request:1];
        
    } else {
        LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
        LHGoodsModel* model = (LHGoodsModel *)self.dataSource[indexPath.row];
        vc.goods_id = model.goods_id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)downloadData1:(NSData *)data{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if ([dic[@"data"][@"class_list"] isKindOfClass:[NSArray class]]) {
        NSArray *sortArray = dic[@"data"][@"class_list"];
    
        _classificationArr2 = [NSMutableArray array];
        for (NSDictionary *dic in sortArray) {
            zijian2Model *model = [[zijian2Model alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_classificationArr2 addObject:model];
        }
    
        [_twoCustomTableView reloadData];
    } else {
        [_classificationArr2 removeAllObjects];
        [_twoCustomTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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

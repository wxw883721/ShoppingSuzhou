//
//  SushopViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SushopViewController.h"
#import "StoreClassModel.h"
#import "StoreQuanModel.h"
#import "LLHTenantCell.h"
#import "LHTenantModel.h"
#import "StarView.h"
#import "SuShopDetailViewController.h"
#import "SearchViewController.h"

@interface SushopViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
    BOOL flag1;
    BOOL flag2;
    
    NSInteger _leftCount;
    NSInteger _rightCount;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *leftTableView1;
@property (nonatomic,strong) UITableView *leftTableView2;
@property (nonatomic,strong) UITableView *rightTableView1;
@property (nonatomic,strong) UITableView *rightTableView2;

@property (nonatomic,strong) NSMutableArray *leftSource2;
@property (nonatomic,strong) NSMutableArray *rightSource2;
@property (nonatomic,strong) NSMutableArray *tableSource;
@property (nonatomic,strong) NSMutableArray *leftSouce;
@property (nonatomic,strong) NSMutableArray *rightSouce;

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,strong) NSString *c_id;
@property (nonatomic,strong) NSString *q_id;

@property (nonatomic,strong) NSString *lng;
@property (nonatomic,strong) NSString *lat;

@property (nonatomic,strong) NSString *okwords;

@property (nonatomic,strong) UIImageView *leftBtnImg;
@property (nonatomic,strong) UIImageView *rightBtnImg;

@end

@implementation SushopViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    self.tabBarController.tabBar.hidden = YES;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _leftSouce = [[NSMutableArray alloc] init];
    _leftSource2 = [[NSMutableArray alloc] init];
    _tableSource = [[NSMutableArray alloc] init];
    _rightSouce = [[NSMutableArray alloc] init];
    _rightSource2 = [[NSMutableArray alloc] init];
    flag1 = NO;
    flag2 = NO;
    currentPage = 1;
    
    [self createNavgation];
    
    [self createHeaderView];
    
    [self createTableView];
    
    [self requestDataWithClassID:@"" andQuanID:@""];
    
    [self setupRefreshing];
}



//上拉，下拉刷新
-(void)setupRefreshing
{
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    
    currentPage = 1;
    [self requestDataWithClassID:_c_id andQuanID:_q_id];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
        
    });
    
}

//上拉加载更多
-(void)footerRefreshing
{
    isFooterReshing = YES;
    [self requestDataWithClassID:_c_id andQuanID:_q_id];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
    });
}

#pragma mark - 创建头部
- (void)createHeaderView
{
    UIView *backHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backHeadView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:0.9];
    [self.view addSubview:backHeadView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:Text_Normal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:Text_Normal];
    
    _leftButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 40);
    _rightButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40);
    
    _leftBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, 15, 15, 10)];
    _leftBtnImg.image = [UIImage imageNamed:@"down_jiantou"];
    [backHeadView addSubview:_leftBtnImg];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, 1, 30)];
    imageView.backgroundColor = [UIColor darkGrayColor];
    [backHeadView addSubview:imageView];
    
    _rightBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20,  15, 15, 10)];
    _rightBtnImg.image = [UIImage imageNamed:@"down_jiantou"];
    [backHeadView addSubview:_rightBtnImg];
    
    
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_leftButton setTitle:@"全部分类" forState:UIControlStateNormal];
    [_rightButton setTitle:@"全部商圈" forState:UIControlStateNormal];
    
    [_leftButton addTarget:self action:@selector(leftFristButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton addTarget:self action:@selector(rightFristButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [backHeadView addSubview:_leftButton];
    [backHeadView addSubview:_rightButton];
}

//两边表格隐藏
- (void)makeLeftHidden
{
    if (flag1)
    {
        flag1 = !flag1;
    }
    
    _leftTableView1.hidden = YES;
    [_leftTableView2 removeFromSuperview];
}
- (void)makeRightHidden
{
    if (flag2) {
        flag2 = !flag2;
    }
    _rightTableView1.hidden = YES;
    [_rightTableView2 removeFromSuperview];
}

#pragma mark - 按钮的触发方法及解析
//“全部分类”按钮触发的方法
- (void)leftFristButtonAction:(UIButton *)sender
{
    
    NSLog(@"flag1 = %d",flag1);
    
    
    if (!flag1) {
        [self createLeftTableView1];
        _leftTableView1.hidden = NO;
        
        [self makeRightHidden];
        
        [WXAFNetwork getRequestWithUrl:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=index" parameters:nil resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
         {
             
             if (isSuccessed)
             {
                 [_leftSouce removeAllObjects];
                 
                 
                 NSDictionary *dataDic = [responseObject objectForKey:kData];
                 NSArray *classArr = dataDic[@"store_class"];
                 
                 for (NSDictionary *classDesDic in classArr)
                 {
                     
                     StoreClassModel *model = [[StoreClassModel alloc] init];
                     [model setValuesForKeysWithDictionary:classDesDic];
                     
                     [_leftSouce addObject:model];
                 }
                 [_leftTableView1 reloadData];
             }
             
         }];
        flag1 = !flag1;
    }
    else
    {
        [self makeLeftHidden];
    }
    
}

//“商圈”按钮出发的方法
- (void)rightFristButtonAction: (UIButton *)sender
{
    NSLog(@"flag2 = %d",flag2);
    
    if (!flag2) {
        [self createRightTableView1];
        _rightTableView1.hidden = NO;
        [self makeLeftHidden];
        
        [WXAFNetwork getRequestWithUrl:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=index" parameters:nil resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
         {
             if (isSuccessed)
             {
                 [_rightSouce removeAllObjects];
                 NSDictionary *dataDic = [responseObject objectForKey:kData];
                 NSArray *quanArr = dataDic[@"store_quan"];
                 
                 for (NSDictionary *quanDesDic in quanArr)
                 {
                     
                     StoreQuanModel *model = [[StoreQuanModel alloc] init];
                     [model setValuesForKeysWithDictionary:quanDesDic];
                     
                     [_rightSouce addObject:model];
                 }
                 [_rightTableView1 reloadData];
             }
             else
             {
                 
             }
             flag2 = !flag2;
         }];
    }
    else
    {
        [self makeRightHidden];
    }
    
}

#pragma mark - 请求数据，刷新表格

- (void)requestDataWithClassID:(NSString *)c_id andQuanID:(NSString *)q_id
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
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    _lng = [info objectForKey:@"lon"];
    _lat = [info objectForKey:@"lat"];
    NSString *key = [info objectForKey:kKey];
    NSString *url = nil;
    
    if ((c_id == nil && q_id == nil)||(c_id.length == 0&&q_id.length == 0))
    {
        url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=index&lng=%@&lat=%@&curpage=%d&key=%@&page=10",_lng,_lat,currentPage,key];
    }
    else
    {
        url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=index&lng=%@&lat=%@&c_id=%@&q_id=%@&curpage=%d&key=%@&page=10",_lng,_lat,c_id,q_id,currentPage,key];
    }
    
    
    [WXAFNetwork getRequestWithUrl:url parameters:nil resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (isSuccessed)
         {
             NSNumber *code = [responseObject objectForKey:kCode];
             
             if ([code integerValue] == 200)
             {
                 NSDictionary *dataDic = [responseObject objectForKey:kData];
                 
                 NSLog(@"%@",dataDic);
                 
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
                         [self.tableSource addObject:model];
                     }
                 }
                 [_tableView reloadData];
             }
             else
             {
                 [MBProgressHUD showError:@"未知错误"];
             }
         }
         else
         {
             [MBProgressHUD showError:kError];
         }
         
     }];
}



#pragma mark- 创建表格
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tag = 34560;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (void)createLeftTableView1
{
    _leftTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/2, 240) style:UITableViewStylePlain];
    _leftTableView1.delegate = self;
    _leftTableView1.dataSource = self;
    _leftTableView1.tag = 34561;
    _leftTableView1.hidden = YES;
    [_leftTableView1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headerCell"];
    [self.view addSubview:_leftTableView1];
}

- (void)createRightTableView1
{
    _rightTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 40, SCREEN_WIDTH/2, 240) style:UITableViewStylePlain];
    _rightTableView1.delegate = self;
    _rightTableView1.dataSource = self;
    _rightTableView1.tag = 34563;
    _rightTableView1.hidden = YES;
    [_rightTableView1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headerCell"];
    [self.view addSubview:_rightTableView1];
}

- (void)createLeftTableView2
{
    _leftTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 40, SCREEN_WIDTH/2, 240) style:UITableViewStylePlain];
    _leftTableView2.delegate = self;
    _leftTableView2.dataSource = self;
    _leftTableView2.tag = 34562;
    [_leftTableView2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headerCell"];
    [self.view addSubview:_leftTableView2];
}

- (void)createRightTableView2
{
    _rightTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/2, 240) style:UITableViewStylePlain];
    _rightTableView2.delegate = self;
    _rightTableView2.dataSource = self;
    _rightTableView2.tag = 34564;
    [_rightTableView2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headerCell"];
    [self.view addSubview:_rightTableView2];
}

#pragma  mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 34560)
    {
        return self.tableSource.count;
    }
    else if (tableView.tag == 34561)
    {
        NSArray *leftArr1 = [SushopViewController FindLeftSource1:_leftSouce];
        return leftArr1.count+1;
    }
    else if (tableView.tag == 34562)
    {
        if (_leftCount)
        {
            return _leftCount+1;
        }
        else
            return 1;
    }
    else if (tableView.tag == 34563)
    {
        NSArray *rightArr1 = [SushopViewController FindRightSource1:_rightSouce];
        return rightArr1.count+1;
    }
    else
    {
        if (_rightCount)
        {
            return _rightCount+1;
        }
        else
            return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 34560)
        return 100;
    else
        return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (tableView.tag == 34560)
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
            if (_tableSource.count > 0)
            {
                
                LHTenantModel *model = _tableSource[indexPath.row];
                
                UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
                [headerView sd_setImageWithURL:[NSURL URLWithString:model.store_cover] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
                [cell.contentView addSubview:headerView];
                
                /** 标题*/
                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)+5, 10, KScr_W-80-10-5-75, 25)];
                titleLabel.font = [UIFont systemFontOfSize:Text_Big];
                titleLabel.text = model.store_name;
                [cell.contentView addSubview:titleLabel];
                
                /** 距离*/
                UILabel * jiliLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScr_W-80, 10, 75, CGRectGetHeight(titleLabel.frame))];
                jiliLabel.textAlignment = NSTextAlignmentRight;
                jiliLabel.font = [UIFont systemFontOfSize:Text_Small];
                
                if ([model.juli floatValue] > 1000)
                {
                    jiliLabel.text = [NSString stringWithFormat:@"%.2f千米",[model.juli floatValue]/1000];
                }
                else
                {
                    jiliLabel.text = [NSString stringWithFormat:@"%@米",model.juli];
                }
                
                [cell.contentView addSubview:jiliLabel];
                
                /** 详细地址*/
                UILabel * detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)+10, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH-CGRectGetMaxX(headerView.frame)-20, 40)];
                detailLabel.font = [UIFont systemFontOfSize:Text_Normal];
                detailLabel.numberOfLines = 0;
                detailLabel.text = model.store_address;
                [cell.contentView addSubview:detailLabel];
                
                /** 评分星级*/
                StarView * starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)+5, CGRectGetMaxY(detailLabel.frame), 100, 15)];
                [starView setStar:[model.seval_total intValue]];
                [cell.contentView addSubview:starView];
                
                /** 评价人数*/
                UILabel * pingjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(detailLabel.frame), 100, 15)];
                pingjiaLabel.textColor = [UIColor grayColor];
                pingjiaLabel.text = [NSString stringWithFormat:@"%@人评价", model.seval_num];
                pingjiaLabel.font = [UIFont systemFontOfSize:Text_Normal];
                [cell.contentView addSubview:pingjiaLabel];
                
                
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 0.5)];
                lineImageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
                [cell.contentView addSubview:lineImageView];
                
            }
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
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
            
            UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.frame];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            if (tableView.tag == 34561)
            {
                NSArray *leftArr = [SushopViewController FindLeftSource1:_leftSouce];
                if (leftArr.count > 0)
                {
                    if (indexPath.row == 0)
                    {
                        label.text = @"全部分类";
                    }
                    else
                    {
                        StoreClassModel *model = leftArr[indexPath.row-1];
                        label.text = model.sc_name;
                    }
                }
            }
            else if (tableView.tag == 34562)
            {
                if (_leftSource2.count > 0)
                {
                    if (indexPath.row == 0)
                    {
                        label.text = @"全部分类";
                    }
                    else
                    {
                        StoreClassModel *model = _leftSource2[indexPath.row-1];
                        label.text = model.sc_name;
                    }
                }
                else
                {
                    label.text = @"全部分类";
                }
            }
            else if (tableView.tag == 34563)
            {
                NSArray *rightArr = [SushopViewController FindRightSource1:_rightSouce];
                if (rightArr.count > 0)
                {
                    if (indexPath.row == 0)
                    {
                        label.text = @"全部分类";
                        
                    }
                    else
                    {
                        StoreQuanModel *model = rightArr[indexPath.row-1];
                        label.text = model.ring_name;
                    }
                }
            }
            else
            {
                if (_rightSource2.count > 0)
                {
                    if (indexPath.row == 0)
                    {
                        label.text = @"全部分类";
                    }
                    else
                    {
                        StoreQuanModel *model = _rightSource2[indexPath.row-1];
                        label.text = model.ring_name;
                    }
                }
                else
                {
                    label.text = @"全部分类";
                }
            }
            
            [cell.contentView addSubview:label];
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15, 29, SCREEN_WIDTH/2, 1)];
            line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
            [cell.contentView addSubview:line];
            
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 34561)
    {
        for (UIView *view in self.view.subviews)
        {
            
            if (view.tag == 34562 || view.tag == 34563 || view.tag == 34564)
            {
                [view removeFromSuperview];
            }
            
            
        }
        
        if (indexPath.row == 0)
        {
            _c_id = @"";
            currentPage = 1;
            flag1 = 0;
            [self removeAllTableView];
            [self requestDataWithClassID:_c_id andQuanID:_q_id];
            [_tableSource removeAllObjects];
            [_leftButton setTitle:@"全部分类" forState:UIControlStateNormal];
            
        }
        else
        {
            NSArray *leftArr = [SushopViewController FindLeftSource1:_leftSouce];
            
            StoreClassModel *model = leftArr[indexPath.row-1];
            
            _leftSource2 = [NSMutableArray arrayWithArray:[SushopViewController FindLeftSource2:_leftSouce andScID:model.sc_id]];
            _leftCount = _leftSource2.count;
            [_leftButton setTitle:model.sc_name forState:UIControlStateNormal];
            _c_id = [NSString stringWithString:model.sc_id];
            
            [self createLeftTableView2];
        }
        
        
        
    }
    else if (tableView.tag == 34562)
    {
        
        if (indexPath.row == 0)
        {
        }
        else
        {
            StoreClassModel *model = _leftSource2[indexPath.row -1];
            _c_id = [NSString stringWithString:model.sc_id];
            [_leftButton setTitle:model.sc_name forState:UIControlStateNormal];
        }
        currentPage = 1;
        flag1 = 0;
        [self removeAllTableView];
        [self requestDataWithClassID:_c_id andQuanID:_q_id];
        [_tableSource removeAllObjects];
    }
    else if (tableView.tag == 34563)
    {
        for (UIView *view in self.view.subviews)
        {
            
            if (view.tag == 34561 || view.tag == 34562 || view.tag == 34564)
            {
                [view removeFromSuperview];
            }
            
            
        }
        
        NSArray *rightArr = [SushopViewController FindRightSource1:_rightSouce];
        
        if (indexPath.row == 0)
        {
            _q_id = @"";
            currentPage = 1;
            flag2 = 0;
            [_rightButton setTitle:@"全部分类" forState:UIControlStateNormal];
            [self removeAllTableView];
            [self requestDataWithClassID:_c_id andQuanID:_q_id];
            [_tableSource removeAllObjects];
        }
        else
        {
            StoreQuanModel *model = rightArr[indexPath.row-1];
            
            _rightSource2 = [NSMutableArray arrayWithArray:[SushopViewController FindRightSource2:_rightSouce andRingID:model.ring_id]];
            _rightCount = _rightSource2.count;
            [_rightButton setTitle:model.ring_name forState:UIControlStateNormal];
            _q_id = [NSString stringWithString:model.ring_id];
            
            [self createRightTableView2];
            
        }
    }
    else if (tableView.tag == 34564)
    {
        if (indexPath.row == 0)
        {
            
        }
        else
        {
            StoreQuanModel *model = _rightSource2[indexPath.row -1];
            _q_id = [NSString stringWithString:model.ring_id];
            
            [_rightButton setTitle:model.ring_name forState:UIControlStateNormal];
        }
        currentPage = 1;
        flag2 = 0;
        [self removeAllTableView];
        [self requestDataWithClassID:_c_id andQuanID:_q_id];
        [_tableSource removeAllObjects];
    }
    else
    {
        SuShopDetailViewController *vc = [[SuShopDetailViewController alloc] init];
        LHTenantModel *model = _tableSource[indexPath.row];
        vc.store_id = model.store_id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:NO];
    }
    
}

- (void)removeAllTableView
{
    [self makeLeftHidden];
    [self makeRightHidden];
    
    [_leftTableView1 removeFromSuperview];
    [_leftTableView2 removeFromSuperview];
    [_rightTableView1 removeFromSuperview];
    [_rightTableView2 removeFromSuperview];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 0.1)];
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0,SCREEN_WIDTH/2-15, 0.1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [footerView addSubview:lineView];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 筛选出一二级列表需要的数据
//从leftSource中找到leftSource1
+ (NSArray *)FindLeftSource1:(NSArray *)leftSource
{
    NSMutableArray *leftSource1 = [[NSMutableArray alloc] init];
    
    for (StoreClassModel *model in leftSource)
    {
        if ([model.sc_parent_id integerValue] == 0)
        {
            [leftSource1 addObject:model];
        }
    }
    return leftSource1;
}
//从leftSource中找到leftSource2
+ (NSArray *)FindLeftSource2:(NSArray *)leftSource andScID:(NSString *)sc_id
{
    NSMutableArray *leftSource2 = [[NSMutableArray alloc] init];
    
    for (StoreClassModel *model in leftSource)
    {
        if ([model.sc_parent_id integerValue] != 0 && [model.sc_parent_id isEqualToString:sc_id])
        {
            [leftSource2 addObject:model];
        }
    }
    return leftSource2;
}

//从rightSource中找到rightSource1
+ (NSArray *)FindRightSource1:(NSArray *)rightSource
{
    NSMutableArray *rightSource1 = [[NSMutableArray alloc] init];
    
    for (StoreQuanModel *model in rightSource)
    {
        if ([model.ring_parent_id integerValue] == 0)
        {
            [rightSource1 addObject:model];
        }
    }
    return rightSource1;
}
//从rightSource中找到rightSource2
+ (NSArray *)FindRightSource2:(NSArray *)rightSource andRingID:(NSString *)ring_id
{
    NSMutableArray *rightSource2 = [[NSMutableArray alloc] init];
    
    for (StoreQuanModel *model in rightSource)
    {
        if ([model.ring_parent_id integerValue] != 0 && [model.ring_parent_id isEqualToString:ring_id])
        {
            [rightSource2 addObject:model];
        }
    }
    return rightSource2;
}

- (void)createNavgation
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.text = @"商户";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = label;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 30, 30);
    
    [button1 setImage:[UIImage imageNamed:@"60-60@2x.png"] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"60-60@2x.png"] forState:UIControlStateHighlighted];
    
    [button1 addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    self.navigationItem.rightBarButtonItem = item;
}


- (void)searchAction
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)BackAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

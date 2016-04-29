//
//  SuGoodsViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SuGoodsViewController.h"
#import "GodsViewController.h"
#import "GodsCell.h"
#import "LHGoodsModel.h"
#import "LHGodsDetailViewController.h"
#import "GoodsCell.h"
#import "zijian2Model.h"
#import "zijianModel.h"
#import "StarView.h"
#import "MJRefresh.h"
#import "SearchViewController.h"

@interface SuGoodsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
    BOOL flag1;
    BOOL flag2;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) UITableView *sortTableView;

@property (nonatomic,strong) NSMutableArray *tableSource;
@property (nonatomic,strong) NSMutableArray *leftSouce;
@property (nonatomic,strong) NSMutableArray *rightSouce;

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,strong) NSString *gc_id_1;
@property (nonatomic,strong) NSString *gc_id_2;

@property (nonatomic,strong) NSString *okwords;

@property (nonatomic,strong) UIImageView *leftBtnImg;
@property (nonatomic,strong) UIImageView *rightBtnImg;

@end

@implementation SuGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _leftSouce = [[NSMutableArray alloc] init];
    _tableSource = [[NSMutableArray alloc] init];
    _rightSouce = [[NSMutableArray alloc] init];
    
    [self createNavgation];
    
    [self setViewTitle:@"商品"];
    
    [self createHeaderView];
    
    [self createTableView];
    
    currentPage = 1;
    _okwords = @"4";
    [self requsetDataWithGc1:@"" Gc2:@"" andOkwords:_okwords];
    
    [self setupRefreshing];
    
}

- (void)createNavgation
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    
    [button setImage:[UIImage imageNamed:@"60-60@2x.png"] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"60-60@2x.png"] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)searchAction
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//上拉，下拉刷新
-(void)setupRefreshing
{
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    //    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    
    currentPage = 1;
    [self requsetDataWithGc1:_gc_id_1 Gc2:_gc_id_2 andOkwords:_okwords];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
        
    });
    
}

//上拉加载更多
-(void)footerRefreshing
{
    isFooterReshing = YES;
    [self requsetDataWithGc1:_gc_id_1 Gc2:_gc_id_2 andOkwords:_okwords];
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
    flag1 = NO;
    flag2 = NO;
    
    _leftButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 40);
    _rightButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40);
    
    _leftBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, 15, 15, 10)];
    _leftBtnImg.image = [UIImage imageNamed:@"down_jiantou"];
    [backHeadView addSubview:_leftBtnImg];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, 1, 30)];
    imageView.backgroundColor = [UIColor darkGrayColor];
    [backHeadView addSubview:imageView];
    
    _rightBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, 15, 15, 10)];
    _rightBtnImg.image = [UIImage imageNamed:@"down_jiantou"];
    [backHeadView addSubview:_rightBtnImg];
    
    
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_leftButton setTitle:@"全部分类" forState:UIControlStateNormal];
    [_rightButton setTitle:@"默认" forState:UIControlStateNormal];
    
    [_leftButton addTarget:self action:@selector(leftFristButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [backHeadView addSubview:_leftButton];
    [backHeadView addSubview:_rightButton];
}

//“全部分类”按钮触发的方法
- (void)leftFristButtonAction:(UIButton *)sender
{
    NSLog(@"flag1 = %d",flag1);
    
    if (!flag1)
    {
        if (flag2) {
            flag2 = !flag2;
        }
        
        _leftTableView.hidden = NO;
        [self RequestWithURL:@"http://www.bgsz.tv/mobile/index.php?act=goods_class" target:self action:@selector(leftAnalyse:)];
    }
    else
    {
        
        _leftTableView.hidden = YES;
        _rightTableView.hidden = YES;
    }
    flag1 = !flag1;
}
- (void)leftAnalyse:(NSData *)data
{
    [_leftSouce removeAllObjects];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *dataArr = dic[@"data"];
    NSArray *listArr = dataArr[@"class_list"];
    
    for (NSDictionary *appDic in listArr) {
        zijianModel *model = [[zijianModel alloc] init];
        [model setValuesForKeysWithDictionary:appDic];
        [_leftSouce addObject:model];
    }
    [_leftTableView reloadData];
}

//“默认”按钮出发的方法
- (void)rightButtonAction: (UIButton *)sender
{
    
    NSLog(@"flag2 = %d",flag2);
    
    if(!flag2)
    {
        if (flag1) {
            flag1 = !flag1;
        }
        _sortTableView.hidden = NO;
        _leftTableView.hidden = YES;
        _rightTableView.hidden = YES;
    }
    else
    {
        
        _sortTableView.hidden = YES;
        
    }
    flag2 = !flag2;
}

#pragma  mark - 网络请求

-  (void)requsetDataWithGc1:(NSString *)gc_id_1 Gc2:(NSString *)gc_id_2 andOkwords:(NSString *)okwords
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
    NSString *url = [NSString stringWithFormat:@"%@&curpage=%d&gc_id_1=%@&gc_id_2=%@&okwords=%@&page=10",SU_GOODS_URL,currentPage,gc_id_1,gc_id_2,okwords];
    
    NSLog(@"%@",url);
    
    [self cacheWithUrl:url target:self action:@selector(analyze:)];
}

- (void)analyze:(NSData *)data
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dataDic = dic[@"data"];
    NSArray *listArr = dataDic[@"goods_list"];
    
    if (listArr.count < 1) {
        [MBProgressHUD showError:@"无更多内容" toView:self.view];
    }
    else
    {
        for (NSDictionary *appDic in listArr) {
            
            LHGoodsModel *model = [[LHGoodsModel alloc] init];
            
            [model setValuesForKeysWithDictionary:appDic];
            [_tableSource addObject:model];
        }
    }
    [_tableView reloadData];
}


#pragma mark- 创建表格
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tag = 23456;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/2, 240) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.tag = 23457;
    _leftTableView.hidden = YES;
    [_leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headerCell"];
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 40, SCREEN_WIDTH/2, 240) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.tag = 23458;
    _rightTableView.hidden = YES;
    [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headCell"];
    [self.view addSubview:_rightTableView];
    
    _sortTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 40, SCREEN_WIDTH/2, 240) style:UITableViewStylePlain];
    _sortTableView.delegate = self;
    _sortTableView.dataSource = self;
    _sortTableView.tag = 23459;
    _sortTableView.hidden = YES;
    [_sortTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"headerCell"];
    [self.view addSubview:_sortTableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 23456)
    {
        return _tableSource.count;
    }
    else if(tableView.tag == 23457)
    {
        return _leftSouce.count+1;
    }
    else if(tableView.tag == 23458)
    {
        return _rightSouce.count;
    }
    else
    {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 23456)
    {
        return 100;
    }
    else
    {
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 23456)
    {
        
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:[NSString stringWithFormat:@"%@",indexPath]];
            
            //添加代码
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_tableSource.count > 0)
        {
            LHGoodsModel *model = self.tableSource[indexPath.row];
            
            UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 80, 80)];
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@",model.goods_image_url];
            
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
        return cell;
    }
    
    else if (tableView.tag == 23457)
    {
        if (_sortTableView.hidden == NO)
        {
            _sortTableView.hidden = YES;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            if (_leftSouce.count > 0)
            {
                if(indexPath.row == 0)
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
                    
                    label.text = @"全部分类";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:Text_Big];
                    [cell.contentView addSubview:label];
                }
                
                else
                {
                    zijianModel *model = _leftSouce[indexPath.row-1];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
                    
                    label.text = model.gc_name;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:Text_Big];
                    [cell.contentView addSubview:label];
                }
                
            }
            
        }
        
        return cell;
        
    }
    
    else if(tableView.tag == 23458)
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            if (_rightSouce.count > 0)
            {
                if(indexPath.row == 0)
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
                    
                    label.text = @"全部分类";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:Text_Big];
                    [cell.contentView addSubview:label];
                }
                else
                {
                    zijian2Model *model = _rightSouce[indexPath.row];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
                    label.text = model.gc_name;
                    label.textAlignment = NSTextAlignmentCenter;
                    [cell.contentView addSubview:label];
                    label.font = [UIFont systemFontOfSize:Text_Big];
                }
                
                
            }
            
        }
        return cell;
    }
    else
    {
        if (_leftTableView.hidden == NO) {
            _leftTableView.hidden = YES;
            _rightTableView.hidden = YES;
        }
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            NSArray *arr = @[@"默认",@"销量",@"浏览量",@"价格"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
            
            label.text = arr[indexPath.row];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:Text_Big];
            [cell.contentView addSubview:label];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag == 23457)
    {
        _rightTableView.hidden = NO;
        
        if(indexPath.row > 0)
        {
            zijianModel *model = _leftSouce[indexPath.row-1];
            
            [_leftButton setTitle:model.gc_name forState:UIControlStateNormal];
            
            NSString *url = [NSString stringWithFormat:SORT_URL,model.gc_id];
            
            _gc_id_1 = [NSString stringWithString:model.gc_id];
            
            [self cacheWithUrl:url target:self action:@selector(sortDescribeAction:)];
        }
        else
        {
            
            [_tableSource removeAllObjects];
            
            [self requsetDataWithGc1:@"" Gc2:@"" andOkwords:_okwords];
            _gc_id_1 = @"";
            _gc_id_2 = @"";
            [_leftButton setTitle:@"全部分类" forState:UIControlStateNormal];
            _leftTableView.hidden = YES;
            _rightTableView.hidden = YES;
            flag1 = 0;
        }
        
        
    }
    else if(tableView.tag == 23458)
    {
        if (indexPath.row == 0)
        {
            [_tableSource removeAllObjects];
            
            [self requsetDataWithGc1:_gc_id_1 Gc2:@"" andOkwords:_okwords];
            _leftTableView.hidden = YES;
            _rightTableView.hidden = YES;
            flag1 = 0;

        }
        
        else
        {
            zijian2Model *model = _rightSouce[indexPath.row-1];
            
            [_tableSource removeAllObjects];
            
            [self requsetDataWithGc1:_gc_id_1 Gc2:model.gc_id andOkwords:_okwords];
            _gc_id_2 = [NSString stringWithString:model.gc_id];
            
            [_leftButton setTitle:model.gc_name forState:UIControlStateNormal];
            _leftTableView.hidden = YES;
            _rightTableView.hidden = YES;
            flag1 = 0;

        }
        
        
    }
    else if(tableView.tag == 23459)
    {
        _okwords = [NSString stringWithFormat:@"%d",indexPath.row];
        [_tableSource removeAllObjects];
        [self requsetDataWithGc1:_gc_id_1 Gc2:_gc_id_2 andOkwords:_okwords];
        tableView.hidden = YES;
        NSArray *arr = @[@"默认",@"销量",@"浏览量",@"价格"];
        
        [_rightButton setTitle:arr[indexPath.row] forState:UIControlStateNormal];
    }
    else
    {
        LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
        
        LHGoodsModel *model = self.tableSource[indexPath.row];
        vc.backRootVC = @"0";
        vc.goods_id = model.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)sortDescribeAction:(NSData *)data
{
    [_rightSouce removeAllObjects];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *arr = dic[@"data"][@"class_list"];
    
    for (NSDictionary *appDic in arr) {
        zijian2Model *model = [[zijian2Model alloc] init];
        
        [model setValuesForKeysWithDictionary:appDic];
        
        [_rightSouce addObject:model];
    }
    [_rightTableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    return footView;
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

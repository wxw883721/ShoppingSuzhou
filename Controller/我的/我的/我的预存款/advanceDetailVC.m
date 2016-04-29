//
//  advanceDetailVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/7.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "advanceDetailVC.h"
#import "advanceDetailCell.h"
#import "MJRefresh.h"
#import "advanceDetailModel.h"
#import "predepositDetailVC.h"

@interface advanceDetailVC ()
{
    
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
}

@property (nonatomic,retain) NSMutableArray *advanceArr;

@end

@implementation advanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createTableView];
    isFooterReshing = NO;
    isHeadReshing = NO;
    currentPage = 1;
    [self requestData];
    [self setupRefreshing];
    
    self.advanceArr = [[NSMutableArray alloc]init];
    
}


//上拉，下拉刷新
-(void)setupRefreshing
{
    //下拉刷新
    [self.customTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    //上拉加载
    [self.customTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    currentPage = 1;
    [self requestData];
    [self.advanceArr removeAllObjects];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.customTableView headerEndRefreshing];
        
    });
    
}

//上拉加载更多
-(void)footerRefreshing
{
    
    isFooterReshing = YES;
    
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.customTableView footerEndRefreshing];
    });
}


-(void)requestData
{
    if (isHeadReshing) {
        
        isHeadReshing = NO;
    }
    else if(isFooterReshing)
    {
        currentPage ++;
        isFooterReshing = NO;
    }
    else
    {
        //[MBProgressHUD showError:kError];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *curpage = [NSString stringWithFormat:@"%i",currentPage];
    NSString *page = [NSString stringWithFormat:@"%i",10];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",curpage,@"curpage",page,@"page", nil];
    [WXAFNetwork getRequestWithUrl:kAdvanceDetail parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
             
             if ([code integerValue] == 200) {
                 
                 if ([[resultObject objectForKey:kData] isKindOfClass:[NSDictionary class]]) {
                     
                     [MBProgressHUD showError:[[resultObject objectForKey:kData]objectForKey:kMessage]];
                 }
                 else
                 {
                     NSArray *data = [resultObject objectForKey:kData];
                     for (NSDictionary *dict in data) {
                         
                         advanceDetailModel *model = [[advanceDetailModel alloc]init];
                         [model setValuesForKeysWithDictionary:dict];
                         [self.advanceArr addObject:model];
                         
                     }
                     
                 }
                 [self.customTableView reloadData];
                 
             }
         }
         else
         {
             [MBProgressHUD showError:kError];
             
         }
         
     }];
    
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预存款明细";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}



-(void)createTableView
{
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H - 64) style:UITableViewStylePlain];
    self.customTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    [self.customTableView registerNib:[UINib nibWithNibName:@"advanceDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"advanceDetailCell"];
    [self.view addSubview:self.customTableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.advanceArr.count;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    advanceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"advanceDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 69, KScr_W, 1)];
    image.backgroundColor = kLine;
    [cell addSubview:image];
    
    if (self.advanceArr.count == 0) {
        
    }
    else
    {
        advanceDetailModel *model = self.advanceArr[indexPath.row];
        cell.advanceTime.text = model.lg_add_time;
        cell.advanceAmount.text = model.lg_av_amount;
        cell.advanceMake.text = model.lg_mark;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    advanceDetailModel *model = self.advanceArr[indexPath.row];
    predepositDetailVC *vc = [[predepositDetailVC alloc]init];
    vc.lg_id = model.lg_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)touchBtn:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

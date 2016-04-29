//
//  IntegralMallVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/25.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "IntegralMallVC.h"
#import "Size.h"
#import "integralMallCell.h"
#import "MJRefresh.h"
#import "integralMallModel.h"
#import "integralMallDetailVC.h"

@interface IntegralMallVC ()
{
    int curragePage;
    BOOL isHeadReshing;
    BOOL isFooterReshing;

}

@property (nonatomic,strong) integralMallCell *cell;

@end

@implementation IntegralMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    curragePage = 1;
    isFooterReshing = NO;
    isHeadReshing = NO;
    
    [self createTableView];
    [self requestData];
    [self setupRefreshing];
    
    self.integralArr = [[NSMutableArray alloc]init];
    
}

-(void) setupRefreshing
{
    [self.customTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.customTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    curragePage = 1;
    
    [self.integralArr removeAllObjects];
    [self requestData];
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

    
-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"积分商城";
//    导航条字体颜色,大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;

}
-(void)requestData
{
    if (isHeadReshing) {
        curragePage = 1;
        isHeadReshing = NO;
    }
    else if(isFooterReshing)
    {
        curragePage ++;
        isFooterReshing = NO;
    
    }
    else
    {
    
    }
    
    if (!self.integralArr) {
        self.integralArr = [[NSMutableArray alloc]init];
    }
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *page = [NSString stringWithFormat:@"%d",5];
    NSString *curpage = [NSString stringWithFormat:@"%d",curragePage];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",page,@"page",curpage,@"curpage", nil];
    [WXAFNetwork getRequestWithUrl:kIntegralMallUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)

     {
         if (isSuccessed) {
             
             NSNumber *code = [resultObject objectForKey:kCode];
//             NSString *hasmore = [resultObject objectForKey:@"hasmore"];
//             NSString *page_total = [resultObject objectForKey:@"page_total"];
             NSDictionary *data = [resultObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
        
                NSArray *dataArr = [data objectForKey:@"data"];
                for (NSDictionary *dict in dataArr) {
                         integralMallModel *model = [[integralMallModel alloc]init];
                         [model setValuesForKeysWithDictionary:dict];
                         [self.integralArr addObject:model];
                         //self.pgoods_id = model.pgoods_id;
                }
             }
             else
             {
                 [MBProgressHUD showError:[[resultObject objectForKey:kData] objectForKey:kMessage]];
             }
            [self.customTableView reloadData];
         }
         else
         {
         
             [MBProgressHUD showError:kError];
         }
     
     
     }];

}
-(void)createTableView
{
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H-64) style:UITableViewStylePlain];
    self.customTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    [self.customTableView registerNib:[UINib nibWithNibName:@"integralMallCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"integralMallCell"];
    
    [self.view addSubview:self.customTableView];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.integralArr.count;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100*kScr_Rate;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"integralMallCell" forIndexPath:indexPath];
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.integralArr.count == 0) {
        
    }
    else
    {
    integralMallModel *model = self.integralArr[indexPath.row];
    
    [_cell.integralMallImage sd_setImageWithURL:[NSURL URLWithString:model.pgoods_image] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
    _cell.integralMallName.text = model.pgoods_name;
    _cell.integralMallPrice.text = [NSString stringWithFormat:@"市场价:%@元",model.pgoods_price];
    _cell.integralMallNumber.text = [NSString stringWithFormat:@"积分:%@积分",model.pgoods_points];
    
    _cell.integralMallSnapBtn.layer.cornerRadius = 5.0;
    _cell.integralMallSnapBtn.titleLabel.text = @"立即抢购";
    _cell.integralMallSnapBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Big];
    _cell.integralMallSnapBtn.tag = indexPath.row;
    if ([model.pgoods_storage intValue] == 0)
    {
        _cell.integralMallSnapBtn.userInteractionEnabled = NO;
        [_cell.integralMallSnapBtn setTitleColor:[UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:0.3] forState:UIControlStateNormal];
        _cell.integralMallSnapBtn.layer.borderWidth = 1.0;
        _cell.integralMallSnapBtn.layer.borderColor = [UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:0.3].CGColor;
    }
    else
    {
        
    [_cell.integralMallSnapBtn setTitleColor:kloginColor forState:UIControlStateNormal];
    _cell.integralMallSnapBtn.layer.borderWidth = 1.0;
    _cell.integralMallSnapBtn.layer.borderColor = kloginColor.CGColor;
        
    }
    _cell.integralMallSnapBtn.backgroundColor = [UIColor whiteColor];
    [_cell.integralMallSnapBtn addTarget:self action:@selector(integralMallSnapBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}

-(void)integralMallSnapBtn:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = NO;
    integralMallDetailVC *vc = [[integralMallDetailVC alloc]init];
    integralMallModel *model = self.integralArr[btn.tag];
    if ([model.pgoods_storage intValue] == 0) {
        
        [MBProgressHUD showError:@"无剩余"];
    }
    else
    {
    vc.pgoods_id = model.pgoods_id;
    [self.navigationController pushViewController:vc animated:YES];
    }
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

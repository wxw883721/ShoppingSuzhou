//
//  ActStreetViewController.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/7/2.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ActStreetViewController.h"
#import "ActStreetModel.h"
#import "ActStreetCell.h"
#import "SuShopDetailViewController.h"

@interface ActStreetViewController () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isHeadReshing;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActStreetModel *model;
@property (nonatomic, strong) NSMutableArray *timeArray;
@end

@implementation ActStreetViewController

//- (NSMutableArray *)streetArray {
//    if (_streetArray == nil) {
//        _streetArray = [[NSMutableArray alloc] init];
//    }
//    return _streetArray;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setViewTitle:@"活动商户"];
    
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

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 24)];
    label1.font = [UIFont systemFontOfSize:Text_Normal];
    label1.textColor = [UIColor blueColor];
    [self.view addSubview:label1];
    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH, 24)];
//    label2.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:label2];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_HEIGHT, 1)];
    imageView.backgroundColor = [UIColor hexChangeFloat:@"e2e2e2"];
    [self.view addSubview:imageView];
    
    label1.text = (_model.activity_start_date == nil || _model.activity_start_date.length == 0) ? @"未知日期" : [NSString stringWithFormat:@"%@ 至 %@", _model.activity_start_date,_model.activity_end_date];
//    label2.text = (_model.activity_end_date == nil || _model.activity_end_date.length == 0) ? @"未知日期" : [NSString stringWithFormat:@"%@", ];
    
//    label1.text = [NSString stringWithFormat:@"开始日期 %@", _model.activity_start_date];
//    label2.text = [NSString stringWithFormat:@"截止日期 %@", _model.activity_end_date];

}

- (void)creatTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, SCREEN_HEIGHT-25)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    
    _tableView.tableFooterView = footerView;
    
    [self.view addSubview:_tableView];
}

- (void)request
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self cacheWithUrl:[NSString stringWithFormat:STREET_URL, self.myId] target:self action:@selector(analyze:)];
}

- (void)analyze:(NSData *)data {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",dic);
    
    NSLog(@"%@",dic[@"data"][kMessage]);
    
    NSDictionary *dict = dic[@"data"][@"activity"];
    _timeArray = [NSMutableArray array];
    _model = [[ActStreetModel alloc] init];
    [_model setValuesForKeysWithDictionary:dict];
    
    NSNumber *code = dic[kCode];
    
    if ([code integerValue] == 200)
    {
        if ([dic[@"data"][@"list"] isKindOfClass:[NSNull class]])
        {
            self.tableView.hidden = YES;
            [MBProgressHUD showError:dic[kData][kMessage] toView:self.view];
            [self addEmpty];
            
        }
        else
        {
            NSArray *array = dic[@"data"][@"list"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *listDict in array) {
                ActStreetModel *model = [[ActStreetModel alloc] init];
                [model setValuesForKeysWithDictionary:listDict];
                [arr addObject:model];
            }
            [self.dataSource addObject:arr];
            [self creatHeadLabel];
        }
    }
    
    else
    {
        self.tableView.hidden = YES;
        [MBProgressHUD showError:dic[kData][kMessage] toView:self.view];
        [self addEmpty];
    }
    
    [self.tableView reloadData];
}

- (void)addEmpty
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-40, SCREEN_WIDTH, 20)];
    label.text = @"暂无活动商户";
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ActStreetCell *cell = [ActStreetCell cellWithTableView:tableView];
    
    ActStreetModel *model = [self.dataSource lastObject][indexPath.row];
    cell.actStreetModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSource lastObject] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //微博的创建时间
    NSDate *creatDate = [fmt dateFromString:_model.activity_start_date];
    //当前时间
    NSDate *nowDate = [NSDate date];
    
    NSDate *date = [creatDate laterDate:nowDate];
    
    if ([date isEqualToDate:nowDate])
    {
        SuShopDetailViewController *vc = [[SuShopDetailViewController alloc] init];
        ActStreetModel *model = [self.dataSource lastObject][indexPath.row];
        vc.store_id = model.store_id;
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
}

@end

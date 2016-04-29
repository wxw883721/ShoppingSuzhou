//
//  DetailEvaluationViewController.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "DetailEvaluationViewController.h"
#import "EvaluationModel.h"
#import "MBProgressHUD+MJ.h"
#import "StarView.h"
#import "EvaluationTableViewCell.h"


@interface DetailEvaluationViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DetailEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setViewTitle:@"评价详情"];
    
    [self creatScore];
    [self creatTableView];
    
    [self request];
}

- (void)creatScore {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 1;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
    label.text = @"总体评价:";
    [view addSubview:label];
    
    StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 5, 100, 30)];
    [starView setStar:[self.shop_count floatValue]];
    
    NSLog(@"%@",self.shop_count);
    
    [view addSubview:starView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starView.frame)+5, 5, 80, 30)];
    label1.text = [NSString stringWithFormat:@"%@分", self.shop_count];
    label1.textColor = [UIColor orangeColor];
//    label1.backgroundColor = [UIColor redColor];
    [view addSubview:label1];
    
}
- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)request {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self cacheWithUrl:[NSString stringWithFormat:EVALUATION_URL, self.shop_id] target:self action:@selector(analyze:)];
    
    //    NSLog(@"(+()_+()_+   %@", [NSString stringWithFormat:EVALUATION_URL, self.shop_id]);
}

- (void)analyze:(NSData *)data {
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.shop_count intValue] == 0) {
        NSDictionary *evaluationDic = dic[@"data"];
        if (evaluationDic) {
            NSString *message = evaluationDic[@"message"];
            if ([message  isEqual: @"暂无评论"]) {
                [MBProgressHUD showError:@"暂无评论"];
                
                [self performSelector:@selector(back) withObject:self afterDelay:2.0f];
            }
        }
    }
    NSArray *evaluationArr = dic[@"data"];
    for (NSDictionary *dict in evaluationArr) {
        EvaluationModel *model = [[EvaluationModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataSource addObject:model];
    }
    
    [_tableView reloadData];
    NSLog(@"()_+(_()++_)   %@", dic);
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EvaluationTableViewCell *cell = (EvaluationTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[EvaluationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@",indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

//    EvaluationTableViewCell *cell = [EvaluationTableViewCell cellWithTableView:tableView];
    
    EvaluationModel *model = self.dataSource[indexPath.row];
    
    
    cell.mymodel = model;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EvaluationTableViewCell *cell = [[EvaluationTableViewCell alloc] init];
    EvaluationModel *model = self.dataSource[indexPath.row];
    return [cell getCellHeightWith:model];
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

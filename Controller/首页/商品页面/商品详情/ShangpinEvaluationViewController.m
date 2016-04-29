//
//  ShangpinEvaluationViewController.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/29.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ShangpinEvaluationViewController.h"
#import "ShangpinEvaluationModel.h"
#import "EvaluationTableViewCell.h"
#import "StarView.h"
#import "MBProgressHUD.h"
#import "EvaluationTableViewCell.h"

@interface ShangpinEvaluationViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ShangpinEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setViewTitle:@"评价详情"];
    
    [self creatScore];
    [self creatTableView];
    
    [self request];
}

- (void)creatScore
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 1;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
    label.text = @"总体评价:";
    [view addSubview:label];
    
    StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 10, 100, 30)];
    [starView setStar:[self.star_score floatValue]];
    [view addSubview:starView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starView.frame)+5, 5, 80, 30)];
    label1.text = [NSString stringWithFormat:@"%@分", self.star_score];
    label1.textColor = [UIColor orangeColor];
    [view addSubview:label1];
    
}

- (void)creatTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)request
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self cacheWithUrl:[NSString stringWithFormat:GOODSEVALUATION_URL, self.good_id] target:self action:@selector(analyze:)];
}

- (void)analyze:(NSData *)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //    NSLog(@"dic = %@",dic);
    
    if ([self.count intValue] == 0)
    {
        NSDictionary *evaluationDic = dic[@"data"];
        NSString *message = evaluationDic[@"message"];
        [MBProgressHUD showError:message];
        [self performSelector:@selector(back) withObject:self afterDelay:2.0f];

    }
    NSArray *evaluationArr = dic[@"data"];
    for (NSDictionary *dict in evaluationArr)
    {
        ShangpinEvaluationModel *model = [[ShangpinEvaluationModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataSource addObject:model];
    }
    
    NSLog(@"******* %@", dic);
    [_tableView reloadData];
    
}

- (void)back
{
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
    
    ShangpinEvaluationModel *model = self.dataSource[indexPath.row];
    
    cell.shangpinModel = model;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShangpinEvaluationModel *model = self.dataSource[indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:Text_Big];
    CGRect frame = [model.geval_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGFloat storecontentH = [model.geval_storecontent boundingRectWithSize:CGSizeMake(KScr_W-40, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil].size.height;
    if (storecontentH > 0)
    {
        storecontentH += 10;
    }
    return frame.size.height + 70 + storecontentH;
    
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

//
//  LHOrderViewController.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHOrderViewController.h"
#import "LHOrder1Cell.h"
#import "LHOrder2Cell.h"
#import "LHOrder2Controller.h"

@interface LHOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LHOrderViewController
{
    UITableView* _tableView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"LHOrder1Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"lhOrder1Cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LHOrder2Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"lhOrder2Cell"];
    // Do any additional setup after loading the view.
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        UILabel* label = [LHTool LabelWithFrame:CGRectMake(0, 5, 80, 35) Font:[UIFont systemFontOfSize:16] TextColor:[UIColor blackColor] TextPosin:NSTextAlignmentCenter BackgourndColor:nil text:@"订单详情"];
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.tableSouce.count+1;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LHOrder1Cell* cell = [tableView dequeueReusableCellWithIdentifier:@"lhOrder1Cell" forIndexPath:indexPath];
            return cell;
        }else{
            LHOrder2Cell* cell = [tableView dequeueReusableCellWithIdentifier:@"lhOrder2Cell" forIndexPath:indexPath];
            return cell;
        }
    }else{
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.textLabel.text = @"选择抵用卷";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        LHOrder2Controller* vc = [[LHOrder2Controller alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
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

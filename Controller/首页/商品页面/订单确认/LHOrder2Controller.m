//
//  LHOrder2Controller.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHOrder2Controller.h"
#import "LHOrder3Cell.h"
#import "LHVoucherView.h"

@interface LHOrder2Controller ()

@end

@implementation LHOrder2Controller

- (void)viewDidLoad {
    self.HideTarbar = YES;
    [super viewDidLoad];
    self.height = 100;
    if (self.voucherArray.count == 0) {
        self.tableView.hidden = YES;
        self.view.backgroundColor = [UIColor lightGrayColor];
        [self.tableView removeFromSuperview];
        [self creatUI];
    }else{
            [self registCellWithNibName:@"LHOrder3Cell" identifer:@"lhOrder3Cell"];
    }
    
    // Do any additional setup after loading the view.
}

- (void)creatUI
{
    LHVoucherView* backView = [[LHVoucherView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 120)];
    UILabel* label = [LHTool LabelWithFrame:CGRectMake(115, 38, 144, 44) Font:[UIFont systemFontOfSize:20] TextColor:[UIColor grayColor] TextPosin:NSTextAlignmentCenter BackgourndColor:nil text:@"暂无可用抵用卷"];
    [backView addSubview:label];
    [self.view addSubview:backView];
}

- (void)updataWithCell:(UITableViewCell *)cell WithModel:(RootModel *)model
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.voucherArray.count;
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

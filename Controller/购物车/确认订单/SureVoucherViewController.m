//
//  SureVoucherViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SureVoucherViewController.h"
#import "voucherCell.h"

@interface SureVoucherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SureVoucherViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavgation];
    
    [self createTableView];
    
    
}

- (void)createTableView
{
    self.tableView = [[UITableView  alloc]initWithFrame:CGRectMake(0,10 , KScr_W, KScr_H ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"voucherCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"voucherCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

}


#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _voucherArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *voucherDic = _voucherArr[indexPath.row];
    
    voucherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voucherCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    cell.voucherView.backgroundColor = [UIColor whiteColor];
    
    [cell.voucherImage sd_setImageWithURL:[NSURL URLWithString:voucherDic[@"voucher_t_customimg"]]  placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    cell.voucherStoreName.text = voucherDic[@"store_name"];
    cell.voucherTime.text = [NSString stringWithFormat:@"活动时间：%@—%@", voucherDic[@"voucher_start_date"],voucherDic[@"voucher_end_date"]];
    cell.voucherPrice.text = [NSString stringWithFormat:@"满%@减%@",voucherDic[@"voucher_limit"],voucherDic[@"voucher_price"]];
    
    cell.voucherStateImage.contentMode = UIViewContentModeScaleAspectFill;
    
    ;
    
    if ([voucherDic[@"voucher_state"] intValue] == 1 ) {
        
        cell.voucherStateImage.image = [UIImage imageNamed:@"states1"];
        
        [cell.voucherStoreName setTextColor:[UIColor blackColor]];
        [cell.voucherPrice setTextColor:[UIColor redColor]];
        
    }
    else if ([voucherDic[@"voucher_state"] intValue] == 2)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.voucherStateImage.image = [UIImage imageNamed:@"states2"];
        
    }
    else if ([voucherDic[@"voucher_state"] intValue] ==3)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.voucherStateImage.image = [UIImage imageNamed:@"states3"];
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.voucherStateImage.image = [UIImage imageNamed:@"states4"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *voucherDic = _voucherArr[indexPath.row];
    if ([voucherDic[@"voucher_state"] intValue] ==1) {
        NSDictionary *dict = self.voucherArr[indexPath.row];
        [self.my_delegate cellDidClick:dict andRow:_row];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



- (void)createNavgation
{
    self.title = @"抵用券";
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    ;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)touchBtn:(UIButton *)btn
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

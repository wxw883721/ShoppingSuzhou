//
//  voucherVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "voucherVC.h"
#import "voucherCell.h"
#import "Size.h"
#import "voucherModel.h"
#import "SuShopDetailViewController.h"

@interface voucherVC ()

@end

@implementation voucherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self requestData];
    [self createTableView];
   
}

-(void)createUI
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

-(void)requestData
{
    if (!self.voucherArr) {
        self.voucherArr = [[NSMutableArray alloc]init];
    }
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    [WXAFNetwork getRequestWithUrl:kVoucher parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)

     {
         
         NSLog(@"%@",resultObject);
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
             
             
             if ([code integerValue] == 200)
             {
                
                if([[resultObject objectForKey:kData] isKindOfClass:[NSArray class]])
                {
                    NSArray *data = [resultObject objectForKey:kData];
                    
                    for (NSDictionary *dict in data)
                    {
                        
                        voucherModel *model = [[voucherModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.voucherArr addObject:model];
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

-(void)createTableView
{
    self.customTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0,10 , KScr_W, KScr_H -64-10) style:UITableViewStylePlain];
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    [self.customTableView registerNib:[UINib nibWithNibName:@"voucherCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"voucherCell"];
    self.customTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.customTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.voucherArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    voucherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voucherCell" forIndexPath:indexPath];
    voucherModel *model = self.voucherArr[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.voucherView.backgroundColor = [UIColor whiteColor];
    [cell.voucherImage sd_setImageWithURL:[NSURL URLWithString:model.voucher_t_img] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
    cell.voucherStoreName.text = model.store_name;
    cell.voucherTime.text = [NSString stringWithFormat:@"活动时间：%@—%@",model.voucher_start_date,model.voucher_end_date];
    cell.voucherPrice.text = [NSString stringWithFormat:@"满%@减%@",model.voucher_limit,model.voucher_price];
    
    cell.voucherStateImage.contentMode = UIViewContentModeScaleAspectFill;
    
    
    if ([model.voucher_state intValue] == 1 ) {
        
        cell.voucherStateImage.image = [UIImage imageNamed:@"states1"];
        
        [cell.voucherStoreName setTextColor:[UIColor blackColor]];
        [cell.voucherPrice setTextColor:[UIColor redColor]];
        
    }
    else if ([model.voucher_state intValue] == 2)
    {
        cell.voucherStateImage.image = [UIImage imageNamed:@"states2"];
        
    }
    else if ([model.voucher_state intValue] ==3)
    {
    
        cell.voucherStateImage.image = [UIImage imageNamed:@"states3"];
        
    
    }
    else
    {
        cell.voucherStateImage.image = [UIImage imageNamed:@"states4"];
    
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    voucherModel *model = self.voucherArr[indexPath.row];
    
    SuShopDetailViewController *vc = [[SuShopDetailViewController alloc] init];
    vc.store_id = model.store_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

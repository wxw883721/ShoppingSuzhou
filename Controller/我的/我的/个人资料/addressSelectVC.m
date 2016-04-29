//
//  addressSelectVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/8/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "addressSelectVC.h"
#import "personalMessageVC.h"

@interface addressSelectVC ()

@end

@implementation addressSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createUI];
    [self requestData];
    [self createTableView];
    
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地址选择";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
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
    [self.view addSubview:self.customTableView];
    
}

-(void)requestData
{
   self.addressArr = [[NSMutableArray alloc]init];
   NSString *parent_id = @"197";
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:parent_id,@"parent_id", nil];
    [WXAFNetwork getRequestWithUrl:kObtainAddress parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             if ([code intValue] == 200) {
                 if ([[responseObject objectForKey:kData] isKindOfClass:[NSDictionary class]]) {
                     
                     [MBProgressHUD showError:[[responseObject objectForKey:kData]objectForKey:kMessage]];
                 }
                 
                 else
                 {
                    NSArray *arr = [responseObject objectForKey:kData];
                     for (NSDictionary *dict in arr) {
                         
                         [self.addressArr addObject:dict];
                     }
                     
                 }
             }
             
             [self.customTableView reloadData];
         }
         else
         {
             [MBProgressHUD showError:kError];
         
         }
     
     }];
   

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.addressArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AddressCellInde = @"addressSelectCell";
    addressSelectCell *cell = (addressSelectCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[addressSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressCellInde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    [cell config:self.addressArr[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.address = [self.addressArr[indexPath.row] valueForKey:@"area_name"];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info setValue:self.address forKey:@"address"];
    [info setValue:[self.addressArr[indexPath.row] valueForKey:@"area_id"] forKey:@"area_id"];
    [self.navigationController popViewControllerAnimated:YES];
    

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

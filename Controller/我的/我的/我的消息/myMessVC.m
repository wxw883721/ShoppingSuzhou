//
//  myMessVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "myMessVC.h"
#import "myMessCell.h"
#import "myMessDetailVC.h"
#import "MJRefresh.h"

@interface myMessVC ()
{
    UIButton *editorBtn;
    UIButton *leftBtn1;
    UIButton *leftBtn2;
    UIView *footView;
    
    BOOL isHeadReshing;
}

@end

@implementation myMessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    [self createUI];
    [self createTableView];
    [self createFootView];
    
    [self setupRefreshing];
    isHeadReshing = NO;
    self.selectedArr = [[NSMutableArray alloc]init];
}

//上拉，下拉刷新
-(void)setupRefreshing
{
    //下拉刷新
    [self.customTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.customTableView headerEndRefreshing];
        
    });
    
}


-(void)requestData
{
    if (!self.myMessageArr) {
        self.myMessageArr = [[NSMutableArray alloc]init];
        
    }
    [self.myMessageArr removeAllObjects];
    
    if (isHeadReshing) {
        isHeadReshing = NO;
    }
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    [WXAFNetwork getRequestWithUrl:kSystemMess parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             
             NSNumber *code = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
                 
                 NSArray *message_arr = [data objectForKey:@"message_array"];
                 NSLog(@"%@",message_arr);
                 if ([message_arr isKindOfClass:[NSNull class]]) {
                     
                     [MBProgressHUD showError:@"无内容"];
                 }
                 else
                 {
                     for (NSDictionary *dict in message_arr) {
                         
                         [self.myMessageArr addObject:dict];
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

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的消息";
    
    leftBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [leftBtn1 setBackgroundImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [leftBtn1 addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn1];
    self.navigationItem.leftBarButtonItem = item;
    
    leftBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 60, 20)];
    [leftBtn2 setTitle:@"全选" forState:UIControlStateNormal];
    [leftBtn2 addTarget:self action:@selector(finishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn2.titleLabel.font = [UIFont systemFontOfSize:Text_Big];
    
    editorBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 40, 0, 60, 20)];
    [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editorBtn addTarget:self action:@selector(editorBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    editorBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Big];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:editorBtn];
    self.navigationItem.rightBarButtonItem = item2;
    
}

//删除按钮
-(void)createFootView
{
    footView = [[UIView alloc]initWithFrame:CGRectMake(0, KScr_H - 114, KScr_W, 50)];
    footView.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    [self.view addSubview:footView];
    
    footView.hidden = YES;
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W/2 - 30, 10, 60, 30)];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.backgroundColor = [UIColor whiteColor];
    deleteBtn.layer.cornerRadius = 5.0;
    deleteBtn.layer.borderColor = [UIColor redColor].CGColor;
    deleteBtn.layer.borderWidth = 1.0;
    [footView addSubview:deleteBtn];
}


-(void)createTableView
{
    
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H - 64) style:UITableViewStylePlain];
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    
    self.customTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.customTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.myMessageArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *myMessCellInde = @"myMessCell";
    myMessCell *cell = (myMessCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[myMessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMessCellInde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.isAll) {
        
        cell.isSelectAll = YES;
    }
    else
    {
        cell.isSelectAll = NO;
        
    }
    if (self.myMessageArr.count == 0) {
        
    }
    else
    {
        
        if ([self.selectedArr containsObject:[self.myMessageArr objectAtIndex:indexPath.row]]) {
            
            cell.isSelect = YES;
        }
        else
        {
            cell.isSelect = NO;
            
        }
        
        if (self.isEditor) {
            
            cell.isEditor = YES;
        }
        else
        {
            cell.isEditor = NO;
        }
        
        cell.delegate = self;
        [cell createCell:self.myMessageArr[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    myMessDetailVC *vc = [[myMessDetailVC alloc]init];
    
    vc.message_id = [self.myMessageArr[indexPath.row] valueForKey:@"message_id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


//删除系统消息get请求
-(void)deleteSystemMessage
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    
    NSString *messageId = [[NSString alloc]init];
    
    for (int i = 0; i < self.selectedArr.count; i ++) {
        
        NSString *str = [self.selectedArr[i] valueForKey:@"message_id"];
        if ([messageId isEqualToString:@""]) {
            
        }
        else
        {
            messageId = [messageId stringByAppendingString:@","];
        }
        messageId = [messageId stringByAppendingString:str];
    }
    
    NSLog(@"%@",messageId);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",messageId,@"message_id", nil];
    [WXAFNetwork getRequestWithUrl:kDeleteSystemMess parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             
             if ([code integerValue] == 201) {
                 
                 [MBProgressHUD showSuccess:[data objectForKey:kMessage]];
                 [self.myMessageArr removeObject:self.selectedArr];
                 [self.selectedArr removeAllObjects];
                 [self refresh];
                 
             }
             else
             {
                 [MBProgressHUD showError:[data objectForKey:kMessage]];
                 
             }
             [self headerRefreshing];
             [self.customTableView reloadData];
         }
         else
         {
             [MBProgressHUD showError:kError];
             
         }
         
     }];
    
}

//删除按钮
-(void)deleteBtn:(UIButton *)btn
{
    
    [self deleteSystemMessage];
    
}


-(void)touchBtn:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//全选按钮
-(void)finishBtn:(UIButton *)btn
{
    if (self.selectedArr.count > 0) {
        
        [self.selectedArr removeAllObjects];
        
    }
    for (NSDictionary *dic in self.myMessageArr) {
        
        [self.selectedArr addObject:dic];
    }
    
    [self.customTableView reloadData];
}


//编辑按钮
-(void)editorBtn:(UIButton *)btn
{
    if ([editorBtn.titleLabel.text isEqualToString:@"编辑"]) {
        
        [editorBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn2];
        self.navigationItem.leftBarButtonItem = item;
        
        footView.hidden = NO;
        self.isEditor = YES;
    }
    else
    {
        [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn1];
        self.navigationItem.leftBarButtonItem = item;
        
        if (self.selectedArr.count > 0) {
            
            [self.selectedArr removeAllObjects];
            
        }
        footView.hidden = YES;
        self.isEditor = NO;
        self.isAll = NO;
        
    }
    
    [self.customTableView reloadData];
}


-(void)selectItem:(NSDictionary *)selectItem isSelected:(BOOL)isSelected
{
    if ([self.selectedArr containsObject:selectItem]) {
        
        [self.selectedArr removeObject:selectItem];
    }
    else
    {
        [self.selectedArr addObject:selectItem];
        
    }
    
    if (self.selectedArr.count == self.myMessageArr.count) {
        
        self.isAll = YES;
    }
    else
    {
        self.isAll = NO;
    }
    
}

//刷新
-(void)refresh
{
   [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn1];
    self.navigationItem.leftBarButtonItem = item;

    if (self.selectedArr.count > 0) {
        
        [self.selectedArr removeAllObjects];
        
    }
   // leftBtn1.hidden = YES;
    leftBtn1.hidden = NO;
    leftBtn2.hidden = YES;
    footView.hidden = YES;
    self.isEditor = NO;
    self.isAll = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

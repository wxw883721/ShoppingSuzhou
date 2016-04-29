//
//  SearchViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "CustomTextField.h"
#import "SearchDesViewController.h"
#import "GodsViewController.h"
#import "ShopViewController.h"


@interface SearchViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_historyRecordKey;
    CustomTextField *text;
    UISegmentedControl *_segment;
    UITableView *_tableView;
    
    UIButton *cleanButton;
    
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /** 1. 创建导航栏按钮 */
    [self createNavgation];
    
    [self createView];
    
    [self createUI];

}


- (void)changeChooseType:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
         text.placeholder = @"请输入商品关键字";
    }
    else
    {
         text.placeholder = @"请输入商户关键字";
    }
}

/** 1. 创建导航栏按钮 */
-(void)createNavgation
{
//    UIView *seachView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    NSArray *imageNames = @[@"商品",@"商户"];
    
    _segment = [[UISegmentedControl alloc] initWithItems:imageNames];
    _segment.tintColor = [UIColor whiteColor];
    _segment.frame = CGRectMake(0, 0, 100, 35);
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(changeChooseType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segment;
    
    
//    for (int i = 0;i < imageNames.count;i ++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(60*i, 0, 60, 40);
//        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
//        [seachView addSubview:button];
//    }
//    self.navigationItem.titleView = seachView;
}

/** 2.创建页面，添加SearchBar TableView*/
-(void)createView
{
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    searchBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_background.png"]];
    
    text = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 10,SCREEN_WIDTH-70, 40) andisRightMode:NO andisNeedBorder:YES andisMain:NO];
    text.placeholder = @"请输入商品关键字";
    [searchBarView addSubview:text];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH-50, 15, 40, 30);
    [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_background.png"]]];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchBarView addSubview:button];
    
    [self.view addSubview:searchBarView];
   
}
//搜索按钮点击事件
-(void)searchClicked
{
    NSString *after = text.text;

    //如果输入为空
    if ([after isEqualToString:@""])
    {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"请输入商品关键字" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }
    
    NSMutableArray * current;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"historyRecord"]) {
        NSArray * currentHistory =[[NSUserDefaults standardUserDefaults]objectForKey:@"historyRecord"];
        current = [currentHistory mutableCopy];
    
    } else {
        current = [NSMutableArray array];
    }
    
    BOOL needInsert = YES;
    for (NSString * record in current) {
        if ([after isEqualToString:record]) {
            needInsert = NO;
            break;
        }
    }
    if (needInsert) {
        [current insertObject:after atIndex:0];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"historyRecord"];
    
    if (_segment.selectedSegmentIndex == 0) {
        SearchDesViewController *vc = [[SearchDesViewController alloc] init];
        vc.searchString = after;
        vc.segNum = 0;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SearchDesViewController *vc = [[SearchDesViewController alloc] init];
        vc.searchString = after;
        vc.segNum = 1;
//        SearchDesViewController * list= [[SearchDesViewController alloc]init];
//        [list setCurrentString:after];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/** 3.创建UI控件*/
- (void)createUI
{
    _tableView =[[UITableView alloc]init];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView registerClass:[SearchCell class] forCellReuseIdentifier:@"searchCell"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    cleanButton =[[UIButton alloc]init];
    [self.view addSubview:cleanButton];
    [cleanButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [cleanButton setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.00f]];
    cleanButton.layer.cornerRadius=5;
    [cleanButton.titleLabel setFont:[UIFont systemFontOfSize:Text_Big]];
    [cleanButton setTitleColor:[UIColor colorWithRed:56.0f/255.0f green:56.0f/255.0f blue:56.0f/255.0f alpha:1.00f] forState:UIControlStateNormal];
    [cleanButton addTarget:self action:@selector(onCleanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//清除历史按钮点击事件
- (void)onCleanBtnClick
{
    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"是否要清除搜索历史纪录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",@"否",nil];
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"historyRecord"];
        [_historyRecordKey removeAllObjects];
        [self hiddenRecord];
        [_tableView reloadData];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [self prePareForRecord];
}

- (void)prePareForRecord
{
    if (_historyRecordKey) {
        [_historyRecordKey removeAllObjects];
    }
    else
    {
        _historyRecordKey =[NSMutableArray array];
    }
    NSArray * historyRecord;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"historyRecord"])
    {
        historyRecord = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyRecord"];
    }
    
    _historyRecordKey = [historyRecord mutableCopy];
    if (_historyRecordKey.count>0 && [self isHiddenCleanAndTable])
    {
        [self showRecord];
    }
    else if(_historyRecordKey.count==0 && ![self isHiddenCleanAndTable])
    {
        [self hiddenRecord];
    }
    [_tableView reloadData];
    [self cleanButtonAndTableAdjust];
    
}

- (void)cleanButtonAndTableAdjust
{
    
    if (_historyRecordKey.count==0) {
        return;
        
    } else if (_historyRecordKey.count>=5) {
        _tableView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 200);
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.bounces = NO;
        cleanButton.frame = CGRectMake(60, _tableView.frame.size.height+70, SCREEN_WIDTH-120, 30);
        
    } else {
        _tableView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 40*_historyRecordKey.count);
        _tableView.bounces = NO;
        cleanButton.frame = CGRectMake(60, _tableView.frame.size.height+70, SCREEN_WIDTH-120, 30);

    }
    
}

- (BOOL)isHiddenCleanAndTable
{
    if (_tableView.hidden && cleanButton.hidden) {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
- (void)hiddenRecord
{
    _tableView.hidden=YES;
    cleanButton.hidden=YES;
 
}

- (void)showRecord
{
    _tableView.hidden=NO;
    cleanButton.hidden=NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyRecordKey.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = _historyRecordKey[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString * currentString =_historyRecordKey[indexPath.row];
//    SearchDesViewController * goodList =[[SearchDesViewController alloc]init];
//    [goodList setCurrentString:currentString];
//    [self.navigationController pushViewController:goodList animated:YES];

    //点击搜索的内容记录
    //将储存的历史记录，置为搜索内容
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * currentString =_historyRecordKey[indexPath.row];
    text.text = currentString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [text resignFirstResponder];
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

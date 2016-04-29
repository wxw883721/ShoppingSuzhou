
//
//  LHSecondViewController.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/5/29.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHSecondViewController.h"

@interface LHSecondViewController ()

@end

@implementation LHSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.HideTarbar) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _y, SCREEN_WIDTH, SCREEN_HEIGHT-_y-64-_foot) style:UITableViewStyleGrouped];
 
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _y, SCREEN_WIDTH, SCREEN_HEIGHT-_y-64-49-_foot) style:UITableViewStyleGrouped];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)registCellWithClass:(Class )className identifer:(NSString *)identifer
{
    self.identifer = identifer;
    [self.tableView registerClass:className  forCellReuseIdentifier:identifer];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count == 0) {
        return 10;
    }
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.identifer forIndexPath:indexPath];
    if (self.dataSource.count > 0) {
        RootModel* model = self.dataSource[indexPath.row];
        [self updataWithCell:cell WithModel:model];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.headerView;
}

#pragma mark- 注册cell
- (void)registCellWithNibName:(NSString*)nibName identifer:(NSString*)identifer
{
    self.identifer = identifer;
    UINib* nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifer];
}

#pragma mark- 获取cell高度
- (void)getHeight:(NSInteger)height
{
    self.height = height;
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

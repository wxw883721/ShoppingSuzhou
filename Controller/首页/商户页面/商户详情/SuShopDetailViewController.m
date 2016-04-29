//
//  SuShopDetailViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SuShopDetailViewController.h"
#import "LHShopDetaiModel.h"
#import "StarView.h"
#import "DetailEvaluationViewController.h"
#import "LHRecommendViewController.h"
#import "LHGodsDetailViewController.h"
#import "MapAddressViewController.h"

@interface SuShopDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) LHShopDetaiModel *model;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableDictionary *mansongDic;

@end

@implementation SuShopDetailViewController
{
    
    BOOL _init;
    float _longitude;
    float _latitude;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

- (void)loadData
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    
    NSString *url = nil;
    
    if ([info objectForKey:kKey]) {
        NSString *key = [info objectForKey:kKey];
        NSString * latitude = [info objectForKey:@"lat"] ;
        NSString * longitude = [info objectForKey:@"lon"];
        url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=show&id=%@&lng=%@&lat=%@&key=%@", self.store_id, longitude, latitude,key];
    }
    else
    {
        url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=show&id=%@",_store_id];
    }
    
    [WXAFNetwork getRequestWithUrl:url parameters:nil resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         
         if (isSuccessed)
         {
             NSNumber *code = [responseObject objectForKey:kCode];
             
             if ([code integerValue] == 200)
             {
                 NSDictionary *data = [responseObject objectForKey:kData];
                 
                 NSDictionary *storeInfoDic = [data objectForKey:@"store_info"];
                 
                 self.isSelected = [storeInfoDic[@"store_fav"] intValue];
                 NSLog(@"%d",self.isSelected);
                 
                 self.saveBtn.selected = self.isSelected;
             }
             else
             {
                 [MBProgressHUD showError:[responseObject objectForKey:kData][kMessage]];
             }
         }
         else
         {
             [MBProgressHUD showError:kError];
         }
         
     }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mansongDic = [[NSMutableDictionary alloc] init];
    
    [self setViewTitle:@"商户详情"];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self creatNavi];
    
    [self createTableView];
    
    [self request];
}

- (void)createTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableView];
    
}

- (void)creatNavi
{
    UIButton * saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [saveBtn setImage:[UIImage imageNamed:@"wujx"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"wujxxx"] forState:UIControlStateSelected];
    
    [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    self.saveBtn = saveBtn;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)saveClick:(UIButton *)button
{
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:kKey];
   
    if (_saveBtn.selected == NO)
    {
        [self cacheWithUrl:[NSString stringWithFormat:SAVE_URL, _model.store_id, key] target:self action:@selector(analyzed:)];
    }
    else
    {
        NSString *url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=member_centre&op=rmstorecollect&key=%@&collect_id=%@&fav_type=store",key,_model.store_id];
        
        [self cacheWithUrl:url target:self action:@selector(cancelSave:)];
        
    }
}

- (void)cancelSave:(NSData *)data
{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *message = dic[@"data"][@"message"];
    
    if ([message isEqualToString:@"Success"])
    {
        _saveBtn.selected = _isSelected = NO;
        [MBProgressHUD showSuccess:@"已移除收藏!"];
    }
    else
        [MBProgressHUD showError:message];
}

- (void)analyzed:(NSData *)data
{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *message = dic[@"data"][@"message"];
    
    if ([message isEqualToString:@"Success"])
    {
        _saveBtn.selected = _isSelected = YES;
        [MBProgressHUD showSuccess:@"收藏成功!"];
    }
    else
        [MBProgressHUD showError:message];
}


- (void)request
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    
    NSString *url = nil;
    
    if ([info objectForKey:kKey])
    {
        NSString *key = [info objectForKey:kKey];
        NSString * latitude = [info objectForKey:@"lat"] ;
        NSString * longitude = [info objectForKey:@"lon"];
        url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=show&id=%@&lng=%@&lat=%@&key=%@", self.store_id, longitude, latitude,key];
    }
    else
    {
        url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=stores&op=show&id=%@",_store_id];
    }
  
    [self cacheWithUrl:url target:self action:@selector(analyze:)];
}

- (void)analyze:(NSData*)data
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",dic);
    
    
    if ([dic[@"data"][@"mansong_info"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *mansong = dic[@"data"][@"mansong_info"];
        _mansongDic = [NSMutableDictionary dictionaryWithDictionary:mansong];
        
        NSLog(@"%@",mansong[@"rules"][0][@"mansong_goods_name"]);
        
    }
    
    NSDictionary* appdic = dic[@"data"][@"store_info"];
    _model = [[LHShopDetaiModel alloc] init];
    [_model setValuesForKeysWithDictionary:appdic];
    
    
    NSArray* recommendArr = dic[@"data"][@"recommended_goods_list"];
    
    for (NSDictionary* recomDic in recommendArr)
    {
        LHShopDetaiModel* model1  = [[LHShopDetaiModel alloc] init];
        [model1 setValuesForKeysWithDictionary:recomDic];
        [self.dataSource addObject:model1];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0)
    {
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        [headerView sd_setImageWithURL:[NSURL URLWithString:_model.store_cover] placeholderImage:[UIImage imageNamed:@"411-200.png"]];
        NSLog(@"%@",_model.store_cover);
        
        [cell.contentView addSubview:headerView];
        
    }
    else if(indexPath.row == 1)
    {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-170, 40)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.text = _model.store_name;
        titleLabel.font = [UIFont systemFontOfSize:Text_Big];
        [cell.contentView addSubview:titleLabel];
        
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-80, 50)];
        addressLabel.font = [UIFont systemFontOfSize:Text_Normal];
        addressLabel.textColor = [UIColor lightGrayColor];
        addressLabel.numberOfLines = 0;
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addressLabel.text = _model.store_address;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAction)];
        [addressLabel addGestureRecognizer:tap];
        addressLabel.userInteractionEnabled = YES;
        
        [cell.contentView addSubview:addressLabel];
        
    
        UILabel *distanceLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, 15, 100, 20)];
        distanceLable.font = [UIFont systemFontOfSize:Text_Normal];
        distanceLable.textAlignment = NSTextAlignmentRight;
   
        if (_model && [_model.store_juli floatValue] <= 1000)
        {
            distanceLable.text = [NSString stringWithFormat:@"%@米",_model.store_juli];
        }
        else if(_model && [_model.store_juli floatValue] > 1000)
        {
            distanceLable.text = [NSString stringWithFormat:@"%.2f千米",[_model.store_juli floatValue]/1000];
        }
        else
        {
            distanceLable.text = @"";
        }
        
        
        [cell.contentView addSubview:distanceLable];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 20, 1, 60)];
        lineImageView.backgroundColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:lineImageView];
        
        UIButton *phoneBtn = [[UIButton alloc ]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 35, 30, 30)];
        [phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];;
        [phoneBtn addTarget:self action:@selector(phoneCall:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:phoneBtn];
    }
    else if (indexPath.row == 2)
    {
        if(_model)
        {
            StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
            [starView setStar:[_model.seval_total floatValue]];
            [cell.contentView addSubview:starView];
            
            UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 60, 40)];
            scoreLabel.text = [NSString stringWithFormat:@"%.1f分", [_model.seval_total floatValue]];
            scoreLabel.font = [UIFont systemFontOfSize:Text_Big];
            [cell.contentView addSubview:scoreLabel];
            
            UILabel *commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0, 100, 40)];
            commentCountLabel.text = [NSString stringWithFormat:@"%d人评价", [_model.seval_num intValue]];
            commentCountLabel.font = [UIFont systemFontOfSize:Text_Big];
            [cell.contentView addSubview:commentCountLabel];
        }
        
        UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25, 10, 15, 20)];
        nextImageView.image = [UIImage imageNamed:@"30-40"];
        [cell.contentView addSubview:nextImageView];
        
    }
    else if(indexPath.row == 3)
    {
        if (_model&&_mansongDic.count > 0)
        {
         
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
            label.text = @"店铺活动信息";
            label.font = [UIFont systemFontOfSize:Text_Big];
            [cell.contentView addSubview:label];
            
            //活动商店
            UILabel *mansongName = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-10, 30)];
            mansongName.font = [UIFont boldSystemFontOfSize:Text_Big];
            mansongName.text = _mansongDic[@"mansong_name"];
            [cell.contentView addSubview:mansongName];
            
            //活动时间
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH-20, 15)];
            timeLabel.text = [NSString stringWithFormat:@"%@~~%@",_mansongDic[@"start_time"],_mansongDic[@"end_time"]];
            timeLabel.font = [UIFont systemFontOfSize:Text_Small];
            [cell.contentView addSubview:timeLabel];
            
            //活动规则
            NSDictionary *mansongRulesDic = _mansongDic[@"rules"][0];
            UILabel *mansongRule = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, SCREEN_WIDTH-20, 40)];
            mansongRule.text = [NSString stringWithFormat:@"单笔订单满%@元，立减现金%@元",mansongRulesDic[@"price"],mansongRulesDic[@"discount"]];
            [cell.contentView addSubview:mansongRule];
            
            
            //赠品
            NSString *goodsStr = mansongRulesDic[@"mansong_goods_name"];
            if (goodsStr.length > 0)
            {
                UILabel *mansongGoods = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, SCREEN_WIDTH-120, 20)];
                mansongGoods.font = [UIFont systemFontOfSize:Text_Normal];
                mansongGoods.textColor = [UIColor orangeColor];
                mansongGoods.text = [NSString stringWithFormat:@"赠品：%@",mansongRulesDic[@"mansong_goods_name"]];
                [cell.contentView addSubview:mansongGoods];
            }
        }
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        label.text = @"本店推荐商品";
        label.font = [UIFont systemFontOfSize:Text_Big];
        [cell.contentView addSubview:label];
        
        UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 10, 15, 20)];
        [moreImageView setImage:[UIImage imageNamed:@"30-40"]];
        [cell.contentView addSubview:moreImageView];
        
        UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emptyBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        [emptyBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:emptyBtn];

        
        for (int  i = 0; i < self.dataSource.count; i ++)
        {
            
            UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.25*i, 40, SCREEN_WIDTH*0.25, 130*0.3+SCREEN_WIDTH*0.2)];
            
            LHShopDetaiModel* model = self.dataSource[i];
            UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.02, 0, SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
            [pic sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
            UILabel * Label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(pic.frame), CGRectGetMaxY(pic.frame), CGRectGetWidth(pic.frame), CGRectGetHeight(goodsView.frame)*0.15)];
            UILabel * Label2 = [[UILabel alloc] initWithFrame:CGRectMake(Label1.frame.origin.x, CGRectGetMaxY(Label1.frame), CGRectGetWidth(Label1.frame), CGRectGetHeight(Label1.frame))];
            Label1.font = [UIFont systemFontOfSize:Text_Small];
            Label1.text = model.goods_name;
            Label2.font = [UIFont systemFontOfSize:Text_Small];
            Label2.text = [NSString stringWithFormat:@"￥%.2f",[model.goods_price floatValue]];
            [goodsView addSubview:pic];
            [goodsView addSubview:Label1];
            [goodsView addSubview:Label2];
            
            goodsView.tag = 1222+i;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushGoodsDetail:)];
            [goodsView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:goodsView];
        }
    }
    
    return cell;
}

- (void)addressAction
{
    MapAddressViewController *vc = [[MapAddressViewController alloc] init];
    vc.lat = _model.store_y;
    vc.lng = _model.store_x;
    vc.store_name = _model.store_name; 
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushGoodsDetail:(UITapGestureRecognizer *)tap
{
    UIView *goodsView = tap.view ;
    
    
    int i = goodsView.tag-1222;
    
    LHShopDetaiModel *model = self.dataSource[i];
    
    LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)moreAction
{
    LHRecommendViewController *vc = [[LHRecommendViewController alloc] init];
    
    vc.store_id = self.store_id;
    
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)phoneCall:(UIButton *)sender
{
    
    
    NSString *store_phone = _model.store_tel;
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",store_phone]];
    if ( !_phoneCallWebView ) {
        _phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    }
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 200;
    }
    else if (indexPath.row == 1)
    {
        return 100;
    }
    else if (indexPath.row == 2)
    {
        return 40;
    }
    else if (indexPath.row == 3)
    {
        if (_mansongDic.count > 0)
        {
            return 115;
        }
        else
            return 0.1;
    }
    else
        return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        if ([_model.seval_num isEqualToString:@"0"])
        {
            [MBProgressHUD showError:@"暂无评论"];
            return;
        }
        else
        {
            DetailEvaluationViewController *vc = [[DetailEvaluationViewController alloc] init];
            vc.shop_id = self.store_id;
            vc.shop_count = _model.seval_total;
            [self.navigationController pushViewController:vc animated:NO];
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)BackAction
{
    if ([_backRootVC isEqualToString:@"1"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
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

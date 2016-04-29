//
//  LHGodsDetailViewController.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/11.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHGodsDetailViewController.h"
#import "LHShopDetailViewCell.h"
#import "LHShopDetail2TableViewCell.h"
#import "ShoppingCarViewController.h"
#import "LHGoodsDetailModel.h"
#import "LHGoodsJSViewController.h"
#import "SuShopDetailViewController.h"
#import "StarView.h"
#import "ShangpinEvaluationViewController.h"
#import "makeSureOrderVC.h"
#import "UmShareViewController.h"
#import "IQKeyboardManager.h"
#import "KDCycleBannerView.h"

#define KeyBoardManager [IQKeyboardManager sharedManager]

@interface LHGodsDetailViewController ()<KDCycleBannerViewDataource,KDCycleBannerViewDelegate>

@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,strong) UIView *sortView;
@property (nonatomic,strong) NSString *goods_discount;
@property (nonatomic,strong) KDCycleBannerView *showBanner;
@property (nonatomic,strong) NSMutableArray *bannerImages;
@property (nonatomic,strong) NSDictionary *goodsInfoDict;
@property (nonatomic,strong) NSDictionary *dataDict;

@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *specLabel;

@property (nonatomic,strong) NSMutableArray *specValueIDArr;
@property (nonatomic,strong) UIView *grayView;

@property (nonatomic,strong) NSString *specGoodsID;

@property (nonatomic,strong) NSString *promotion_price;

@property (nonatomic,strong) NSDictionary *xianshiInfoDict;

@property (nonatomic,strong) NSDictionary *dazheInfoDict;

@end


@implementation LHGodsDetailViewController
{
    UIScrollView * _specView;
    
    UIView *_grayView;
    NSArray *_array;
    UIImageView *_backImage;
    UILabel *_label;
    NSString *_number;
    NSString *isCollected;
    
    NSString *commentCount;
    UILabel *countLabel;
    UILabel *priceLabel;
    
    NSString *_price;
    NSString *_saleCount;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.HideTarbar = YES;
    [self loadData];
}

- (NSMutableArray *)bannerImages
{
    if (!_bannerImages)
    {
        _bannerImages = [[NSMutableArray alloc]init];
    }
    
    return _bannerImages;
}

- (void)showShopCar
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    [WXAFNetwork getRequestWithUrl:kShoppingCar parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             
             NSDictionary *data = [responseObject objectForKey:kData];
             
             NSMutableArray *shoppingArr = [[NSMutableArray alloc] init];
             
             if ([code integerValue] ==200) {
                 
                 NSArray *cart = [data objectForKey:@"cart_list"];
                 
                 for (NSDictionary *dict in cart) {
                     [shoppingArr addObject:dict];
                 }
                 
                 //小图标和导航栏标题
                 int iconNum = 0;
                 for (int i = 0; i < shoppingArr.count; i ++) {
                     
                     iconNum = iconNum + [[shoppingArr[i] valueForKey:@"goods_num"]intValue];
                     
                 }
                 
                 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, SCREEN_HEIGHT-49-64+5, 20 , 20)];
                 label.backgroundColor = [UIColor orangeColor];
                 label.layer.cornerRadius = 10;
                 label.layer.masksToBounds = YES;
                 label.textAlignment = NSTextAlignmentCenter;
                 label.font = [UIFont systemFontOfSize:Text_Small];
                 label.text = [NSString stringWithFormat:@"%d",iconNum];
                 label.textColor = [UIColor whiteColor];
                 [self.view addSubview:label];
                 
            }
             else
             {
                 [MBProgressHUD showError:[data objectForKey:kMessage]];
                 
             }

}
     }];
     
}


- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    
    NSString *url = [NSString stringWithFormat:GOODSDETAIL_URL,self.goods_id];
    
    [WXAFNetwork getRequestWithUrl:url parameters:nil resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([self isLogin] == NO)
        {
            
        }
        
        else
        {
            if (isSuccessed)
            {
                NSDictionary* dataDic = [responseObject objectForKey:@"data"];
                self.isSelect = [dataDic[@"goods_info"][@"goods_collect"] intValue];
                self.collectBtn.selected = self.isSelect;
                [self showShopCar];
            }
            else
            {
            }

        }
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setViewTitle:@"商品详情"];
    UIView* view = [self getView];
    
    _specValueIDArr = [[NSMutableArray alloc] init];
    
    [self isLogin];
    
    self.headerView = view;
    self.headerHeight = 256;
    [self request];

    [self createNavgation];
    
    [self creatButtons];
    _number = @"1";
    _array = @[@"选择商品分类",@"选择购买数量",@"查看商品介绍"];
    [self registCellWithNibName:@"LHShopDetailViewCell" identifer:@"lhShopDetailCell"];
    [self registCellWithNibName:@"LHShopDetail2TableViewCell" identifer:@"lhShopDetail2Cell"];
    [self registCellWithClass:[UITableViewCell class] identifer:@"actCell"];
    [self request];
    [self setupKeyBoard];

}

- (BOOL)isLogin
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:kKey])
    {
        self.collectBtn.enabled = NO;
        self.collectBtn.selected = NO;
        return NO;
    }
    else
        return YES;
}

- (void)createNavgation
{
    UIButton * collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 0, 30, 30);
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"wujx"] forState:UIControlStateNormal];
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"wujxxx"] forState:UIControlStateSelected];
    self.collectBtn = collectBtn;
    [collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithCustomView:_collectBtn];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:collectItem];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 25, 25);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"fenx"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [arr addObject:shareItem];
    
    self.navigationItem.rightBarButtonItems = arr;
}

//键盘
- (void)setupKeyBoard{
    
    [KeyBoardManager setEnable:YES];
    [KeyBoardManager setEnableAutoToolbar:NO];
    [KeyBoardManager setKeyboardDistanceFromTextField:15];
    [KeyBoardManager setShouldResignOnTouchOutside:YES];
    [KeyBoardManager setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [KeyBoardManager setCanAdjustTextView:YES];
}

#pragma mark - 收藏按钮的相关
//收藏按钮
- (void)collectAction:(UIButton *)sender
{
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:kKey];
    
    
    if (key.length < 1)
    {
        self.collectBtn.selected = self.isSelect = NO;
        [MBProgressHUD showError:@"请登录"];
    }
    else
    {
        if (sender.selected == NO)
        {
            
            NSString *url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=member_centre&op=goodscollect&goods_id=%@&key=%@",_goods_id,key];
            
            [self cacheWithUrl:url target:self action:@selector(save:)];
        }
        else
        {
            NSString *url = [NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=member_centre&op=rmstorecollect&key=%@&collect_id=%@&fav_type=goods",key,_goods_id];
            
            [self cacheWithUrl:url target:self action:@selector(cancelSave:)];
        }
    }
}

//取消收藏
- (void)cancelSave:(NSData *)data
{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *message = dic[@"data"][@"message"];
    
    _collectBtn.selected = _isSelect = NO;
    
    if([message isEqualToString:@"Success"])
    {
        [MBProgressHUD showSuccess:@"取消收藏成功"];
    }
    else
        [MBProgressHUD showSuccess:message];
}
//收藏
- (void)save:(NSData *)data
{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *message = dic[@"data"][@"message"];
    
    _collectBtn.selected = _isSelect = YES;
    
    if([message isEqualToString:@"Success"])
    {
        [MBProgressHUD showSuccess:@"收藏成功"];
    }
    else
        [MBProgressHUD showSuccess:message];
}

#pragma mark - 分享按钮
//分享按钮
- (void)shareAction:(UIButton *)sender
{
    
    UmShareViewController *vc = [[UmShareViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma  mark - 头部和底部
- (UIView*)getView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 256)];
    view.backgroundColor = [UIColor blackColor];
    
    if (_bannerImages.count == 1)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_bannerImages[0]] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
        [view addSubview:imageView];
    }
    else
    {
        _showBanner = [[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        
        _showBanner.delegate = self;
        _showBanner.datasource = self;
        
        
        _showBanner.continuous = YES;
        _showBanner.autoPlayTimeInterval = 3.0;
        
        [view addSubview:_showBanner];
    }
    
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, SCREEN_WIDTH-10, 56)];
    _label.numberOfLines = 0;
    [view addSubview:_label];
    
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    return view;
}
#pragma mark - KDCycleDelegate
// 轮播banner
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    NSLog(@"%d",self.bannerImages.count);
    
    return self.bannerImages;
}
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index
{
    return UIViewContentModeScaleToFill;
}
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index
{
    return [UIImage imageNamed:@"200-200.png"];
}
- (UIImage *)placeHolderImageOfZeroBannerView
{
    UIImage *image = [UIImage imageNamed:@"200-200.png"];
    
    return  image;
}

// 滚动到第几张
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index
{
    
}

/** 选择第几张，点击轮播图*/
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    
}

#pragma mark - 创建底部按钮
- (void)creatButtons
{
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49-64, 80, 49)];
//    button1.backgroundColor = [UIColor redColor];
    [button1 setImage:[UIImage imageNamed:@"gouwuche2"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"gouwuche2"] forState:UIControlStateHighlighted];
    [button1 addTarget:self action:@selector(shopCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame), CGRectGetMinY(button1.frame), (SCREEN_WIDTH-80)/2, 49)];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    [button2 setTitle:@"加入购物车" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor orangeColor];
    [button2 addTarget:self action:@selector(addShop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button2.frame), CGRectGetMinY(button2.frame), CGRectGetWidth(button2.frame), 49)];
    button3.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    [button3 setTitle:@"立即购买" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor colorWithRed:212/255.0 green:0 blue:0 alpha:1.0];
    [button3 addTarget:self action:@selector(buyShop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

#pragma mark - 购物车，立即购买相关方法
//跳转到购物车
- (void)shopCar
{
    ShoppingCarViewController *shoppingVc = [[ShoppingCarViewController alloc] init];
    shoppingVc.isPop = YES;
    
    [self.navigationController pushViewController:shoppingVc animated:YES];
//    self.tabBarController.selectedIndex = 2;
 
}

//加入购物车
- (void)addShop
{
    NSUserDefaults* info = [NSUserDefaults standardUserDefaults];
    NSString* key = [info objectForKey:kKey];
    if (!key)
    {
        self.tabBarController.selectedIndex = 3;
    }
    else
    {
        
        NSString *url = nil;
        
        if (self.specGoodsID.length == 0)
        {
            url = [NSString stringWithFormat:ADDSHOPCAR_URL,key,self.goods_id,_number];
        }
        else
        {
            url = [NSString stringWithFormat:ADDSHOPCAR_URL,key,self.specGoodsID,_number];
        }

        
        [self cacheWithUrl:url callback:^(NSData *data)
        {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString* str = dic[@"data"][@"message"];
            [MBProgressHUD showSuccess:str];
            
            [self showShopCar];
            [self request];
            
        }];
    }
}

//立即购买
- (void)buyShop
{
    
    
    
    NSUserDefaults* info = [NSUserDefaults standardUserDefaults];
    NSString* key = [info objectForKey:kKey];
    if (!key)
    {
        self.tabBarController.selectedIndex = 3;
    }
    else
    {
        NSDictionary *parameters = nil;
        
        if (self.specGoodsID.length == 0)
        {
            parameters = @{@"key":key,@"cart_id":[NSString stringWithFormat:@"%@|%@",self.goods_id,_number],@"ifcart":@"0"};
        }
        else
        {
            parameters = @{@"key":key,@"cart_id":[NSString stringWithFormat:@"%@|%@",self.specGoodsID,_number],@"ifcart":@"0"};
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [self PostRequestWithUrl:SHOPCARBUY_URL parameters:parameters success:^(LHRequest *request, NSData *data)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];

             NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             
             NSLog(@"%@",dic);
             
             NSNumber *code = dic[@"code"];
             
             if ([code integerValue] == 200)
             {
                 makeSureOrderVC * vc = [[makeSureOrderVC alloc] init];
                 vc.selectedDic = dic;
                 vc.ifcart = @"0";
                 [self.navigationController pushViewController:vc animated:YES];
             }
             else
             {
                 [MBProgressHUD showError:dic[kData][kMessage]];
             }
             
             
         }failed:^(LHRequest *request) {
             
         }];
        
    }
}

#pragma mark- 请求数据
- (void)request
{
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    
    NSString *url = nil;
    
    if (_specGoodsID&&_specGoodsID.length > 0)
    {
        url = [NSString stringWithFormat:GOODSDETAIL_URL,self.specGoodsID];
    }
    else
    {
        url = [NSString stringWithFormat:GOODSDETAIL_URL,self.goods_id];
    }
    
    NSLog(@"%@",url);
    
    [self cacheWithUrl:url callback:^(NSData *data) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *code = dic[@"code"];
        if ([code integerValue] == 200)
        {
            NSDictionary* dataDic = dic[@"data"];
            
            NSLog(@"%@",dic);
 
            _dataDict = [NSDictionary dictionaryWithDictionary:dataDic];
            
            NSString *goodsImageUrl = dataDic[@"goods_image"];
            
            NSArray *imageUrlArr = [goodsImageUrl componentsSeparatedByString:@","];
            
            _bannerImages = [NSMutableArray arrayWithArray:imageUrlArr];
            
            self.headerView = [self getView];
            
            LHGoodsDetailModel* model = [[LHGoodsDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:kKey])
            {
                isCollected = NO;
            }
            else
            {
                 isCollected = model.goods_fav;
            }
            
            
           
            
            //分割字符串
            NSString *string = [NSString stringWithFormat:@"%@", model.goods_image];
            NSArray *arr = [string componentsSeparatedByString:@","];
            
            [_backImage sd_setImageWithURL:arr[0]  placeholderImage:[UIImage imageNamed:@"200-200.png"]];
            
            NSDictionary* goods_infoDic = dataDic[@"goods_info"];
            
            _goodsInfoDict = [NSDictionary dictionaryWithDictionary:goods_infoDic];
            
            [model setValuesForKeysWithDictionary:goods_infoDic];
            [self.dataSource addObject:model];
            _label.text = model.goods_name;
            
            _goods_discount = [NSString stringWithFormat:@"%.1f",[model.goods_discount floatValue]];
            if ([_goodsInfoDict objectForKey:@"promotion_price"])
            {
                _promotion_price = [NSString stringWithFormat:@"%@",[_goodsInfoDict objectForKey:@"promotion_price"]];
            }
            
            if ([[dataDic objectForKey:@"xianshi_info"] isKindOfClass:[NSDictionary class]])
            {
                _xianshiInfoDict = [NSDictionary dictionaryWithDictionary:[dataDic objectForKey:@"xianshi_info"]];
            }
            
            if ([[dataDic objectForKey:@"dazhe_info"] isKindOfClass:[NSDictionary class]]) {
                _dazheInfoDict = [NSDictionary dictionaryWithDictionary:[dataDic objectForKey:@"dazhe_info"]];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            [self addEmpty];
        }
        
    }];
   
}

- (void)addEmpty
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    imageView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:imageView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (indexPath.row == 0)
    {
        LHShopDetailViewCell* shopCell = [tableView dequeueReusableCellWithIdentifier:@"lhShopDetailCell" forIndexPath:indexPath];
        shopCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.dataSource.count > 0)
        {
            LHGoodsDetailModel* model = self.dataSource[0];
            
            if (_promotion_price&&_promotion_price.length != 0)
            {
                shopCell.priceLabel.text = [NSString stringWithFormat:@"￥%@",_promotion_price];
            }
            else
            {
                shopCell.priceLabel.text = [NSString stringWithFormat:@"会员价:￥%@",model.goods_price];
            }
            
            shopCell.priceLabel.tag = 54321;
            shopCell.discountLabel.text = _goods_discount;
            shopCell.oldLabel.text = [NSString stringWithFormat:@"原价:%@元",model.goods_marketprice];
            shopCell.numberLabel.text = [NSString stringWithFormat:@"已售 %@份",model.goods_salenum];
            shopCell.discountLabel.text = [NSString stringWithFormat:@"%@折",_goods_discount];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 79, SCREEN_WIDTH-15, 1)];
            lineImageView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
            [shopCell addSubview:lineImageView];
            
        }
        return shopCell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"actCell"];
        
        if (_xianshiInfoDict && _xianshiInfoDict.count > 1)
        {
            
            UILabel *actLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
            actLabel.text = @"活动信息:";
            actLabel.font = [UIFont systemFontOfSize:Text_Big];
            [cell.contentView addSubview:actLabel];
            
            
            UILabel *actDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, SCREEN_WIDTH-100, 30)];
            actDesLabel.numberOfLines = 0;
            actDesLabel.lineBreakMode = NSLineBreakByWordWrapping;
            float price = [_xianshiInfoDict[@"goods_price"] floatValue] - [_xianshiInfoDict[@"xianshi_price"] floatValue];
            actDesLabel.font = [UIFont systemFontOfSize:Text_Normal];
            actDesLabel.text = [NSString stringWithFormat:@"%@直降￥%.2f 最低%@件起",_xianshiInfoDict[@"xianshi_explain"], price,_xianshiInfoDict[@"lower_limit"]];
            actDesLabel.textColor = [UIColor orangeColor];
            [cell.contentView addSubview:actDesLabel];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, SCREEN_WIDTH-100,30)];
            timeLabel.text = [NSString stringWithFormat:@"活动时间：%@~%@",_xianshiInfoDict[@"start_time"],_xianshiInfoDict[@"end_time"]];
            timeLabel.textColor = [UIColor orangeColor];
            timeLabel.font = [UIFont systemFontOfSize:Text_Normal];
            timeLabel.numberOfLines = 0;
            timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.contentView addSubview:timeLabel];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 89, SCREEN_WIDTH-15, 1)];
            lineImageView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
            [cell.contentView addSubview:lineImageView];
            
        }
        if (_dazheInfoDict && _dazheInfoDict.count > 1)
        {
            UILabel *actLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
            actLabel.text = @"活动信息:";
            actLabel.font = [UIFont systemFontOfSize:Text_Big];
            [cell.contentView addSubview:actLabel];
            
            
            UILabel *actDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, SCREEN_WIDTH-100, 20)];
            actDesLabel.numberOfLines = 0;
            actDesLabel.lineBreakMode = NSLineBreakByWordWrapping;
            float price = [_dazheInfoDict[@"goods_price"] floatValue] - [_dazheInfoDict[@"dazhe_price"] floatValue];
            actDesLabel.font = [UIFont systemFontOfSize:Text_Normal];
            actDesLabel.text = [NSString stringWithFormat:@"%@直降￥%.2f 最低%@件起 %@",_dazheInfoDict[@"dazhe_name"], price,_dazheInfoDict[@"lower_limit"],_dazheInfoDict[@"dazhe_explain"]];
            actDesLabel.textColor = [UIColor orangeColor];
            [cell.contentView addSubview:actDesLabel];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 39, SCREEN_WIDTH-15, 1)];
            lineImageView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
            [cell.contentView addSubview:lineImageView];
            
        }
        
        return cell;
    }
    else
    {

        LHShopDetail2TableViewCell *cell = [LHShopDetail2TableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row>1 && indexPath.row<5)
        {
            cell.titleLabel.text = _array[indexPath.row-2];
            
            if (indexPath.row == 2 || indexPath.row == 4)
            {
                cell.pingjiaImage.hidden = YES;
                cell.intoLabel.hidden = YES;

                cell.reduceImage.hidden = YES;
                cell.numberLabel.hidden = YES;
                cell.fengshuLabel.hidden = YES;
                cell.tuImage.hidden = NO;
                if (cell.titleLabel.hidden == YES)
                {
                    cell.titleLabel.hidden = NO;
                }
                
                if (indexPath.row == 2)
                {
                    if (_specLabel!=nil) {
                        [_specLabel removeFromSuperview];
                    }
                    _specLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, SCREEN_WIDTH-200, 30)];
                    _specLabel.font = [UIFont systemFontOfSize:Text_Normal];
                    [cell addSubview:_specLabel];
                    if(_goodsInfoDict[@"spec_self"])
                    {
                        _specLabel.text = _goodsInfoDict[@"spec_self"];
                    }
                    
                }
                
                cell.tuImage.image = [UIImage imageNamed:@"30-40.png"];
            }
            
            if (indexPath.row == 3)
            {
                cell.pingjiaImage.hidden = YES;
              //  _tuImage = [[LHImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 15, 15,20)];
                cell.tuImage.image = [UIImage imageNamed:@"+on"];
                cell.tuImage.frame = CGRectMake(SCREEN_WIDTH-50, 12, 25,25);
                cell.intoLabel.hidden = YES;
                cell.tuImage.hidden = NO;
                [cell.contentView addSubview:cell.reduceImage];
                if (cell.reduceImage.hidden == YES)
                {
                    cell.reduceImage.hidden = NO;
                }
                if (cell.numberLabel.hidden == YES)
                {
                    cell.numberLabel.hidden = NO;
                }
                cell.titleLabel.hidden = NO;
                cell.reduceImage.image = [UIImage imageNamed:@"-off"];
                [cell.tuImage addTarget:self action:@selector(add:)];
                [cell.reduceImage addTarget:self action:@selector(reduce:)];
                cell.numberLabel.text = @"1";
                cell.numberLabel.tag = 11;
            }
            
        }
        if (indexPath.row == 5)
        {
            cell.pingjiaImage.hidden = YES;

            cell.reduceImage.hidden = YES;
            cell.tuImage.image = [UIImage imageNamed:@"30-40.png"];
            cell.numberLabel.hidden = YES;
            cell.fengshuLabel.hidden = YES;
            
            cell.intoLabel.hidden = NO;
            if (self.dataSource.count > 0)
            {
                LHGoodsDetailModel* model = self.dataSource[0];
                cell.titleLabel.text = model.store_name;
            }
        }
        if (indexPath.row == 6)
        {
            cell.titleLabel.hidden = YES;

            cell.pingjiaImage.hidden = NO;
            cell.tuImage.image = [UIImage imageNamed:@"30-40.png"];
            cell.fengshuLabel.hidden = NO;
            if (self.dataSource.count > 0)
            {
                LHGoodsDetailModel* model = self.dataSource[0];
                cell.fengshuLabel.text = [NSString stringWithFormat:@"%@分",model.evaluation_good_star];
                cell.intoLabel.text = [NSString stringWithFormat:@"%@评价",model.evaluation_count];
                cell.intoLabel.textAlignment = NSTextAlignmentRight;
                
                [cell.pingjiaImage setStar:[model.evaluation_good_star floatValue]];
                
            }
        }
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 49, SCREEN_WIDTH-15, 1)];
        lineImageView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [cell.contentView addSubview:lineImageView];
        
        
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2)
    {
        //选择商品分类
        
        if ([_goodsInfoDict[@"spec"] isKindOfClass:[NSArray class]])
        {
            [self createSpecView];
        }
        else
        {
            [MBProgressHUD showError:@"没有规格可供选择" toView:self.view];
        }
    }
    else if (indexPath.row == 4)
    {
        LHGoodsJSViewController* vc = [[LHGoodsJSViewController alloc] init];
        vc.goods_id =  self.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 5)
    {
        SuShopDetailViewController* vc = [[SuShopDetailViewController alloc] init];
        LHGoodsDetailModel* model = self.dataSource[0];
        vc.store_id = model.store_id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 6)
    {
        LHGoodsDetailModel* model = self.dataSource[0];
        
        if ([model.evaluation_count isEqualToString:@"0"])
        {
            [MBProgressHUD showError:@"暂无评论"];
            return;
        }
        
        ShangpinEvaluationViewController *vc = [[ShangpinEvaluationViewController alloc] init];
        vc.good_id = self.goods_id;
        vc.count = model.evaluation_count;
        vc.star_score = model.evaluation_good_star;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)add:(UITapGestureRecognizer*)tap
{
    UILabel* label = (UILabel*)[self.view viewWithTag:11];
    int number = [label.text intValue];
    number += 1;
    
    if (number > [_goodsInfoDict[@"goods_storage"] integerValue])
    {
        [MBProgressHUD showError:@"库存不足"];
        _number = label.text;
    }
    else
    {
        label.text = [NSString stringWithFormat:@"%d",number];
        _number = label.text;
    }
    
}

- (void)reduce:(UITapGestureRecognizer*)tap
{
    UILabel* label = (UILabel*)[self.view viewWithTag:11];
    int number = [label.text intValue];
    if (number > 1) {
        number -= 1;
    }
    label.text = [NSString stringWithFormat:@"%d",number];
    _number = label.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    else if (indexPath.row == 1)
    {
        if (_xianshiInfoDict && _xianshiInfoDict.count > 1)
        {
            return 90;
        }
        else if (_dazheInfoDict && _dazheInfoDict.count > 1)
        {
            return 40;
        }
        else
            return 0.1;
    }
    else
    {
        return 50;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)createPriceAndCountLabelPrice:(NSString *)price Count:(NSString *)count
{
    if (priceLabel != nil)
    {
        [priceLabel  removeFromSuperview];
    }
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 20)];
    priceLabel.textColor = [UIColor orangeColor];
    
    priceLabel.text = [NSString stringWithFormat:@"会员价:￥%@",price];
    [_specView addSubview:priceLabel];
    
    if (countLabel != nil) {
        [countLabel removeFromSuperview];
    }
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 200, 20)];
    countLabel.text = [NSString stringWithFormat:@"剩余 %@份",count];
    [_specView addSubview:countLabel];

}

- (void)createSpecView
{
    [self setupGrayView];
    NSArray *specArr = _goodsInfoDict[@"spec"];
    
    _specView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-64)/2, SCREEN_WIDTH,(SCREEN_HEIGHT-64)/2-49)];
    _specView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(SCREEN_WIDTH-30, 10, 20, 20);
    [cancelButton setImage:[UIImage imageNamed:@"quan"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_specView addSubview:cancelButton];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"spec_image"]] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    
    [_specView addSubview:iconImageView];
    LHGoodsDetailModel* model = self.dataSource[0];
    [self createPriceAndCountLabelPrice:model.goods_price Count:model.goods_salenum];
    
    float btnWidth = SCREEN_WIDTH/specArr.count;
    for (int i = 0;i < specArr.count;i ++)
    {
        NSDictionary *dic = specArr[i];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100+100*i, 100, 20)];
        nameLabel.text = [NSString stringWithFormat:@"%@:",dic[@"spec_name"]];
        [_specView addSubview:nameLabel];
        
        NSArray *valueArr = dic[@"value"];
        for (int  j = 0; j < valueArr.count; j ++)
        {
            NSDictionary *valueDic = valueArr[j];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20+btnWidth*j, CGRectGetMaxY(nameLabel.frame)+20, btnWidth-30, 40);
            
            UIImageView *lineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, 0.5, CGRectGetHeight(button.frame))];
            UIImageView *lineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, CGRectGetWidth(button.frame), 0.5)];
            UIImageView *lineImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame), CGRectGetWidth(button.frame), 0.5)];
            UIImageView *lineImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), button.frame.origin.y,0.5 , CGRectGetHeight(button.frame))];
            lineImageView1.backgroundColor = [UIColor grayColor];
            lineImageView2.backgroundColor = [UIColor grayColor];
            lineImageView3.backgroundColor = [UIColor grayColor];
            lineImageView4.backgroundColor = [UIColor grayColor];
            
            NSString *btnTitle = valueDic[@"value"];
            [button setTitle:btnTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0.0 green:131/255.0 blue:131/255.0 alpha:1.0]  forState:UIControlStateNormal];
            button.tag = (i+1)*10000+[valueDic[@"id"] integerValue];
            if (_specValueIDArr.count > 0)
            {
                NSLog(@"%@",_specValueIDArr);
                
                for(NSString *valueID in _specValueIDArr)
                {
                    if (button.tag%10000 == [valueID integerValue])
                    {
                        button.selected = YES;
                        button.backgroundColor = [UIColor colorWithRed:236/255.0 green:88/255.0 blue:94/255.0 alpha:1.0];
                    }
                }
            }
            else
            {
                if (j  == 0)
                {
                    button.selected = YES;
                    button.backgroundColor = [UIColor colorWithRed:236/255.0 green:88/255.0 blue:94/255.0 alpha:1.0];
                }
                
            }
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_specView addSubview:button];
            [_specView addSubview:lineImageView1];
            [_specView addSubview:lineImageView2];
            [_specView addSubview:lineImageView3];
            [_specView addSubview:lineImageView4];
        }
    }
    
    [_specView setContentSize:CGSizeMake(SCREEN_WIDTH, specArr.count*100+200)];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(SCREEN_WIDTH/2-40, specArr.count*100+120, 80, 30);
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_specView addSubview:sureBtn];
    
    [self.view addSubview:_specView];
}

- (void)cancelAction
{
    [self removeSpecView];
}

- (void)buttonClicked:(UIButton *)sender
{
    int i = sender.tag/10000;
    for (UIView *subView in _specView.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)subView;
            
            if (i == button.tag/10000)
            {
                button.backgroundColor = [UIColor clearColor];
                button.selected = NO;
            }
        }
       
    }
    
    sender.backgroundColor = [UIColor colorWithRed:236/255.0 green:88/255.0 blue:94/255.0 alpha:1.0];
    sender.selected = YES;
    
    
    _specValueIDArr = [[NSMutableArray alloc] init];
    
    for (UIView *subView in _specView.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)subView;
            if (button.selected == YES)
            {
                [_specValueIDArr addObject:[NSString stringWithFormat:@"%d",button.tag%10000]];
            }
        }
    }
    
    NSLog(@"%@",_specValueIDArr);
    
    NSArray *goodListArr = _dataDict[@"goods_list"];
    for (int j = 0; j < goodListArr.count; j ++)
    {
        
        NSDictionary *goodListDict = goodListArr[j];
        
        NSArray *valueArr = goodListDict[@"value"];
        
        if ([self compareArr1:_specValueIDArr Arr2:valueArr])
        {
            
            [self createPriceAndCountLabelPrice:goodListDict[@"goods_price"] Count:goodListDict[@"goods_storage"]];
            
            NSLog(@"%@--%@",goodListDict[@"goods_price"],goodListDict[@"goods_storage"]);
            
            _priceLabel.text = [NSString stringWithFormat:@"合计:%@",goodListDict[@"goods_price"]];
            _countLabel.text = [NSString stringWithFormat:@"剩余:%@",goodListDict[@"goods_storage"]];
        }
    }
}

//比较两个数组
- (BOOL)compareArr1:(NSArray *)arr1 Arr2:(NSArray *)arr2
{
    if (arr1.count == arr2.count)
    {
        int  i = 0;
        for (i= 0;i < arr1.count; i ++)
        {
            if ([arr2 indexOfObject:arr1[i]] != NSNotFound)
            {
            }
            else
            {
                break;
            }
        }
        if (i == arr1.count)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (void)sureBtnAction:(UIButton *)button
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    for (UIView *subView in _specView.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)subView;
            
            if (button.selected)
            {
                int i = button.tag/10000;
                NSArray *specArr = _goodsInfoDict[@"spec"];
                NSDictionary *dic = specArr[i-1];
                NSString *string = dic[@"spec_name"];
                [mutableString appendFormat:@"%@:%@  ",string,button.titleLabel.text];
            }
        }
    }
    _specLabel.text = @"";
    _specLabel.text = mutableString;
    
    NSArray *goodListArr = _dataDict[@"goods_list"];
    for (int j = 0; j < goodListArr.count; j ++)
    {
        
        NSDictionary *goodListDict = goodListArr[j];
        
        NSArray *valueArr = goodListDict[@"value"];
        
        if ([self compareArr1:_specValueIDArr Arr2:valueArr])
        {
            UILabel *label = (UILabel *)[self.view viewWithTag:54321];
            label.text = goodListDict[@"goods_price"];
            self.specGoodsID = [NSString stringWithFormat:@"%@",goodListDict[@"goods_id"]];
        }
    }
    
    [self removeSpecView];
}

- (void)setupGrayView
{
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - _sortView.frame.size.height - 64)];
    _grayView.backgroundColor = [UIColor blackColor];
    _grayView.alpha = 0.5;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSpecView)];
    [_grayView addGestureRecognizer:tapGes];
    [self.view addSubview:_grayView];
    
}

- (void)removeSpecView
{
    [_grayView removeFromSuperview];
    CGFloat hight = _specView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _specView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, hight);
    }];
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

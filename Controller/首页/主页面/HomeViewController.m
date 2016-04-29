//
//  HomeViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "FiveCell.h"
#import "FourCell.h"
#import "ThreeCell.h"
#import "TowCell.h"
#import "OneCell.h"
#import "SixCell.h"
#import "KDCycleBannerView.h"
#import "NewsViewController.h"
#import "GodsViewController.h"
#import "ActViewController.h"
#import "SuShopViewController.h"
#import "LHFirstPageModel.h"
#import "LHRecommendViewController.h"
#import "GodsDesViewController.h"
#import "LHGodsDetailViewController.h"
#import "ActStreetViewController.h"
#import "SuShopDetailViewController.h"
#import "ActShopViewController.h"
#import "MJRefresh.h"
#import "ChoiceShopViewController.h"
#import "RecommendViewController.h"
#import "SuGoodsViewController.h"
#import "UIImageView+WebCache.h"
#import "HJCountdownView.h"
#import "LSPaoMaView.h"
#import "SweepViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, KDCycleBannerViewDataource, KDCycleBannerViewDelegate>
{
    UITableView *_tableView;
    //推荐商品数组
    NSMutableArray *_tableSource;

    //活动字
    NSMutableArray *_actmodeArray;
    //活动
    NSMutableArray *_specialActArray;
    NSMutableArray *_actArray;
    NSMutableArray *_newsArray;
    //新闻数组
    NSMutableArray* _pbannersArray;
    //活动街
    NSMutableArray *_streetArray;
    //商店
    NSMutableArray *_storeArray;
    //推荐
    NSMutableArray *_goodsArray;
    
    LHFirstPageModel* _model;
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    int currentPage;
    NSNumber *_actTime;
    
    
    
}

@property(nonatomic,strong) KDCycleBannerView *showBanner;
@property(nonatomic,strong) NSMutableArray *bannerImages;
@property(nonatomic,strong) NSString *endAction;

@property (nonatomic,strong) KDCycleBannerView *showNewsBanner;
@property (nonatomic,strong) NSMutableArray *newsBannerImages;


@end

@implementation HomeViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.bannerImages removeAllObjects];
    [self.newsBannerImages removeAllObjects];
    
    [self loadBannerImages];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)loadBannerImages
{
    for (int i = 0; i < self.dataSource.count; i++)
    {
        LHFirstPageModel* model = (LHFirstPageModel *)self.dataSource[i];
        if (model.img)
        {
            [self.bannerImages addObject:model.img];
        }
        
    }
}

- (void)loadNewsBannerImages
{
    for (int i = 0; i < _pbannersArray.count; i++)
    {
        LHFirstPageModel* model = (LHFirstPageModel *)_pbannersArray[i];
        if (model.img)
        {
            [self.newsBannerImages addObject:model.img];
        }
    }
}

- (NSMutableArray *)bannerImages
{
    if (!_bannerImages)
    {
        _bannerImages = [[NSMutableArray alloc]init];
    }
    
    return _bannerImages;
}

- (NSMutableArray *)newsBannerImages
{
    if (!_newsBannerImages)
    {
        _newsBannerImages = [[NSMutableArray alloc] init];
    }
    return _newsBannerImages;
}

- (void)viewDidAppear:(BOOL)animated
{
    // 获取通知中心 向通知中心注册一个观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(codeError) name:@"codeError" object:nil];
}

- (void)codeError
{
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"二维码不正确，请重试";
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableSource = [[NSMutableArray alloc] init];
    _newsArray = [NSMutableArray array];
    _goodsArray = [NSMutableArray array];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    currentPage = 1;
    
    /** 1.创建导航栏*/
    [self createNavgation];
    /** 2.创建表格*/
    [self createTableView];
    /** 3.请求数据*/
    [self request];
    
    [self setRefresh];
    
    
}

- (void)setRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}

- (void)headerRefresh
{
    [self.dataSource removeAllObjects];
    [self.bannerImages removeAllObjects];
    
    isHeadReshing = YES;
    [self request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
    });
}


- (void)footerRefresh
{
    
    [self.dataSource removeAllObjects];
    [self.bannerImages removeAllObjects];
    isFooterReshing = YES;
    [self request];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
    });
    
}


/** 1.创建导航栏*/
- (void)createNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"red.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    label.text  = @"百购宿州";
    label.textColor = [UIColor whiteColor];                                                                                                                                                                                                          
    label.font = [UIFont systemFontOfSize:19];
    [navView addSubview:label];
    
    /** 导航栏上的搜索按钮*/
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.layer.cornerRadius = 10.0;
    [searchBtn setBackgroundColor:[UIColor whiteColor]];
    
    [searchBtn setImage:[UIImage imageNamed:@"search2@2x"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"search2@2x"] forState:UIControlStateHighlighted];
    
    searchBtn.frame = CGRectMake(85, 5, SCREEN_WIDTH-160, 30);
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.cornerRadius = 15;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.selected = NO;
    [navView addSubview:searchBtn];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:navView];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    [rightButton setImage:[UIImage imageNamed:@"sao.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"sao.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(sweepAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/** 二维码扫描*/
- (void)sweepAction
{
    SweepViewController *vc = [[SweepViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 搜索点击事件*/
- (void)searchBtnAction
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/** 2.创建表格*/
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[FiveCell class] forCellReuseIdentifier:@"fiveCell"];
    [_tableView registerClass:[FourCell class] forCellReuseIdentifier:@"fourCell"];
    [_tableView registerClass:[ThreeCell class] forCellReuseIdentifier:@"threeCell"];
    [_tableView registerClass:[TowCell class] forCellReuseIdentifier:@"twoCell"];
    [_tableView registerClass:[OneCell class] forCellReuseIdentifier:@"oneCell"];
    [_tableView registerClass:[SixCell class] forCellReuseIdentifier:@"sixCell"];
    [self.view addSubview:_tableView];
}

#pragma mark- 网络请求
/** 3.请求数据*/
- (void)request
{
     if(isFooterReshing)
    {
        currentPage ++;
        isFooterReshing = NO;
    }
    else if(isHeadReshing)
    {
        [_tableSource removeAllObjects];
        [_specialActArray removeAllObjects];
        [_actArray removeAllObjects];
        [_newsArray removeAllObjects];
        [_pbannersArray removeAllObjects];
        [_streetArray removeAllObjects];
        [_storeArray removeAllObjects];
        [_goodsArray removeAllObjects];
        
        
        currentPage = 1;
        isHeadReshing  = YES;
    }
    else
    {
        
    }
    
    NSString * url = [NSString stringWithFormat:@"%@?curpage=%d",SHOUYE_URL,currentPage];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self cacheWithUrl:url target:self action:@selector(analyze:)];
    
}

- (void)analyze:(NSData*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary* datasDic = dic[@"data"];
    
    if ([[datasDic objectForKey:@"goods"] isKindOfClass:[NSNull class]])
    {
        [MBProgressHUD showError:@"无更多商品"];
    }
    else
    {
        NSArray *arr = (NSArray *)datasDic[@"goods"];
        if (arr.count < 1)
        {
            [MBProgressHUD showError:@"无更多商品"];
        }
        else
        {
            //解析轮播
            NSArray* pbannersArray = datasDic[@"gbanners"];
            for (NSDictionary* appDic in pbannersArray)
            {
                LHFirstPageModel* model = [[LHFirstPageModel alloc] init];
                [model setValuesForKeysWithDictionary:appDic];
                //用父类的属性    其他数据不能再存放在这个数组里
                [self.dataSource addObject:model];
            }
            [_tableSource addObject:self.dataSource];
            [self loadBannerImages];
            
            //活动字
            _actmodeArray = [NSMutableArray array];
            
            _actmodeArray = datasDic[@"actmode"];
            
            
            
            //特殊活动
            _specialActArray = [NSMutableArray array];
            
            if ([datasDic[@"special_act"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary* appDic = datasDic[@"special_act"];
                LHFirstPageModel* model1 = [[LHFirstPageModel alloc] init];
                [model1 setValuesForKeysWithDictionary:appDic];
                [_specialActArray addObject:model1];
                _actTime = appDic[@"activity_date"];
            }
            else
            {
                _endAction = datasDic[@"special_act"];
            }
            
            //活动
            _actArray = [NSMutableArray array];
            NSArray* actsArray = datasDic[@"acts"];
            for (NSDictionary* actsDic in actsArray) {
                LHFirstPageModel* model = [[LHFirstPageModel alloc] init];
                [model setValuesForKeysWithDictionary:actsDic];
                [_actArray addObject:model];
            }
            
            //新闻
            _newsArray = [NSMutableArray array];
            NSArray *newsArr = datasDic[@"news"];
            for (NSDictionary *newsDic in newsArr)
            {
                LHFirstPageModel *model = [[LHFirstPageModel alloc] init];
                [model setValuesForKeysWithDictionary:newsDic];
                [_newsArray addObject:model];
            }
            
            //解析新闻头条
            NSArray* pbannersArr = datasDic[@"pbanners"];
            _pbannersArray = [NSMutableArray array];
            for (NSDictionary* pbannersDic in pbannersArr) {
                LHFirstPageModel* model = [[LHFirstPageModel alloc] init];
                [model setValuesForKeysWithDictionary:pbannersDic];
                [_pbannersArray addObject:model];
            }
            [self loadNewsBannerImages];
            
            //解析活动街
            NSDictionary* streetDic = datasDic[@"street"];
            _streetArray = [NSMutableArray array];
            LHFirstPageModel* model = [[LHFirstPageModel alloc] init];
            [model setValuesForKeysWithDictionary:streetDic];
            [_streetArray addObject:model];
            
            //解析每日好店
            NSArray* storesArr = datasDic[@"stores"];
            _storeArray = [NSMutableArray array];
            for (NSDictionary* storesDic in storesArr) {
                LHFirstPageModel* model = [[LHFirstPageModel alloc] init];
                [model setValuesForKeysWithDictionary:storesDic];
                [_storeArray addObject:model];
            }
            
            //解析推荐商品
            NSArray* goodsArray = datasDic[@"goods"];
            for (NSDictionary* appDic in goodsArray) {
                LHFirstPageModel* model = [[LHFirstPageModel alloc] init];
                [model setValuesForKeysWithDictionary:appDic];
                [_goodsArray addObject:model];
            }
            //        [self createTableView];
            
        }
        [_tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 4)
    {
        return (_storeArray.count+1)/2;
    }
    else if(section == 5)
    {
        return _goodsArray.count/2;
    }
    else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        OneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //第一个Cell的四个按钮的设置
        NSArray *imageNames = @[@"icon11",@"icon22",@"icon33",@"icon44"];
        
        
        for (int i = 0; i < 4; i ++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((SCREEN_WIDTH-240)/5*(i+1)+60*i,15,60,60);
            btn.layer.cornerRadius = 30;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageNames[i]]] forState:UIControlStateNormal];
            btn.tag = 11000+i;
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            
            
            
        }
     
        return cell;
        
    }
    else if (indexPath.section == 1)
    {
        
        TowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *backView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        [cell.contentView addSubview:backView];

        HJCountdownView * countDown =[[NSBundle mainBundle] loadNibNamed:@"HJCountdownView" owner:self options:nil][0];
        
        NSNumber *time = nil;
        if (_actTime!=nil && [_actTime integerValue]!= 0)
        {
            time = _actTime;
        }
        else
        {
            time = [NSNumber numberWithInteger:0];
            cell.actionView.image = [UIImage imageNamed:@"waitfor.png"];
            
        }
        
        [countDown setLeaveTime:time];
        
        countDown.frame=CGRectMake(5, CGRectGetMaxY(cell.actionTitle.frame)-2, 82, 24);
        [cell.view1 addSubview:countDown];
        
        if (_specialActArray.count > 0)
        {
            LHFirstPageModel *model1 = [_specialActArray firstObject];
            cell.actionTitle.text = model1.title;
            
            
            [cell.actionView sd_setImageWithURL:[NSURL URLWithString:model1.img] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
            
            //特殊活动显示
            UITapGestureRecognizer *view1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view1Clicked)];
            [cell.view1 addGestureRecognizer:view1Tap];
        }
        else
        {
            cell.actionTitle.text = @"暂无活动";
        }
        
        //活动字
        cell.actmodeArray = _actmodeArray;
        NSLog(@"%@",_actmodeArray);
        
        
       //活动1
        cell.actArray = _actArray;
        UITapGestureRecognizer *view2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view2Clicked:)];
        [cell.view2 addGestureRecognizer:view2Tap];
        UIView *tagView2 = [view2Tap view];
        tagView2.tag = 100;
        
        //活动2
        UITapGestureRecognizer *view3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view2Clicked:)];
        [cell.view3 addGestureRecognizer:view3Tap];
        UIView *tagView3 = [view3Tap view];
        tagView3.tag = 101;
        
        //活动3
        UITapGestureRecognizer *view4Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view2Clicked:)];
        [cell.view4 addGestureRecognizer:view4Tap];
        UIView *tagView4 = [view4Tap view];
        tagView4.tag = 102;
        
        //新闻显示
        UITapGestureRecognizer *view5Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view5Clicked)];
        [cell.backView addGestureRecognizer:view5Tap];
//        cell.newsArray = _newsArray;
        
        
        
        NSMutableString *newsString = [[NSMutableString alloc] init];
        
        for ( int i = 0; i < _newsArray.count;i ++)
        {
            LHFirstPageModel *model = _newsArray[i];
            NSString *str = model.news_title;
            [newsString appendString:str];
            for (int i = 0; i < 50;i ++)
            {
                    
                [newsString appendString:@" "];
                    
            }
        }
        NSLog(@"%@~~~%d",newsString,newsString.length);
        
        if (newsString.length > 0)
        {
            LSPaoMaView *paoView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.4, 0, SCREEN_WIDTH*0.6-10, 50) title:newsString];
            
            [paoView start];
            
            [cell.view5 addSubview:paoView];
        }
        
        return cell;
        
    }
    else if (indexPath.section == 2)
    {
        
        SixCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sixCell" forIndexPath:indexPath];
        
        return cell;
    }
    else if (indexPath.section == 3)
    {
        //活动街
        ThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        LHFirstPageModel *model = [_streetArray firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_tableSource.count>0) {
            [cell.adImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"411-152.png"]];
        }
        
        return cell;
    } else if (indexPath.section ==  4) {
        
        //每日好店
        FourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSLog(@"%@",_storeArray);
        
        LHFirstPageModel *model1 = _storeArray[indexPath.row*2];
        [cell.pic1 sd_setImageWithURL:[NSURL URLWithString:model1.store_cover] placeholderImage:[UIImage imageNamed:@"192-112.png"]];
        cell.titleLabel1.text = model1.store_name;
        
        
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeClick:)];
        [cell.myView1 addGestureRecognizer:tap1];
        UIView *tagView1 = [tap1 view];
        tagView1.tag = 101+indexPath.row*2;
        
        if (_storeArray.count%2== 0) {
            LHFirstPageModel *model2 = _storeArray[indexPath.row*2+1];
            [cell.pic2 sd_setImageWithURL:[NSURL URLWithString:model2.store_cover] placeholderImage:[UIImage imageNamed:@"192-112.png"]];
            cell.titleLabel2.text = model2.store_name;
            
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeClick:)];
            [cell.myView2 addGestureRecognizer:tap2];
            UIView *tagView2 = [tap2 view];
            tagView2.tag = 101+indexPath.row*2+1;
        }
        else
        {
            if(indexPath.row == (_storeArray.count-1)/2)
            {
                [cell.myView2 removeFromSuperview];
            }
            else
            {
                LHFirstPageModel *model2 = _storeArray[indexPath.row*2+1];
                [cell.pic2 sd_setImageWithURL:[NSURL URLWithString:model2.store_cover]placeholderImage:[UIImage imageNamed:@"192-112.png"]];
                cell.titleLabel2.text = model2.store_name;
                
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeClick:)];
                [cell.myView2 addGestureRecognizer:tap2];
                UIView *tagView2 = [tap2 view];
                tagView2.tag = 101+indexPath.row*2+1;
            }
            
        }
        return cell;
        
    } else {
        
    //推荐商品
        
        FiveCell *cell = (FiveCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[FiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fiveCell"];
        }
        
//        FiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fiveCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        LHFirstPageModel *model1 = _goodsArray[indexPath.row*2];
        [cell.pic1 sd_setImageWithURL:[NSURL URLWithString:model1.goods_image]placeholderImage:[UIImage imageNamed:@"192-192.png"]];
        
        cell.titleLabel1.text = model1.goods_name;
        cell.priceLabel1.text = [NSString stringWithFormat:@"￥%@",model1.goods_price];
        
        LHFirstPageModel *model2 = _goodsArray[indexPath.row*2+1];
        
        [cell.pic2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model2.goods_image]]  placeholderImage:[UIImage imageNamed:@"192-192.png"]];
        //[cell.pic2 setImageWithURL:[NSURL URLWithString:model2.goods_image]];
        
        cell.titleLabel2.text = model2.goods_name;
        cell.priceLabel2.text =[NSString stringWithFormat:@"￥%@",model2.goods_price];
        
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goosClick:)];
        [cell.myView1 addGestureRecognizer:tap1];
        UIView *tagView1 = [tap1 view];
        tagView1.tag = 201+indexPath.row*2;
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goosClick:)];
        [cell.myView2 addGestureRecognizer:tap2];
        UIView *tagView2 = [tap2 view];
        tagView2.tag = 202+indexPath.row*2;
        
        return cell;
    }
}


//第一个cell的按钮触发的方法
- (void)buttonClick:(UIButton *)sender
{
    //根据按钮的tag值来判断是那个按钮 从而获取到进入下一个页面所需的数据
    long i = sender.tag - 11000;
    if (i == 0)
    {
        //进入商品页面
        SuGoodsViewController *vc = [[SuGoodsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (i == 1)
    {
        //进入商户页面
        SushopViewController *vc = [[SushopViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (i == 2)
    {
        //进入活动页面
        ActViewController *vc = [[ActViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else
    {
        //进入精选商户
        ChoiceShopViewController *vc = [[ChoiceShopViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}


//第二个cell的触发方法
- (void)view1Clicked {
    LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
     LHFirstPageModel *model1 = [_specialActArray firstObject];
    vc.goods_id = model1.goods_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:NO];
}
//3个活动点击
- (void)view2Clicked:(UITapGestureRecognizer *)sender
{
        
    ActShopViewController *vc = [[ActShopViewController alloc] init];

    int num = [sender view].tag - 100;
    if (num == 0)
    {
        LHFirstPageModel *model = _actArray[0];
        vc.myId = model.id;
        vc.titleStr = model.title;
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else if (num == 1)
    {
        LHFirstPageModel *model = _actArray[1];
        vc.myId = model.id;
        vc.titleStr = model.title;
        [self.navigationController pushViewController:vc animated:NO];
   
    }
    else
    {
        LHFirstPageModel *model = _actArray[2];
        vc.myId = model.id;
        vc.titleStr = model.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)view5Clicked
{
    
    NewsViewController *vc = [[NewsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

//第三个cell的触发方法
- (void)streetClick:(UIButton *)button
{
    GodsDesViewController *vc = [[GodsDesViewController alloc] init];
    vc.myId = [NSString stringWithFormat:@"%d",button.tag-987654];
    vc.title = @"广告详情";
    [self.navigationController pushViewController:vc animated:YES];
}

//每日好店点击
- (void)storeClick:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    SuShopDetailViewController *vc = [[SuShopDetailViewController alloc] init];
    int num = [tap view].tag - 101;
    LHFirstPageModel *storeModel = _storeArray[num];
    vc.store_id = storeModel.store_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

//推荐商品
- (void)goosClick:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
    int num = [tap view].tag - 201;
    LHFirstPageModel *godsModel = _goodsArray[num];
    vc.goods_id = godsModel.goods_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 3) {
        
        ActStreetViewController *vc = [[ActStreetViewController alloc] init];
        LHFirstPageModel *model = [_streetArray firstObject];
        vc.myId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//自定义的Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }
    else if(indexPath.section == 1)
    {
//        return 256;
        return  30+20+ KScr_W*0.3-20+5+60+45+10;
    }
    else if (indexPath.section == 2)
    {
        return 0.1;
    }
    else if (indexPath.section == 3)
    {
        return SCREEN_WIDTH/6*2.2;
    }
    else if (indexPath.section ==4)
    {
        return (SCREEN_WIDTH/2-30)/12 * 7+30+10;
    }
    else
    {
        return KScr_W/2 + 30;
    }
}


#pragma mark - 表格头的代理
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        CGFloat height = SCREEN_WIDTH * 0.45;
        
        _showBanner = [[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _showBanner.tag = 19875;
        _showBanner.delegate = self;
        _showBanner.datasource = self;
        
        _showBanner.continuous = YES;
        _showBanner.autoPlayTimeInterval = 3.0;
        
        return _showBanner;

    }
    else if (section == 1)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        return headerView;
        
    }
    else if (section == 2)
    {
        //新闻轮播试图
        CGFloat height = SCREEN_WIDTH/5*4/3;
        
        _showNewsBanner = [[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _showNewsBanner.tag = 19876;
        _showNewsBanner.delegate = self;
        _showNewsBanner.datasource = self;
        
        _showNewsBanner.continuous = YES;
        _showNewsBanner.autoPlayTimeInterval = 3.0;
        
        return _showNewsBanner;
        
    }
    else if (section == 3)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(headerView.frame))];
        view.backgroundColor = [UIColor redColor];
        [headerView addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        titleLabel.text = @"活动街";
        [headerView addSubview:titleLabel];
        return headerView;
        
    }
    else if (section == 4)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(headerView.frame))];
        view.backgroundColor = [UIColor blueColor];
        [headerView addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        titleLabel.text = @"每日好店";
        [headerView addSubview:titleLabel];
        return headerView;
    }
    else
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(headerView.frame))];
        view.backgroundColor = [UIColor yellowColor];
        [headerView addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        titleLabel.text = @"推荐商品";
        [headerView addSubview:titleLabel];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 80, 40)];
        [button addTarget:self action:@selector(godsMoreBtn) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 80, 40)];
        label.text = @"更多";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)-30, 10, 15, 20)];
        [imageView setImage:[UIImage imageNamed:@"30-40"]];
        
        [headerView addSubview:button];
        [headerView addSubview:label];
        [headerView addSubview:imageView];
        
        return headerView;
    }
}


//推荐商品的更多触发的方法
-(void)godsMoreBtn
{
    RecommendViewController* vc = [[RecommendViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark - Delegate
// 轮播banner
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    NSLog(@"%@",self.bannerImages);
    
    if (bannerView.tag == 19875)
    {
        return self.bannerImages;
    }
    else
    {
        return self.newsBannerImages;
    }
    
}
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index
{
    return UIViewContentModeScaleToFill;
}
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index
{
    if (bannerView.tag == 19875)
    {
        return [UIImage imageNamed:@"411-186.png"];
    }
    else
    {
        return [UIImage imageNamed:@"411-110.png"];
    }
    
}
- (UIImage *)placeHolderImageOfZeroBannerView
{
    UIImage *image = [UIImage imageNamed:@"411-186.png"];
    
    return  image;
}

// 滚动到第几张
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index
{
    
}
#pragma mark --轮播图选择
/** 选择第几张，点击轮播图*/
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    if (bannerView.tag == 19875)
    {
        LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
        LHFirstPageModel *model = self.dataSource[index];
        vc.goods_id = model.id;
        vc.backRootVC = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        GodsDesViewController *vc = [[GodsDesViewController alloc] init];
        LHFirstPageModel* model = (LHFirstPageModel *)_pbannersArray[index];
        vc.myId = model.id;
        
        vc.title = @"广告详情";
        [self.navigationController pushViewController:vc animated:YES];
    }
 }

//广告的点击触发的方法
-(void)adAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    
    int i = imageView.frame.origin.x/SCREEN_WIDTH;
    
    NSLog(@"%d",i);
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return SCREEN_WIDTH*0.45;
    else if(section ==1)
        return 10;
    else if(section ==2)
        return SCREEN_WIDTH/5*4/3;
    else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0)
    {
        return 20;
    }
    else
    {
        return 0.1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

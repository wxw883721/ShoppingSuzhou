//
//  LHShopDetailViewController.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/5.
//  Copyright (c) 2015年 SU. All rights reserved.
//







/*
 
 用不到的controller

*/






#import "LHShopDetailViewController.h"
#import "LHShopDetaiModel.h"
#import "StarView.h"
#import "DetailEvaluationViewController.h"
#import "LHGodsDetailViewController.h"
#import "LHRecommendViewController.h"

@interface LHShopDetailViewController () <CLLocationManagerDelegate>

@property (nonatomic,assign) BOOL isSelected;
@property (strong, nonatomic)  UIImageView *firstImage;
@property (strong, nonatomic)  UILabel *firstLabel1;
@property (strong, nonatomic)  UILabel *firstLabel2;

@property (strong, nonatomic)  UIImageView *secondImage;
@property (strong, nonatomic)  UILabel *secondLabel1;
@property (strong, nonatomic)  UILabel *secondLabel2;

@property (strong, nonatomic)  UIImageView *thirdImage;
@property (strong, nonatomic)  UILabel *thirdLabel1;
@property (strong, nonatomic)  UILabel *thirdLabel2;

@property (strong, nonatomic)  UIImageView *fourImage;
@property (strong, nonatomic)  UILabel *fourLabel1;
@property (strong, nonatomic)  UILabel *fourLabel2;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) LHShopDetaiModel *model;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *pingfengLabel;
@property (nonatomic, strong) UIButton *detailMap;
@property (nonatomic, strong) UILabel *perpleLabel;
@property (nonatomic, strong) UILabel *jiejianLabel;
@property (nonatomic, strong) StarView *myStarView;

@property (nonatomic, strong) UIView *goodsView;
@property (nonatomic, strong) UIView *view2;

@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation LHShopDetailViewController
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
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:kKey];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    _latitude = [[info objectForKey:@"lat"] floatValue];
    _longitude = [[info objectForKey:@"lon"] floatValue];
    NSString *url = [NSString stringWithFormat:SHOPDETAIL_URL, self.store_id, _longitude, _latitude,key];
    
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
                [MBProgressHUD showMessage:@"未知错误"];
            }
        }
        else
        {
            [MBProgressHUD showMessage:kError];
        }
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewTitle:@"商户详情"];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self creatNavi];
    
    [self isLogin];
    
    
    [self creatSubViews];
    
    [self request];
}

- (void)isLogin
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:kKey])
    {
        self.saveBtn.enabled = NO;
        self.saveBtn.selected = NO;
    }
}

- (void)creatNavi {
    UIButton * saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    
    
    [saveBtn setImage:[UIImage imageNamed:@"本店商品列表_暗五星"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"本店商品列表_亮五星"] forState:UIControlStateSelected];
    
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
    
    NSString *url = [NSString stringWithFormat:SHOPDETAIL_URL, self.store_id, _longitude, _latitude] ;
    
    [self cacheWithUrl:url target:self action:@selector(analyze:)];
    
    NSLog(@"%@",url);
}

- (void)analyze:(NSData*)data
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary* appdic = dic[@"data"][@"store_info"];
    _model = [[LHShopDetaiModel alloc] init];
    [_model setValuesForKeysWithDictionary:appdic];
   
    
    NSArray* recommendArr = dic[@"data"][@"recommended_goods_list"];
    
    for (NSDictionary* recomDic in recommendArr) {
        LHShopDetaiModel* model1  = [[LHShopDetaiModel alloc] init];
        [model1 setValuesForKeysWithDictionary:recomDic];
        [self.dataSource addObject:model1];
    }
    
    [self updataUI:_model];
    [self updataUI1:self.dataSource];
    
    [self removeHudViewFrom:self];
}

- (void)updataUI1:(NSArray*)array
{
    
    for(int i = 0; i< array.count;i++)
    {
        UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.25*i, CGRectGetHeight(_view2.frame)*0.18+5, SCREEN_WIDTH*0.25, _view2.frame.size.height*0.7)];
        
        LHShopDetaiModel* model = array[i];
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.02, 0, SCREEN_WIDTH*0.2, goodsView.frame.size.height *0.7)];
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
        
        [_view2 addSubview:goodsView];
    }
    
}

- (void)pushGoodsDetail:(UITapGestureRecognizer *)tap
{
    UIView *goodsView = tap.view ;
    
    
    int i = goodsView.tag-1222;
    
    LHShopDetaiModel *model = self.dataSource[i];
    
    LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
    vc.goods_id = model.goods_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)updataUI:(LHShopDetaiModel *)model
{
//    self.isSelected = [_model.store_fav intValue];
//    self.saveBtn.selected = self.isSelected;
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.store_cover] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    _titleLabel.text = model.store_name;
    _distanceLabel.text = [NSString stringWithFormat:@"%@米",model.store_juli];
    [_myStarView setStar:[model.seval_total floatValue]];
    _pingfengLabel.text = [NSString stringWithFormat:@"%.1f分", [model.seval_total floatValue]];
    _perpleLabel.text = [NSString stringWithFormat:@"%d人评价", [model.seval_num intValue]];
    
    [_detailMap setTitle:model.store_address forState:UIControlStateNormal];
    _detailMap.titleLabel.numberOfLines = 0;
    
}


- (void)creatSubViews {
    
    /** 头部图片*/
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-64)*0.3-5)];
    [self.view addSubview:_headImage];
    
    /** 视图一*/
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImage.frame)+5, SCREEN_WIDTH, SCREEN_WIDTH*0.4)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, 1)];
//    line1.layer.borderColor = [UIColor grayColor].CGColor;
//    line1.layer.borderWidth = 1;
//    [view1 addSubview:line1];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH*0.4, CGRectGetHeight(view1.frame)*0.1)];
    _titleLabel.font = [UIFont systemFontOfSize:Text_Big];
    _titleLabel.textColor = [UIColor blackColor];
    [view1 addSubview:_titleLabel];
    
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 20, SCREEN_WIDTH*0.4, CGRectGetHeight(_titleLabel.frame))];
    _distanceLabel.font = [UIFont systemFontOfSize:Text_Normal];
    [view1 addSubview:_distanceLabel];
    
    _detailMap = [[UIButton alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame)+20, SCREEN_WIDTH*0.7-5, CGRectGetHeight(view1.frame)*0.35)];
    _detailMap.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_detailMap setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _detailMap.titleLabel.font = [UIFont systemFontOfSize:Text_Normal];
    _detailMap.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_detailMap addTarget:self action:@selector(detailMap:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:_detailMap];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40- CGRectGetHeight(view1.frame)*0.2, view1.frame.size.height*0.15, 1, CGRectGetHeight(view1.frame)*0.4)];
                                                             
    line2.layer.borderColor = [UIColor grayColor].CGColor;
    line2.layer.borderWidth = 1;
    [view1 addSubview:line2];
    
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20- CGRectGetHeight(view1.frame)*0.2, view1.frame.size.height*0.2, CGRectGetHeight(view1.frame)*0.3, CGRectGetHeight(view1.frame)*0.3)];
    [phoneButton setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(phoneCall:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:phoneButton];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_detailMap.frame)+1, SCREEN_WIDTH-10, 1)];
    line3.layer.borderWidth = 1;
    line3.layer.borderColor = [UIColor grayColor].CGColor;
    [view1 addSubview:line3];
    
    _myStarView = [[StarView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line3.frame)+2, SCREEN_WIDTH * 0.3, 0.1*CGRectGetHeight(view1.frame))];
    [view1 addSubview:_myStarView];
    
    _pingfengLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_myStarView.frame), CGRectGetMinY(_myStarView.frame)+5, SCREEN_WIDTH*0.2, CGRectGetHeight(_myStarView.frame))];
    [view1 addSubview:_pingfengLabel];
    
    _perpleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_pingfengLabel.frame), CGRectGetMinY(_pingfengLabel.frame), 0.25*SCREEN_WIDTH, CGRectGetHeight(_pingfengLabel.frame))];
    [view1 addSubview:_perpleLabel];
    
    UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, CGRectGetMinY(_perpleLabel.frame), 15, 20)];
    [detailBtn setImage:[UIImage imageNamed:@"30-40"] forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(detailPingjia:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:detailBtn];
    
    _jiejianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_myStarView.frame)+5, CGRectGetWidth(view1.frame)-20, CGRectGetHeight(view1.frame)*0.35)];
    [view1 addSubview:_jiejianLabel];

    
    /** 视图二*/
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame)+10, SCREEN_WIDTH, SCREEN_WIDTH*0.4)];
    _view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, CGRectGetHeight(_view2.frame)*0.18)];
    label.text = @"本店推荐商品";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17];
    [_view2 addSubview:label];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 5, 15, 20)];
    [moreBtn setImage:[UIImage imageNamed:@"30-40"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(tuijian:) forControlEvents:UIControlEventTouchUpInside];
    [_view2 addSubview:moreBtn];

}

//#pragma mark- 位置代理
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    _init = YES;
//    
//    CLLocation *newlocation = [locations lastObject];
//    _latitude = newlocation.coordinate.latitude;
//    _longitude = newlocation.coordinate.longitude;
//    
//    _cllocation.latitude = _latitude;
//    _cllocation.longitude = _longitude;
//    
//    if (_init) {
//        [self request];
//    }
//    _init = NO;
//}
//
/** 点击电话按钮*/
- (void)phoneCall:(UIButton *)sender {
    
//    NSLog(@"_+_+_+_+_+_+_+_+  ");
    
//    NSString *phoneNum = @"12345678";
//    
//    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"TEL:%@", phoneNum]];
//    
//    if (!_phoneCallWebView) {
//        _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    }
//    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    NSString *store_phone = _model.store_tel;
    
//    b[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",store_phone]]];
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",store_phone]];
    if ( !_phoneCallWebView ) {
        _phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来 效果跟方法二一样 但是这个方法是合法的
    }
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
}

- (void)detailMap:(UIButton *)sender {
    
    NSLog(@"点击地址");
}

- (void)detailPingjia:(UIButton *)sender {
    if ([_model.seval_num isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"暂无评论"];
        return;
    }
    DetailEvaluationViewController *vc = [[DetailEvaluationViewController alloc] init];
    vc.shop_id = self.store_id;
    vc.shop_count = _model.seval_total;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tuijian:(UIButton *)sender {
    
    LHRecommendViewController *vc = [[LHRecommendViewController alloc] init];
    
    vc.store_id = self.store_id;
    
    [self.navigationController pushViewController:vc animated:NO];
    
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

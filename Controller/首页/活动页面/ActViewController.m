//
//  ActViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ActViewController.h"
#import "ActionCollectionViewCell.h"
#import "ActionBannersModel.h"
#import "ActionImageModel.h"
#import "XianShiViewController.h"
#import "DaZheViewController.h"
#import "JianManViewController.h"
#import "IntegralMallVC.h"
#import "LHGodsDetailViewController.h"

@interface ActViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) KDCycleBannerView *showBanner;
@property(nonatomic,strong) NSMutableArray *bannerImages;
@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray *tableSource;

@end


@implementation ActViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bannerImages removeAllObjects];
    
    _tableSource = [[NSMutableArray alloc] init];
    [self requset];
    
    [self loadBannerImages];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)loadBannerImages
{
    
    if (_tableSource.count != 0) {
        NSArray *banArr = _tableSource[0];
        for (ActionBannersModel *model in banArr) {
            [self.bannerImages addObject:model.img];
            NSLog(@"%@",self.bannerImages);
        }
    }
}

- (NSMutableArray *)bannerImages
{
    if (!_bannerImages) {
        _bannerImages = [[NSMutableArray alloc]init];
    }
    
    return _bannerImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"活动专区"];
    [self createBanner];

}

//网络请求模块
- (void)requset
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self cacheWithUrl:ACTION_URL target:self action:@selector(analyze:)];
}

//解析数据
- (void)analyze:(NSData *)data
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (!_tableSource) {
        _tableSource = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 
    NSDictionary *dataDic = dic[@"data"];
    NSArray *bannersArr = dataDic[@"banners"];
    NSMutableArray *banArr = [[NSMutableArray alloc] init];
    for (NSDictionary *bannersDic in bannersArr) {
        
        ActionBannersModel *model = [[ActionBannersModel  alloc] init];
        [model setValuesForKeysWithDictionary:bannersDic];
        [banArr addObject:model];
    }
    
    NSLog(@"%@",banArr);
    [_tableSource addObject:banArr];
    
    ActionImageModel *imageModel = [[ActionImageModel alloc] init];
    imageModel.dazhe_img = dataDic[@"dazhe_img"];
    imageModel.mansong_img = dataDic[@"mansong_img"];
    imageModel.point_img = dataDic[@"point_img"];
    imageModel.xianshi_img = dataDic[@"xianshi_img"];
    
    [_tableSource addObject:imageModel];
    
    [self createBanner];
    
    [self createCollectionView];
}

//创建UICollectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3*2) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ActionCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark- UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT/6);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    ActionImageModel *model = _tableSource[1];
    
    NSArray *titleNames = @[@"限时抢购",@"打折促销",@"积分兑换",@"减满优惠"];
    
    cell.desLabel.text = titleNames[indexPath.item];
    
    if (indexPath.item == 0) {
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.xianshi_img]placeholderImage:[UIImage imageNamed:@"190-112.png"]];
    }
    else if (indexPath.item == 1)
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.dazhe_img]placeholderImage:[UIImage imageNamed:@"190-112.png"]];
    else if (indexPath.item == 2)
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.point_img]placeholderImage:[UIImage imageNamed:@"190-112.png"]];
    else
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.mansong_img]placeholderImage:[UIImage imageNamed:@"190-112.png"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0)
    {
        XianShiViewController *vc = [[XianShiViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.item == 1)
    {
        DaZheViewController *vc = [[DaZheViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.item == 3)
    {
        JianManViewController *vc = [[JianManViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        IntegralMallVC *vc = [[IntegralMallVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//创建滚动视图
- (void)createBanner
{
    _showBanner = [[KDCycleBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    [self loadBannerImages];
    _showBanner.delegate = self;
    _showBanner.datasource = self;
    _showBanner.continuous = YES;
    _showBanner.autoPlayTimeInterval = 3.0;
    [self.view addSubview:_showBanner];
}


#pragma mark - Delegate
// 轮播banner
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return self.bannerImages;
}
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index
{
    return UIViewContentModeScaleToFill;
}

// 滚动到第几张
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index
{
    
}
// 选择第几张
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    NSArray *banArr = _tableSource[0];
    ActionBannersModel *model = banArr[index];
    
    LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
    vc.goods_id = model.id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index
{
    
    return [UIImage imageNamed:@"411-200.png"];
}
- (UIImage *)placeHolderImageOfZeroBannerView
{
    UIImage *image = [UIImage imageNamed:@"411-200.png"];
    
    return  image;
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

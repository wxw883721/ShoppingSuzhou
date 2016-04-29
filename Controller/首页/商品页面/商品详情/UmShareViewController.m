//
//  UmShareViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "UmShareViewController.h"
#import "UMSocial.h"
#import "ShareCell.h"

@interface UmShareViewController ()<UMSocialUIDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation UmShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [super viewDidLoad];
    [self setViewTitle:@"商品详情"];
    
    [self createTableView];
    
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ShareCell class] forCellReuseIdentifier:@"shareCell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"shareCell" forIndexPath:indexPath];
    NSArray *titleArr = @[@"微博",@"QQ空间",@"微信好友",@"朋友圈"];
    NSArray *imageArr = @[@"sina",@"qzone",@"wechat",@"wechat_timeline"];
        
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"UMS_%@_icon@2x",imageArr[indexPath.row]]];
    cell.titleLabel.text = titleArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row == 0)
    {
        [[UMSocialControllerService defaultControllerService] setShareText:@"百购宿州   一个神奇的app，http://www.bgsz.tv/shop/index.php" shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }
    else if (indexPath.row == 1)
    {
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:@"百购宿州   一个神奇的app http://www.bgsz.tv/shop/index.php" image:[UIImage imageNamed:@"icon"] location:nil urlResource:nil presentedController:self
            completion:^(UMSocialResponseEntity *response) {
        
                [MBProgressHUD showSuccess:@"分享成功！"];
        
        }];
        
        [UMSocialData defaultData].extConfig.qzoneData.url = @"http://www.bgsz.tv/shop/index.php";
        
//            [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
//            [UMSocialSnsService presentSnsIconSheetView:self
//                                                 appKey:@"55af40dbe0f55a214800035b"
//                                              shareText:@"百购宿州   一个神奇的app，http://www.bgsz.tv/shop/index.php"
//                                             shareImage:[UIImage imageNamed:@"red"]
//                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,nil]
//                                               delegate:self];
//            [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
        
    }
    else if (indexPath.row == 2)
    {
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:@"百购宿州   一个神奇的app，http://www.bgsz.tv/shop/index.php" image:[UIImage imageNamed:@"icon"] location:nil urlResource:nil presentedController:self
                                                        completion:^(UMSocialResponseEntity *response) {
                                                            
                                                            [MBProgressHUD showSuccess:@"分享成功！"];
                                                            
                                                        }];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.bgsz.tv/shop/index.php";
    }
    else
    {
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:@"百购宿州   一个神奇的app，http://www.bgsz.tv/shop/index.php" image:[UIImage imageNamed:@"icon"] location:nil urlResource:nil presentedController:self
                                                        completion:^(UMSocialResponseEntity *response) {
                                                            
                                                            [MBProgressHUD showSuccess:@"分享成功！"];
                                                            
                                                        }];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.bgsz.tv/shop/index.php";
    }
}


-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        [MBProgressHUD showSuccess:@"分享成功！"];
        
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
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

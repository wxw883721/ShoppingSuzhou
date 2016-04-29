//
//  MyHeader.h
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#ifndef ShoppingSuzhou_MyHeader_h
#define ShoppingSuzhou_MyHeader_h

#define RedColor @"#c81414"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

typedef enum {
    LEFT,
    RIGHT
}posi;

#import "LHTool.h"
#import "LHRequestMissonManger.h"
#import "PSBCachesManager.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "WXAFNetwork.h"
#import "LHRequest.h"
#import "MJRefresh.h"
#import "LHHudView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Size.h"
#import "LHImageView.h"
#import "LHLabel.h"
//#import <BaiduMapAPI/BMapKit.h>

//首页接口
#define SHOUYE_URL @"http://www.bgsz.tv/mobile/index.php"
//活动专区
#define HUODONGZHUANQU_URL @"http://bgsu.hylapp.com/mobile/index.php?act=special"
//登陆接口
#define LOGIN_URL @"http://bgsu.hylapp.com/mobile/index.php?act=login"

//商品接口

#define SU_GOODS_URL @"http://www.bgsz.tv/mobile/index.php?act=goods&op=goods_list&page=5"

#define GOODS_URL @"http://www.bgsz.tv/mobile/index.php?act=goods&op=goods_list&page=5&curpage=%d&&okwords=%@&order=%@&gc_id_1=%@&gc_id_2=%@"
#define SEARCH_URL @"http://www.bgsz.tv/mobile/index.php?act=goods&op=goods_list&page=5&curpage=%d&keyword=%@"

#define SearchGoodsUrl @"http://www.bgsz.tv/mobile/index.php?act=goods&op=goods_list&page=5"

//商户接口
#define TENANT_URL_1 @"http://www.bgsz.tv/mobile/index.php?act=stores&op=index&curpage=%d"
#define TENANT_URL @"http://www.bgsz.tv/mobile/index.php?act=stores&op=index&curpage=%d&keyword=%@"


//商家详情接口
#define SHOPDETAIL_URL @"http://www.bgsz.tv/mobile/index.php?act=stores&op=show&id=%@&lng=%f&lat=%f&key=%@"

//商户推荐商品
#define SHOP_Recommend_URL @"http://www.bgsz.tv/mobile/index.php?act=stores&op=goods&sid="


//评价详情
#define EVALUATION_URL @"http://www.bgsz.tv/mobile/index.php?act=stores&op=stores_comment&store_id=%@&page=200&curpage=1"

//收藏店铺
#define SAVE_URL @"http://www.bgsz.tv/mobile/index.php?act=member_centre&op=storecollect&store_id=%@&key=%@"

//资讯新闻接口
#define NEWS_URL @"http://www.bgsz.tv/mobile/index.php?act=news&page=5&curpage=%d"

//新闻详情接口
#define NEWSDETAIL_URL @"http://www.bgsz.tv/mobile/index.php?act=news&op=news&news_id=%@"



//活动商品列表
#define ACT_URL @"http://www.bgsz.tv/mobile/index.php?act=index&op=act_goods&id=%@"
//活动街商户接口
#define STREET_URL @"http://www.bgsz.tv/mobile/index.php?act=index&op=act_street&id=%@"

//购物车列表接口
#define SHOPCAR_URL @"http://www.bgsz.tv/mobile/index.php?act=member_cart&op=cart_list&key=%@"

//商品详情接口
#define GOODSDETAIL_URL @"http://www.bgsz.tv/mobile/index.php?act=goods&op=goods_detail&goods_id=%@"
//商品评价接口
#define GOODSEVALUATION_URL @"http://www.bgsz.tv/mobile/index.php?act=goods&op=goods_comment&goods_id=%@&page=100&curpage=1"

//商品介绍
#define GOODSJIESHAO_URL @"http://www.bgsz.tv/mobile/index.php?act=goods&op=goods_body&goods_id=%@"

//添加到购物车
#define ADDSHOPCAR_URL @"http://www.bgsz.tv/mobile/index.php?act=member_cart&op=cart_add&key=%@&goods_id=%@&quantity=%@"
//购物车结算或立即购买接口
#define SHOPCARBUY_URL @"http://www.bgsz.tv/mobile/index.php?act=member_buy&op=buy_step1"
//购物车删除接口
#define DELETESHOPCAR_URL @"http://www.bgsz.tv/mobile/index.php?act=member_cart&op=cart_del&key=%@&cart_id=%@"
//周边商户
#define ZHOUBIAN_URL @"http://www.bgsz.tv/mobile/index.php?act=store_nearby&lng=%f&lat=%f"

//活动专区
#define ACTION_URL @"http://www.bgsz.tv/mobile/index.php?act=special"
//打折
#define DaZhe_Url @"http://www.bgsz.tv/mobile/index.php?act=special&op=dazhe"
//满减
#define ManJian_URL @"http://www.bgsz.tv/mobile/index.php?act=promotion_mansong&page=5&curpage="
//限时
#define XianShi_URL @"http://www.bgsz.tv/mobile/index.php?act=special&op=xianshi"


#define BANNER_DETAIL @"http://www.bgsz.tv/mobile/index.php?act=index&op=adv_body&id=%@"

//分类
#define SORT_URL @"http://www.bgsz.tv/mobile/index.php?act=goods_class&gc_id=%@"
//商品分类
#define kClassUrl String_Append(kUrl,@"goods_class")


#endif

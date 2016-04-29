//
//  Size.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/20.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#ifndef ShoppingSuzhou_Size_h
#define ShoppingSuzhou_Size_h


#define KScr_W [UIScreen mainScreen].bounds.size.width
#define KScr_H [UIScreen mainScreen].bounds.size.height
#define kScr_Rate [UIScreen mainScreen].bounds.size.width/320
#define kloginColor [UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:1.0]
#define kColor [UIColor colorWithRed:252.0/255.0 green:80.0/255.0 blue:32.0/255.0 alpha:1.0]
#define kLine [UIColor hexChangeFloat:@"e2e2e2"];
#define kLineImage [UIColor hexChangeFloat:@"e2e2e2"];

//登录注册
#define kData @"data"
#define kCode @"code"
//#define kUserId @"uid"
#define kUserName @"username"
#define kKey @"key"
#define kUpPone @"uphone"
#define kAvatar @"avatar"
#define kPassword @"password"
#define kClient @"client"
#define kMessage @"message"
#define kError @"网络异常"
#define kPushState @"pushState"
#define kJcode @"jcode"

#define kUrl @"http://www.bgsz.tv/mobile/index.php?act="
#define String_Append(X,Y) [X stringByAppendingString:Y]

//用户注册
#define kRedistUrl String_Append(kUrl,@"login&op=register")

//注册获取验证码
#define kCodeUrl String_Append(kUrl,@"login&op=vfsend")
//其他发送短信验证码
#define kOtherCodeUrl String_Append(kUrl,@"login&op=f_vfsend&phone=13721062453")

//用户登录
#define kLoginUrl String_Append(kUrl,@"login")

//退出登录
#define kExitLoginUrl String_Append(kUrl,@"logout")

//忘记密码第一步
#define kOneChangeUrl String_Append(kUrl,@"login&op=forget_passwd&submit=ok")
//忘记密码第二步
#define kTwoChangeUrl String_Append(kUrl,@"login&op=forget_passwd&submit=sure")

//用户个人信息
#define kPersonalMessage String_Append(kUrl,@"member_centre")
//用户个人信息提交
#define kSubmitMessage String_Append(kUrl,@"member_centre&key=6118b784ca6317ad8aedf7e9e9dda596")
//上传头像
#define kSubmitHeadImage String_Append(kUrl,@"upload")

//用户修改绑定手机号码
#define kBindMobile String_Append(kUrl,@"member_centre&op=change_phone")
//用户修改密码
#define kChangePassword String_Append(kUrl,@"member_centre&op=change_passwd")

//我的订单
#define kOrderUrl String_Append(kUrl,@"member_order&op=order_list&key=79f070772077d1e8e18d98266e2642cd")
//订单详情
#define kDetailOrderUrl String_Append(kUrl,@"member_order&op=getOrderinfo&key=79f070772077d1e8e18d98266e2642cd&order_id=76")
//申请退款
#define kRefundOrderUrl String_Append(kUrl,@"member_order&op=order_refund")
//删除订单
#define kDeleteOrderUrl String_Append(kUrl,@"member_order&op=delete_recycle")
//取消订单
#define kCancelOrderUrl String_Append(kUrl,@"member_order&op=order_cancel")
//评论
#define kEvaluationUrl String_Append(kUrl,@"member_evaluate")

//我的积分
#define kIntegral String_Append(kUrl,@"member_integral")
//用户签到得到积分
#define kSignIntegral String_Append(kUrl,@"member_integral&op=attendance")
//积分规则
#define kIntegralRules String_Append(kUrl,@"integral_rule")

//积分商城(积分兑换)
#define kIntegralMallUrl String_Append(kUrl,@"promotion_points")
#define kIntegralDetailUrl String_Append(kUrl,@"promotion_points")

//把卷发送到手机
#define kSendMsg String_Append(kUrl,@"pointcart&op=sendMsg")
//兑换订单生成积分
#define kPointCart String_Append(kUrl,@"pointcart&op=step1&pgid=2&quantity=2")

//意见反馈
#define kFeedBack String_Append(kUrl,@"feedback")

//收藏商品列表
#define kGoods String_Append(kUrl,@"member_centre&op=goodscollectlist")

//收藏店铺列表
#define kStore String_Append(kUrl,@"member_centre&op=getstorecollect&key=6118b784ca6317ad8aedf7e9e9dda596")

//移除收藏店铺
#define kDeleteKStore String_Append(kUrl,@"member_centre&op=rmstorecollect&key=6118b784ca6317ad8aedf7e9e9dda596")

//关于
#define kAbout String_Append(kUrl,@"about")

//我的抵用卷
#define kVoucher String_Append(kUrl,@"member_voucher")

//我的预存款
#define kAdvance String_Append(kUrl,@"member_predeposit")
//预存款明细列表
#define kAdvanceDetail String_Append(kUrl,@"member_predeposit&op=pd_log_list")
//预存款单条明细
#define kPredeposit String_Append(kUrl,@"member_predeposit&op=pd_log")

//周边商户
#define kAroundStore String_Append(kUrl,@"store_nearby")

//购物车
#define kShoppingCar String_Append(kUrl,@"member_cart&op=cart_list")

//更新购物车购买数量
#define kShoppingCarNum String_Append(kUrl,@"member_cart&op=cart_quantity")

//删除购物车
#define kDeleteCart String_Append(kUrl,@"member_cart&op=cart_del")

//系统消息列表
#define kSystemMess String_Append(kUrl,@"member_message&op=index")
//系统消息详情
#define kMessDetail String_Append(kUrl,@"member_message&op=showmsgbatch")
//删除系统消息
#define kDeleteSystemMess String_Append(kUrl,@"member_message&op=dropbatchmsg")

//获取省市县
#define kObtainAddress String_Append(kUrl,@"area&op=index&parent_id=0")

//生成二维码
#define kTd_code String_Append(kUrl,@"td_code&t_code=456278958887")


#endif

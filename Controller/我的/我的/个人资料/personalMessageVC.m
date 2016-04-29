//
//  personalMessageVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/9.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "personalMessageVC.h"
#import "Size.h"
#import "modifyMobileVC.h"
#import "personalModel.h"
#import "changePasswordVC.h"
#import "ModifyLoginPassVC.h"
#import "AFNetworking.h"
#import "MineViewController.h"

#import "ASIFormDataRequest.h"
#import "addressSelectVC.h"


@interface personalMessageVC ()
{
    NSOperationQueue *queue;
    personalModel *model ;
}

@property (nonatomic,weak) personalMessageVC *personalMessage;

@end

@implementation personalMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    [self createUI];
    [self builtButtonClick];
}

-(void)viewWillAppear:(BOOL)animated
{
     NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    //地址
    if ([info objectForKey:@"address"] == nil) {
        _personalAddressField.text = model.areainfo;
    }
    else
    {
        NSString *str = @"安徽省 宿州市";
        _personalAddressField.text = [str stringByAppendingString:[info objectForKey:@"address"]];
    }
    _personalAddressField.enabled = NO;
    
}

-(void)createUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人资料";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
    self.personalHeadLineImage.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
    self.personalLineView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0];
    self.personalHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"个人中心_banner.jpg"]];
    self.personalImage.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    //代理
    self.personalMessage = self;
    self.personalImageView.layer.cornerRadius = 30;
    self.personalImageView.layer.masksToBounds = YES;
    
}


//请求数据
-(void)requestData
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WXAFNetwork getRequestWithUrl:kPersonalMessage parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
                 
                 model = [[personalModel alloc]init];
                 [model setValuesForKeysWithDictionary:data];
                 
                 //头像
                 if (model.avatar.length == 0) {
                     [_personalImageView sd_setImageWithURL:[info objectForKey:kAvatar] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
                 }
                 else
                 {
                 [_personalImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
                     NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
                     [info setValue:model.avatar forKey:kAvatar];
                 }
                 
                 if ([info objectForKey:@"address"] == nil) {
                     _personalAddressField.text = model.areainfo;
                 }
                 else
                 {
                     NSString *str = @"安徽省 宿州市";
                     _personalAddressField.text = [str stringByAppendingString:[info objectForKey:@"address"]];
                 }
                 _personalAddressField.enabled = NO;
                 //昵称
                 _personalNicknameField.placeholder = model.nickname;
                 //电话号码
                 _personalMobileField.placeholder = model.uphone;
                 //email
                 _personalEmailField.placeholder = model.email;
                 
                 //密码
                 _personalPasswordfield.text = model.password;
                 self.personalPasswordfield.hidden = YES;
                 
                //手机号
                 if (!self.personalMobileField.text == 0) {
                     
                     self.personalMobileField.enabled = NO;
                     self.modifyMobileBtn.hidden = NO;
                 }
                 
                 //登录密码
                 if (!self.personalPasswordfield.text == 0) {
                     
                     self.personalPasswordfield.hidden = YES;
                     self.modifyPasswordBtn.hidden = NO;
                 }
                 
                }
             
             else
             {
                 [MBProgressHUD showError:[data objectForKey:kMessage]];
             }
             
         }
         else
         {
             [MBProgressHUD showError:kError];
             
         }
         
     }
     ];
    
}


//创建button的点击事件
-(void)builtButtonClick
{
    //设置头像
    [self.setHeadbtn addTarget:self action:@selector(setHeadbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //修改手机号
    self.modifyMobileBtn.backgroundColor = kColor;
    self.modifyMobileBtn.layer.cornerRadius = 5.0;
    self.modifyMobileBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    [self.modifyMobileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.modifyMobileBtn addTarget:self action:@selector(modifyMobileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //修改登录密码
    self.modifyPasswordBtn.backgroundColor = kColor;
    self.modifyPasswordBtn.layer.cornerRadius = 5.0;
    self.modifyPasswordBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    [self.modifyPasswordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.modifyPasswordBtn addTarget:self action:@selector(modifyPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //提交资料
    self.submitMessageBtn.backgroundColor = kColor;
    self.submitMessageBtn.layer.cornerRadius = 5.0;
    self.submitMessageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    [self.submitMessageBtn setTitle:@"提交资料" forState:UIControlStateNormal];
    [self.submitMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitMessageBtn addTarget:self action:@selector(submitMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


//点击事件
-(void)setHeadbtnClick:(UIButton *)btn
{
    UIActionSheet *sheet;
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    sheet.tag = 225;
    
    [sheet showInView:self.personalMessage.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 225) {
        NSUInteger sourceType = 0;
        
        //判断是否支持相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1:
                    //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else
        {
            if (buttonIndex == 0) {
                return;
            }
            else
            {
                sourceType  = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }
            
        }
        //跳转到相册或相机界面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self.personalMessage presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self saveImage];
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.personalImageView setImage:image];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.personalMessage dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)saveImage
{
    NSData *imageData;
    
    if (self.personalImageView.image) {
        
        imageData = UIImageJPEGRepresentation(self.personalImageView.image, 0.1);
    }
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    //NSString *url = [NSString stringWithFormat:@"%@&key=%@",kSubmitHeadImage,key];
    [self requestSendHeadImg:key andData:imageData];
}

/*************************************************************
 函数名称	:	requestSendHeadImg
 函数描述	:	上传头像调用的方法
 输入参数	:
 输出参数	:
 返回值	:
 备注	:
 *************************************************************/

- (void)requestSendHeadImg:(NSString*)keyId andData:(NSData*)picData
{
    
    //NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:];
    //    NSString *creatCircleInfoJson = [dict JSONFragment];
    
    //url
    NSString *sendInfoUrl = [NSString stringWithFormat:@"%@",kSubmitHeadImage];
    
    
    NSData *imageData = nil;
    if (picData)
    {
        imageData = picData;//[NSData dataWithData:picData];
    }
    else
    {
        //        DDLog(@"图片流为空");
    }
    
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:sendInfoUrl]];
    
    [request addPostValue:keyId forKey:@"key"];
    
    //获取日期数据，
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //转换为字符串
    NSString *dateString = [dateFormatter stringFromDate:date];
    dateString = [[[dateString stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    //生产一个日期加随机数的文件名
    NSMutableString *listnoStr = [NSMutableString stringWithString:dateString];
    
    //生成一个四位的随机数
    const int N = 4;
    NSString *sourceString = @"0123456789";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];//随机取一位字符
        [result appendString:s];
    }
    
    [listnoStr appendString:result];
    //DDLog(@"随机数是：%@",listnoStr);
    
    if (imageData)
    {
        [request addData:imageData withFileName:[NSString stringWithFormat:@"%@.png",listnoStr] andContentType:@"image/jpeg" forKey:@"file"];
    }
    else
    {
        //DDLog(@"数据为空，不发送数据流");
        [request addData:imageData withFileName:@"" andContentType:@"image/jpeg" forKey:@"photo"];
    }
    
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    request.timeOutSeconds = 60.f;
    
    request.shouldAttemptPersistentConnection = NO;
    
    [request startAsynchronous];
    
    
}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate 请求完之后调用的方法
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dataDic = dic[kData];
    
    
    NSString *message = dataDic[kMessage];
    [MBProgressHUD showSuccess:message];
    [self requestData];

    NSLog(@"success:%@",request.responseString);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    NSLog(@"faile:%@",request.responseString);
}





//手机号点击事件
-(void)modifyMobileBtnClick:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    
    modifyMobileVC *vc = [[modifyMobileVC alloc]init];
    vc.mobile = self.personalMobileField.placeholder;
    
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"%@",self.personalMobileField.text);
    
}

-(void)modifyPasswordBtnClick:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    ModifyLoginPassVC *vc = [[ModifyLoginPassVC alloc]init];
    vc.mobile = self.personalMobileField.placeholder;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)submitMessageBtnClick:(UIButton *)btn
{
    
    //提交个人信息
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *submit = @"ok";
    
    NSString *nickname = [[NSString alloc]init];
    NSString *email = [[NSString alloc]init];
    NSString *areainfo = [[NSString alloc]init];;
    if ([info objectForKey:@"address"] == nil) {
        areainfo = model.area_id;
    }
    else
    {
       
        areainfo = [info objectForKey:@"area_id"];
    }

    //判断昵称
    if (self.personalNicknameField.text.length == 0) {
        nickname = model.nickname;
    }
    else
    {
        nickname = self.personalNicknameField.text;
        
    }
    //判断邮箱
    if (self.personalEmailField.text.length == 0) {
        email = model.email;
    }
    else
    {
        email = self.personalEmailField.text;
        
    }
    
    //判断邮箱的正则表达式
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isRight = [emailTest evaluateWithObject:email];
    
    if (nickname.length == 0) {
        
        [MBProgressHUD showError:@"未填写昵称"];
    }
    else if (isRight == NO&& email.length != 0) {
        
        [MBProgressHUD showError:@"邮箱输入规格不正确"];
    }
    else if ([info objectForKey:@"address"] == nil)
    {
        [MBProgressHUD showError:@"地址不能为空"];
    }
    else
    {
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",submit,@"submit",nickname,@"nickname",areainfo,@"areainfo",email,@"email", nil];
        [WXAFNetwork postRequestWithUrl:kSubmitMessage parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
         {
             if (isSuccessed) {
                 
                 NSNumber *code = [resultObject objectForKey:kCode];
                 NSDictionary *data = [resultObject objectForKey:kData];
                 
                 if ([code integerValue] == 200) {
                     
//                     personalModel *perModel = [[personalModel alloc]init];
//                     [perModel setValuesForKeysWithDictionary:data];
                     [MBProgressHUD showSuccess:@"修改成功"];
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 }
                 else
                 {
                     [MBProgressHUD showError:[data objectForKey:kMessage]];
                     
                 }
             }
             else
             {
                 [MBProgressHUD showError:kError];
                 
             }
             
             
         }];
    }
    
}


-(void)touchBtn:(UIButton *)btn
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"address"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"area_id"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)adressSelectBtn:(id)sender {
    
    addressSelectVC *vc = [[addressSelectVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    //NSLog(@"%@",vc.address);
     //self.personalAddressField.text = [model.areainfo stringByAppendingString:vc.address];
    
}

@end

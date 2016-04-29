//
//  feedBackVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "feedBackVC.h"
#import "Size.h"

@interface feedBackVC () 

@end

@implementation feedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createTextView];
    [self createLabel];
    [self createBtn];
    
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"意见反馈";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)createTextView
{
    
    self.defaultLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, KScr_W - 20, 20)];
    self.defaultLabel.font = [UIFont systemFontOfSize:Text_Normal];
    self.defaultLabel.textColor = [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1];
    self.defaultLabel.text = @" 你的每条意见和建议都是我们成长的动力!";
    
    self.feedTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 5, KScr_W , 150)];
    self.feedTextView.backgroundColor = [UIColor clearColor];
    self.feedTextView.font = [UIFont systemFontOfSize:Text_Big];
    self.feedTextView.delegate = self;
    
    
    //键盘弹回条
    
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [topView setItems:buttonsArray];
    
    [self.feedTextView setInputAccessoryView:topView];

    [self.feedTextView addSubview:self.defaultLabel];
    
    [self.view addSubview:self.feedTextView];

}
//点击完成隐藏键盘

- (void)dismissKeyBoard {
    
    [self.feedTextView resignFirstResponder];
    
}





-(void)createLabel
{
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 154, KScr_W, 1)];
    image1.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1];
    [self.view addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 204, KScr_W, 1)];
    image2.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1];
    [self.view addSubview:image2];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 155, KScr_W , 50)];
    _nameField.placeholder = @" 请输入姓名/电话/邮箱";
    _nameField.delegate = self;
    //字体
    [_nameField setValue:[UIFont boldSystemFontOfSize:Text_Normal] forKeyPath:@"placeholderLabel.font"];
    _nameField.font = [UIFont systemFontOfSize:Text_Big];
    
    [self.view addSubview:_nameField];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)createBtn
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W/2 - 145, 265, 290, 40)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"提 交" forState:UIControlStateNormal];
    button.backgroundColor = kColor;
    button.layer.cornerRadius = 5.0;
    button.titleLabel.font = [UIFont boldSystemFontOfSize: 17.0];
    [button addTarget:self action:@selector(commitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.defaultLabel.hidden = YES;
    return YES;

}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text == nil || [textView.text isEqual:@""]) {
        self.defaultLabel.hidden = NO;
    }
   
    return YES;
}

//提交
-(void)commitBtn:(UIButton *)btn
{
    NSString *content = self.feedTextView.text;
    NSString *user = self.nameField.text;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content",user,@"user",nil];
    
    if (content == nil || content.length == 0)
    {
        [MBProgressHUD showError:@"请输入意见内容！"];
    }
    else if (user.length == 0 || user == nil)
    {
        [MBProgressHUD showError:@"请输入姓名、电话或邮箱"];
    }
    else
    {
    [WXAFNetwork postRequestWithUrl:kFeedBack parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             NSNumber  *code = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
                 
                 //NSString *message = [data objectForKey:kMessage];
                 [MBProgressHUD showSuccess:@"反馈成功"];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [self.navigationController popViewControllerAnimated:YES];
                 });
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
}

-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

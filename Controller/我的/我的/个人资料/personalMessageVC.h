//
//  personalMessageVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/9.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface personalMessageVC : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)adressSelectBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *personalHeadView;
@property (strong, nonatomic) IBOutlet UIImageView *personalHeadLineImage;
@property (strong, nonatomic) IBOutlet UIImageView *personalImage;

@property (strong, nonatomic) IBOutlet UIImageView *personalImageView;
@property (strong, nonatomic) IBOutlet UITextField *personalNicknameField;
@property (strong, nonatomic) IBOutlet UITextField *personalMobileField;
@property (strong, nonatomic) IBOutlet UITextField *personalEmailField;
@property (strong, nonatomic) IBOutlet UITextField *personalAddressField;
@property (strong, nonatomic) IBOutlet UITextField *personalPasswordfield;

@property (strong, nonatomic) IBOutlet UIView *personalLineView;
@property (strong, nonatomic) IBOutlet UIButton *setHeadbtn;
@property (strong, nonatomic) IBOutlet UIButton *modifyMobileBtn;
@property (strong, nonatomic) IBOutlet UIButton *modifyPasswordBtn;
@property (strong, nonatomic) IBOutlet UIButton *submitMessageBtn;


@property (nonatomic,retain)NSString *addressString;

@end

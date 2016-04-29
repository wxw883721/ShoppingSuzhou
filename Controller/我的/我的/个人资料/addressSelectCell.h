//
//  addressSelectCell.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/8/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class addressSelectCell;

@protocol addressSelectCell <NSObject>


@end


@interface addressSelectCell : UITableViewCell

@property (nonatomic,assign)id <addressSelectCell>delegate;

@property (nonatomic,retain)UILabel *addressLabel;

-(void)config:(NSDictionary *)dic;

@end

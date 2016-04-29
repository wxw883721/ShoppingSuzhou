//
//  LLHTenantCell.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/25.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LLHTenantCell.h"
#import "StarView.h"
#import "LHTenantModel.h"

@implementation LLHTenantCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /** 图片*/
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
        [self.contentView addSubview:_headerView];
        
        /** 标题*/
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerView.frame)+5, 10, KScr_W-105-65, 40)];
        _titleLabel.font = [UIFont systemFontOfSize:Text_Big];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        /** 距离*/
        _jiliLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, 10, 80, 30)];
        _jiliLabel.font = [UIFont systemFontOfSize:Text_Normal];
       [self.contentView addSubview:_jiliLabel];
       
        /** 详细地址*/
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerView.frame)+5, CGRectGetMaxY(_titleLabel.frame), SCREEN_WIDTH-CGRectGetMaxX(_headerView.frame)-20, 40)];
        _detailLabel.font = [UIFont systemFontOfSize:Text_Normal];
        _detailLabel.numberOfLines = 0;
        [self.contentView addSubview:_detailLabel];
       
        /** 评分星级*/
        _starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerView.frame)+5, CGRectGetMaxY(_detailLabel.frame), 100, 20)];
        [self.contentView addSubview:_starView];
       
        /** 评价人数*/
        _pingjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(_detailLabel.frame), 100, 20)];
        _pingjiaLabel.textColor = [UIColor grayColor];
        _pingjiaLabel.font = [UIFont systemFontOfSize:Text_Normal];
        [self.contentView addSubview:_pingjiaLabel];
        
    }
    return self;
}

//+ (LLHTenantCell *)cellWithtableView:(UITableView *)table {
//    static NSString *ident = @"cell";
//    
//    LLHTenantCell *cell = [table dequeueReusableCellWithIdentifier:ident];
//    if (cell == nil) {
//        cell = [[LLHTenantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
//    }
//    return cell;
//}

- (void)setTenantModel:(LHTenantModel *)tenantModel {
    _tenantModel = tenantModel;
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:tenantModel.store_cover] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    
//    CGFloat titleH = [tenantModel.store_name boundingRectWithSize:CGSizeMake(KScr_W-105-65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
//    _titleLabel.frame = CGRectMake(105, 10, KScr_W-170, titleH);
    _titleLabel.text = tenantModel.store_name;
    
    if([tenantModel.juli floatValue] > 1000)
    {
        _jiliLabel.text = [NSString stringWithFormat:@"%.2fkm",[tenantModel.juli floatValue]/1000];
    }
    else
    {
         _jiliLabel.text = [NSString stringWithFormat:@"%dm",[tenantModel.juli integerValue]];
    }
    
//    CGFloat detailH = [tenantModel.store_address boundingRectWithSize:CGSizeMake(KScr_W-115, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
//    _detailLabel.frame = CGRectMake(105, CGRectGetMaxY(_titleLabel.frame), KScr_W-115, detailH);
    _detailLabel.text = tenantModel.store_address;

//    _starView.frame = CGRectMake(CGRectGetMaxX(_headerView.frame)+5, CGRectGetMaxY(_detailLabel.frame), 100, 25);
    [_starView setStar:[tenantModel.seval_total intValue]];
    
//    _pingjiaLabel.frame = CGRectMake(SCREEN_WIDTH-100, , 100, 25);
    _pingjiaLabel.text = [NSString stringWithFormat:@"%@人评价", tenantModel.seval_num];
}
- (void)awakeFromNib {
    // Initialization cod
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

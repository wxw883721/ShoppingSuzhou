//
//  ActStreetCell.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/7/2.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ActStreetCell.h"
#import "StarView.h"
#import "ActStreetModel.h"

@implementation ActStreetCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        [self.contentView addSubview:_headView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame)+5, 5, SCREEN_WIDTH-100, 30)];
        [self.contentView addSubview:_nameLabel];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame)+5, CGRectGetMaxY(_nameLabel.frame)+10, 100, 20)];
        [self.contentView addSubview:_starView];
        
        _salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_starView.frame), CGRectGetMinY(_starView.frame), SCREEN_WIDTH-CGRectGetMaxX(_starView.frame), 30)];
        [self.contentView addSubview:_salesLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79, SCREEN_WIDTH, 1)];
        lineImageView.backgroundColor = [UIColor hexChangeFloat:@"e2e2e2"];
        [self.contentView addSubview:lineImageView];
        
    }
    return self;
}


- (void)setActStreetModel:(ActStreetModel *)actStreetModel {
    _actStreetModel = actStreetModel;
    [self.headView sd_setImageWithURL:[NSURL URLWithString:actStreetModel.store_cover]placeholderImage:[UIImage imageNamed:@"200-200.png"]];
    self.nameLabel.text = actStreetModel.store_name;
//    [self.starView setStar:[actStreetModel.praise_rate floatValue]];
    [self.starView setStar:5.0];
    self.salesLabel.text = [NSString stringWithFormat:@"已售 %@", actStreetModel.store_sales];

}

+ (ActStreetCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ident = @"cell";
    ActStreetCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[ActStreetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

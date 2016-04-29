//
//  EvaluationTableViewCell.m
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "EvaluationTableViewCell.h"
#import "StarView.h"
#import "EvaluationModel.h"
#import "ShangpinEvaluationModel.h"

@implementation EvaluationTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        //时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScr_W-200, 10, 180, 30)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:Text_Big];
        //内容
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:Text_Big];
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //星级评价
        _stareView = [[StarView alloc] init];
 
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_stareView];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_detailLabel];
        
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.font = [UIFont systemFontOfSize:Text_Big];
        _answerLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_answerLabel];
        
        _storeContent = [[UILabel alloc] init];
        _storeContent.font = [UIFont systemFontOfSize:Text_Big];
        _storeContent.numberOfLines = 0;
        [self.contentView addSubview:_storeContent];
        
    }
    return self;
}

+ (EvaluationTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ident = @"cell";
    EvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[EvaluationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}



- (void)setMymodel:(EvaluationModel *)mymodel
{
    _mymodel = mymodel;
    
    _titleLabel.text = (mymodel.seval_membername.length == 0 || mymodel.seval_membername == nil) ? @"匿名" :  [NSString stringWithFormat:@"%@", mymodel.seval_membername];
    
    _timeLabel.text = mymodel.seval_addtime;
    
    NSString *detailStr = [NSString stringWithFormat:@"%@", mymodel.seval_content];
    CGFloat detailH = [detailStr boundingRectWithSize:CGSizeMake(KScr_W-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil].size.height;
    _detailLabel.frame = CGRectMake(10, 40, KScr_W-20, detailH);
     _detailLabel.text = mymodel.seval_content;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_detailLabel.frame)+5, 40, 20)];
    label.font = [UIFont systemFontOfSize:Text_Normal];
    label.textColor = [UIColor orangeColor];
    label.text = @"评价:";
    [self.contentView addSubview:label];
    
    _stareView.frame = CGRectMake(50, CGRectGetMaxY(_detailLabel.frame)+5, 100, 20);
    [_stareView setStar:[mymodel.seval_total floatValue]];
   
    if (mymodel.seval_storecontent.length > 0 && mymodel.seval_storecontent != nil)
    {
        _answerLabel.frame = CGRectMake(20, CGRectGetMaxY(_stareView.frame)+5, 40, 20);
        _answerLabel.text = @"商家:";
        
        NSString *storeContentStr = [NSString stringWithFormat:@"%@", mymodel.seval_storecontent];
        CGFloat storeContentH = [storeContentStr boundingRectWithSize:CGSizeMake(KScr_W-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil].size.height;
         _storeContent.frame = CGRectMake(60, CGRectGetMaxY(_stareView.frame)+5, KScr_W-70, storeContentH);
        _storeContent.text = storeContentStr;
    }
    else
    {
        
    }
}

- (CGFloat)getCellHeightWith:(EvaluationModel *)mymodel
{
    CGFloat height = 35;
    height += 5;
    
    NSString *detailStr = [NSString stringWithFormat:@"%@", mymodel.seval_content];
    CGFloat detailH = [detailStr boundingRectWithSize:CGSizeMake(KScr_W-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil].size.height;
    height += detailH;
    
    height += 5 + 20;
    
    if (mymodel.seval_storecontent.length > 0 && mymodel.seval_storecontent != nil)
    {
       
        NSString *storeContentStr = [NSString stringWithFormat:@"%@", mymodel.seval_storecontent];
        CGFloat storeContentH = [storeContentStr boundingRectWithSize:CGSizeMake(KScr_W-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil].size.height;
        
        height += storeContentH+5;
    }
    return height + 5;
    
}

- (void)setShangpinModel:(ShangpinEvaluationModel *)shangpinModel
{
    _shangpinModel = shangpinModel;
    
    _titleLabel.text = (shangpinModel.geval_frommembername.length == 0 || shangpinModel.geval_frommembername == nil) ? @"匿名" :  [NSString stringWithFormat:@"%@", shangpinModel.geval_frommembername];
    _timeLabel.text = shangpinModel.geval_addtime;

    
    NSString *detailStr = [NSString stringWithFormat:@"%@", shangpinModel.geval_content];
    CGFloat detailH = [detailStr boundingRectWithSize:CGSizeMake(KScr_W-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil].size.height;
    _detailLabel.frame = CGRectMake(10, 40, KScr_W-20, detailH);
    _detailLabel.text = shangpinModel.geval_content;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_detailLabel.frame)+5, 40, 20)];
    label.font = [UIFont systemFontOfSize:Text_Normal];
    label.textColor = [UIColor orangeColor];
    label.text = @"评价:";
    [self.contentView addSubview:label];
    
    _stareView.frame = CGRectMake(50, CGRectGetMaxY(_detailLabel.frame)+5, 100, 20);
    [_stareView setStar:[shangpinModel.geval_scores floatValue]];
    
    if (shangpinModel.geval_storecontent.length > 0 && shangpinModel.geval_storecontent != nil)
    {
        _answerLabel.frame = CGRectMake(20, CGRectGetMaxY(_stareView.frame)+5, 70, 20);
        _answerLabel.text = @"卖家回复:";
        _answerLabel.font = [UIFont systemFontOfSize:Text_Normal];
        NSString *storeContentStr = [NSString stringWithFormat:@"%@", shangpinModel.geval_storecontent];
        CGFloat storeContentH = [storeContentStr boundingRectWithSize:CGSizeMake(KScr_W-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil].size.height;
        _storeContent.frame = CGRectMake(90, CGRectGetMaxY(_stareView.frame)+5, KScr_W-100, storeContentH);
        _storeContent.text = storeContentStr;
    }
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

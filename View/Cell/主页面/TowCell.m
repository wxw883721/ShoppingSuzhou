//
//  TowCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "TowCell.h"
#import "LHFirstPageModel.h"
#import "UIColor+extend.h"

@interface TowCell ()

@end


@implementation TowCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        self.backgroundColor = [UIColor hexChangeFloat:@"e2e2e2"];
        
        //特殊活动
//        _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.4-1, 210)];
         _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.4-1, 30+20+ KScr_W*0.3-20+5+60-1+10)];
        
        _view1.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view1];
        
//        UIImageView *actionImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 100, 35)];
//        [actionImage setImage:[UIImage imageNamed:@"tp1"]];
//        [_view1 addSubview:actionImage];
        
        _actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 30)];
        [_view1 addSubview:_actionLabel];
        
        _actionTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, SCREEN_WIDTH*0.4-10, 20)];
        _actionTitle.font = [UIFont systemFontOfSize:Text_Small];
        _actionTitle.textColor = [UIColor grayColor];
        [_view1 addSubview:_actionTitle];
        
        _actionView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 70, CGRectGetWidth(_actionTitle.frame), CGRectGetHeight(_view1.frame)-75)];
        [_view1 addSubview:_actionView];
        
        //活动一
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_view1.frame)+1, 0, SCREEN_WIDTH*0.3-1,30-1+20+ KScr_W*0.3-20+5+10)];
        _view2.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view2];
        
        //字
        _gods1Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 30)];
        [_view2 addSubview:_gods1Label];
        
        _gods1Title = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_gods1Label.frame), SCREEN_WIDTH*0.3-10, 20)];
        _gods1Title.font = [UIFont systemFontOfSize:Text_Small];
        _gods1Title.textColor = [UIColor grayColor];
        [_view2 addSubview:_gods1Title];
        
        _gods1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_gods1Title.frame), CGRectGetMaxY(_gods1Title.frame), CGRectGetWidth(_gods1Title.frame), CGRectGetWidth(_gods1Title.frame))];
        [_view2 addSubview:_gods1];
        
        //活动二
        _view3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_view2.frame)+1, 0, SCREEN_WIDTH*0.3, 30-1+20+ KScr_W*0.3-20+5+10)];
        _view3.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view3];
        
        _gods2Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 30)];
        [_view3 addSubview:_gods2Label];
        
        _gods2Title = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_gods2Label.frame), CGRectGetWidth(_view3.frame)-10, 20)];
        _gods2Title.font = [UIFont systemFontOfSize:Text_Small];
        _gods2Title.textColor = [UIColor grayColor];
        [_view3 addSubview:_gods2Title];
        
        _gods2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_gods2Title.frame), CGRectGetWidth(_gods2Title.frame), CGRectGetWidth(_gods2Title.frame))];
        [_view3 addSubview:_gods2];
        
        //活动三

        _view4 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_view2.frame), CGRectGetMaxY(_view2.frame)+1, SCREEN_WIDTH*0.6, 60-1)];
        _view4.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view4];
        
        _gods3Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 90, 40)];
        [_view4 addSubview:_gods3Label];
        
        _god3Title = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_gods3Label.frame)-5, SCREEN_WIDTH*0.3, 20)];
        _god3Title.font = [UIFont systemFontOfSize:Text_Small];
        _god3Title.textColor = [UIColor grayColor];
        [_view4 addSubview:_god3Title];
        
        _gods3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_god3Title.frame), 10, 80, 45)];
        [_view4 addSubview:_gods3];
        
        
        //新闻区
        _view5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame)+1, SCREEN_WIDTH, 44)];
        _view5.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view5];
        
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.4, 44)];
        image.image = [UIImage imageNamed:@"xwtt"];
        [_view5 addSubview:image];
        
        _backView = [[UIView alloc] initWithFrame:_view5.frame];
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];
        
        
    }
    return self;
}


- (void)setActArray:(NSArray *)actArray {
    _actArray = actArray;

    if (actArray.count >=3)
    {
        LHFirstPageModel *model1 = actArray[0];
        LHFirstPageModel *model2 = actArray[1];
        LHFirstPageModel *model3 = actArray[2];
        
        
        [_gods1 sd_setImageWithURL:[NSURL URLWithString:model1.img] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
        _gods1Title.text = model1.title;
        
        
        [_gods2 sd_setImageWithURL:[NSURL URLWithString:model2.img] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
        _gods2Title.text = model2.title;
        
        [_gods3 sd_setImageWithURL:[NSURL URLWithString:model3.img] placeholderImage:[UIImage imageNamed:@"200-200.png"]];
        _god3Title.text = model3.title;
    }
    
}

- (void)setActmodeArray:(NSArray *)actmodeArray
{
    _actmodeArray = actmodeArray;
    
    if (actmodeArray.count >= 4)
    {
        _actionLabel.text = _actmodeArray[0][@"act_name"];
        _actionLabel.font = [UIFont boldSystemFontOfSize:20];
        
        NSString *textColor0 = _actmodeArray[0][@"act_color"];
        _actionLabel.textColor = [UIColor hexChangeFloat:[textColor0 substringFromIndex:1]];
        
        NSString *textColor1 = _actmodeArray[1][@"act_color"];
        _gods1Label.text = _actmodeArray[1][@"act_name"];
        _gods1Label.font = [UIFont boldSystemFontOfSize:20];
        _gods1Label.textColor = [UIColor hexChangeFloat:[textColor1 substringFromIndex:1]];
        
        NSString *textColor2 = _actmodeArray[2][@"act_color"];
        _gods2Label.text = _actmodeArray[2][@"act_name"];
        _gods2Label.font = [UIFont boldSystemFontOfSize:20];
        _gods2Label.textColor = [UIColor hexChangeFloat:[textColor2 substringFromIndex:1]];
        
        NSString *textColor3 = _actmodeArray[3][@"act_color"];
        _gods3Label.text = _actmodeArray[3][@"act_name"];
        _gods3Label.font = [UIFont boldSystemFontOfSize:20];
        _gods3Label.textColor = [UIColor hexChangeFloat:[textColor3 substringFromIndex:1]];
    }
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

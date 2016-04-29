//
//  OneCell.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "OneCell.h"

@implementation OneCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        NSArray *titleArr = @[@"商品",@"商户",@"活动专区",@"精选商户"];
        for (int i = 0; i < 4; i ++)
        {
            CGRect frame = CGRectMake((SCREEN_WIDTH-240)/5*(i+1)+60*i,15,60,60);
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x-10,70,frame.size.width+20,30)];
            label.font = [UIFont systemFontOfSize:Text_Small];
            label.textAlignment  = NSTextAlignmentCenter;
            label.text = titleArr[i];
            [self.contentView addSubview:label];
        }
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

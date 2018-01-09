//
//  CarflowCell.m
//  dssp
//
//  Created by qinbo on 2017/12/22.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarflowCell.h"
#import <YYCategoriesSub/YYCategories.h>
@implementation CarflowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
        
    }
    return self;
}

-(void)createUI
{
    self.whiteView=({
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        [self.contentView addSubview:whiteView];
        [whiteView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(1);
            make.left.equalTo(15*WidthCoefficient);
            make.right.equalTo(0);
            make.bottom.equalTo(1 - 1 * HeightCoefficient);
        }];
        whiteView;
    });
    
    
    self.toplab=({
        UILabel *lab=[[UILabel alloc] init];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font=[UIFont fontWithName:FontName size:16];
        [self.contentView addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(22 * HeightCoefficient);
            make.width.equalTo(211 * WidthCoefficient);
            make.left.equalTo(15 * WidthCoefficient);
        }];
        lab;
    });
    
    
    
    self.bottolab=({
        UILabel *lab=[[UILabel alloc] init];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor=[UIColor colorWithHexString:@"##666666"];
        lab.font=[UIFont fontWithName:FontName size:12];
        [self.contentView addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_toplab.bottom).offset(2.5 * HeightCoefficient);
            make.height.equalTo(16.5 * HeightCoefficient);
            make.width.equalTo(211 * WidthCoefficient);
            make.left.equalTo(15 * WidthCoefficient);
        }];
        lab;
    });
    
    
    self.rightlab=({
        UILabel *lab=[[UILabel alloc] init];
        lab.textColor=[UIColor colorWithHexString:@"##666666"];
        lab.textAlignment = NSTextAlignmentRight;
        lab.font=[UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [self.contentView addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(22 * HeightCoefficient);
            make.width.equalTo(83 * WidthCoefficient);
            make.right.equalTo(-15 * WidthCoefficient);
        }];
        lab;
    });
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

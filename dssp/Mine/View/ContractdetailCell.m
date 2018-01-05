//
//  ContractdetailCellTableViewCell.m
//  dssp
//
//  Created by qinbo on 2018/1/3.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "ContractdetailCell.h"
#import <YYCategoriesSub/YYCategories.h>
@implementation ContractdetailCell

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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

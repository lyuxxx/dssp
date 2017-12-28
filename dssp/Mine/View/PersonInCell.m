//
//  PersonInCellTableViewCell.m
//  dssp
//
//  Created by qinbo on 2017/12/26.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "PersonInCell.h"
#import <YYCategoriesSub/YYCategories.h>
@implementation PersonInCell

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
            //            make.top.equalTo(43 * HeightCoefficient);
            //            make.centerY.equalTo(self.contentView);
            make.height.equalTo(1 *HeightCoefficient);
            make.left.equalTo(16*WidthCoefficient);
            make.right.equalTo(0);
            make.bottom.equalTo(1 - 1 * HeightCoefficient);
        }];
        whiteView;
    });
    
   
    
    self.arrowImg=({
        UIImageView *img = [[UIImageView alloc] init];
        [self.contentView addSubview:img];
        //    _img.image=[UIImage imageNamed:data[0]];
        [img makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(14.15 * HeightCoefficient);
            make.width.equalTo(14.15 * WidthCoefficient);
            make.right.equalTo(-15.35 * WidthCoefficient);
        }];
        
        img;
    });
    
    
    self.img=({
        UIImageView *img = [[UIImageView alloc] init];
        [self.contentView addSubview:img];
        img.clipsToBounds=YES;
        img.layer.cornerRadius=32 * WidthCoefficient/2;

        [img setContentMode:UIViewContentModeScaleAspectFit];
        //    _img.image=[UIImage imageNamed:data[0]];
        [img makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(32 * WidthCoefficient);
            make.width.equalTo(32 * WidthCoefficient);
            make.right.equalTo(_arrowImg.left).offset(-10.5*WidthCoefficient);
        }];
        
        img;
    });
    
    
    self.lab=({
  
        UILabel *lab=[[UILabel alloc] init];
        lab.font=[UIFont fontWithName:FontName size:16];
        lab.textColor =[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(11 * HeightCoefficient);
            make.height.equalTo(22 * HeightCoefficient);
            make.width.equalTo(211 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
            make.centerY.equalTo(self.contentView);
        }];
        lab;
    });
    
    
    self.realName=({
        
        UILabel *RealNamelab = [[UILabel alloc] init];
        RealNamelab.font = [UIFont fontWithName:FontName size:12];
        RealNamelab.textColor = [UIColor colorWithHexString:@"#999999"];
        RealNamelab.textAlignment = NSTextAlignmentRight;
        //        RealNamelab.text = NSLocalizedString(@"未实名", nil);
        [self.contentView addSubview:RealNamelab];
        [RealNamelab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(18 * HeightCoefficient);
            make.width.equalTo(90 * WidthCoefficient);
            make.right.equalTo(_arrowImg.left).offset(-10.5*WidthCoefficient);
        }];
        RealNamelab;
    });
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

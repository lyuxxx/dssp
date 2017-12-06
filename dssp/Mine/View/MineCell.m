//
//  MineCell.m
//  dssp
//
//  Created by qinbo on 2017/11/15.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MineCell.h"
#import <YYCategoriesSub/YYCategories.h>
@implementation MineCell

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
        whiteView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self.contentView addSubview:whiteView];
        [whiteView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(43 * HeightCoefficient);
//            make.centerY.equalTo(self.contentView);
            make.height.equalTo(1);
            make.left.equalTo(59*WidthCoefficient);
            make.right.equalTo(-0);
            make.bottom.equalTo(1 - 1 * HeightCoefficient);
        }];
        whiteView;
    });
    
     self.img=({
        UIImageView *img = [[UIImageView alloc] init];
        [self.contentView addSubview:img];
        [img setContentMode:UIViewContentModeScaleAspectFit];
        //    _img.image=[UIImage imageNamed:data[0]];
        [img makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(11 * HeightCoefficient);
            make.height.equalTo(22 * HeightCoefficient);
            make.width.equalTo(22 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
        }];
        
        img;
    });
    
    self.arrowImg=({
        UIImageView *img = [[UIImageView alloc] init];
        [self.contentView addSubview:img];
        //    _img.image=[UIImage imageNamed:data[0]];
        [img makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(16 * HeightCoefficient);
            make.height.equalTo(14.15 * HeightCoefficient);
            make.width.equalTo(14.15 * WidthCoefficient);
            make.right.equalTo(-15.35 * WidthCoefficient);
        }];
        
        img;
    });
    
    self.lab=({
    UILabel *lab=[[UILabel alloc] init];
        lab.font=[UIFont fontWithName:FontName size:16];
        [self.contentView addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(11 * HeightCoefficient);
            make.height.equalTo(22 * HeightCoefficient);
            make.width.equalTo(211 * WidthCoefficient);
            make.left.equalTo(59 * WidthCoefficient);
        }];
        lab;
    });
    
    
    self.realName=({
        
      UILabel *RealNamelab = [[UILabel alloc] init];
        RealNamelab.font = [UIFont fontWithName:FontName size:12];
        RealNamelab.textColor = [UIColor colorWithHexString:@"#AC0042"];
        RealNamelab.textAlignment = NSTextAlignmentRight;
//        RealNamelab.text = NSLocalizedString(@"未实名", nil);
        [self.contentView addSubview:RealNamelab];
        [RealNamelab makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(11 * HeightCoefficient);
                    make.height.equalTo(22 * HeightCoefficient);
                    make.width.equalTo(90 * WidthCoefficient);
                    make.right.equalTo(-40 * WidthCoefficient);
                }];
        RealNamelab;
     });
    
    
    
}

//- (void)configUI
//{
//
////    NSArray *array=_dataArray[indexPath.row];
//    _img.image=[UIImage imageNamed:data[0]];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

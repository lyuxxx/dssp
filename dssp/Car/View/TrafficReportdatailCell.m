//
//  TrafficReportdatailCell.m
//  dssp
//
//  Created by qinbo on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrafficReportdatailCell.h"

@implementation TrafficReportdatailCell


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
        whiteView.layer.cornerRadius = 2;
        whiteView.layer.masksToBounds = YES;
        whiteView.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
        [self.contentView addSubview:whiteView];
        [whiteView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(44 *HeightCoefficient);
            make.left.equalTo(62*WidthCoefficient);
            make.width.equalTo(297 *WidthCoefficient);
            
        }];
        whiteView;
    });
    
    
    UIView *whiteView = [[UIView alloc] init];
//    whiteView.layer.cornerRadius = 2;
//    whiteView.layer.masksToBounds = YES;
    whiteView.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
    [self.contentView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.left.equalTo(62*WidthCoefficient);
         make.width.equalTo(297*WidthCoefficient);
       
        make.bottom.equalTo(1 - 1 * HeightCoefficient);
        
    }];
    
    self.img=({
        UIImageView *ImgV = [[UIImageView alloc] init];
        //    ImgV.image = [UIImage imageNamed:@"backgroud_mine"];
        [_whiteView addSubview:ImgV];
        [ImgV makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(16*HeightCoefficient);
            make.width.equalTo(16*HeightCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.centerY.equalTo(0);
            
        }];
        ImgV;
    });
    
//    self.leftlab=({
        self.leftlab=[[UILabel alloc] init];
        //        lab.text = @"123456";
        _leftlab.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
//        _leftlab.backgroundColor=[UIColor redColor];
        _leftlab.textAlignment = NSTextAlignmentLeft;
        [_leftlab setNumberOfLines:0];
        _leftlab.font=[UIFont fontWithName:FontName size:14];
        [_whiteView addSubview:_leftlab];
        [_leftlab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(40 * HeightCoefficient);
            make.width.equalTo(227 * WidthCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
        }];

    
     self.rightlab=({
        UILabel *lab=[[UILabel alloc] init];
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentRight;
        lab.font=[UIFont fontWithName:FontName size:14];
        [_whiteView addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(20 * HeightCoefficient);
            make.width.equalTo(100 * WidthCoefficient);
            make.right.equalTo(-10 * WidthCoefficient);
        }];
        lab;
    });
    
}

-(void)setRecordItem:(RecordItem *)recordItem
{
    self.leftlab.text = recordItem.jdaName;

    if (recordItem.jdaName) {
        [self.leftlab updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo([self setcellHight:(NSString *)recordItem.jdaName]);
            
        }];
    }
    NSString *alertCount = [[NSString stringWithFormat:@"%@",recordItem.alertCount] stringByAppendingString:@"次"];
    self.rightlab.text = alertCount?alertCount:@"0次";
}


-(CGFloat)setcellHight:(NSString *)cellModel
{
    CGRect tmpRect= [cellModel boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    
    CGFloat contentH = tmpRect.size.height + 11*HeightCoefficient;
    NSLog(@"显示高度:%f",contentH);
    
    
    return contentH;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

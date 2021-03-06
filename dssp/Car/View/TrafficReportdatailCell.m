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
        whiteView.layer.cornerRadius = 1;
        whiteView.layer.masksToBounds = YES;
        whiteView.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
        [self.contentView addSubview:whiteView];
        [whiteView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(41 *HeightCoefficient);
            make.left.equalTo(62*WidthCoefficient);
            make.width.equalTo(297 *WidthCoefficient);
            
        }];
        whiteView;
    });
    
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
    [self.contentView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1 *HeightCoefficient);
        make.left.equalTo(62*WidthCoefficient);
        make.width.equalTo(297*WidthCoefficient);
        make.bottom.equalTo(1-1*HeightCoefficient);

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
    
    self.leftlab=({
        UILabel *lab=[[UILabel alloc] init];
        //        lab.text = @"123456";
        lab.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
//        lab.backgroundColor=[UIColor redColor];
        lab.textAlignment = NSTextAlignmentLeft;
        [lab setNumberOfLines:0];
        lab.font=[UIFont fontWithName:FontName size:14];
        [_whiteView addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(40 * HeightCoefficient);
            make.width.equalTo(200 * WidthCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
        }];
        lab;
    });

    
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
    
    
    self.rightimg=({
        UIImageView *ImgV = [[UIImageView alloc] init];
        //    ImgV.image = [UIImage imageNamed:@"backgroud_mine"];
        [_whiteView addSubview:ImgV];
        [ImgV makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(15 * HeightCoefficient);
            make.width.equalTo(42 * WidthCoefficient);
            make.right.equalTo(-40 *WidthCoefficient);
            
        }];
    
        ImgV;
    });
    
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

-(void)setRecordItem:(RecordItems *)recordItem
{
    self.leftlab.text = recordItem.jdaName;

    if (recordItem.jdaName) {
        [self.leftlab updateConstraints:^(MASConstraintMaker *make) {

            make.height.equalTo([self setcellHight:recordItem.jdaName]);
            make.centerY.equalTo(0);

        }];
        [self.whiteView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo([self setcellHight:recordItem.jdaName]-1);
         
            
        }];
    }
    
    if([recordItem.alertPriority isEqualToString:@"low"])
    {
//        _rightlab1.hidden = NO;
//        _rightlab1.backgroundColor=[UIColor colorWithHexString:@"#FFD9A5"];
//        _rightlab1.textColor=[UIColor colorWithHexString:@"#ffffff"];
//        _rightlab1.text =@"低级";
      
        _rightimg.image = [UIImage imageNamed:@"低风险"];
        
    }
    else if([recordItem.alertPriority isEqualToString:@"high"])
    {
        
//        _rightlab1.hidden = NO;
//        _rightlab1.backgroundColor=[UIColor colorWithHexString:@"#DE0055"];
//        _rightlab1.textColor=[UIColor colorWithHexString:@"#ffffff"];
//        _rightlab1.text =@"高级";
      
         _rightimg.image = [UIImage imageNamed:@"高风险"];
    }
    else
    {
        
         _rightimg.image = [UIImage imageNamed:@"健康"];
    }
    
    
//    NSString *alertCount = [[NSString stringWithFormat:@"%@",recordItem.alertCount] stringByAppendingString:@"次"];
//    self.rightlab.text = alertCount?alertCount:@"0次";
}

-(CGFloat)setcellHight:(NSString *)cellModel
{
    CGRect tmpRect= [cellModel boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];

    CGFloat contentH = tmpRect.size.height + 28*HeightCoefficient;
//    NSLog(@"显示高度:%f",contentH);
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

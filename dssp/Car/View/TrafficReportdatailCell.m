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
        
        
//        CALayer *topLayer = [CALayer layer];
//        //設定邊線的顏色
//        topLayer.backgroundColor = [[UIColor redColor] CGColor];
//
//        //設定邊線的大小
//        CGFloat borderSize = 3.0;
//        //指定邊線位置在view的上方，為了不擋住view所以y值調整成-borderSize
//        topLayer.frame = CGRectMake(0, -3, whiteView.bounds.size.width, borderSize);
//
//        [whiteView.layer addSublayer:topLayer];
//
//
//        CALayer *bottomLayer = [CALayer layer];
//        bottomLayer.backgroundColor = [[UIColor redColor] CGColor];
//        //指定邊線位置在view的下方
//        bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(whiteView.bounds), whiteView.bounds.size.width, borderSize);
//
//        [whiteView.layer addSublayer:bottomLayer];
//         whiteView.backgroundColor = [UIColor whiteColor];
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



//    whiteView setBorderWithView
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
    
    self.leftlab=({
        UILabel *lab=[[UILabel alloc] init];
        //        lab.text = @"123456";
        lab.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
//        _leftlab.backgroundColor=[UIColor redColor];
        lab.textAlignment = NSTextAlignmentLeft;
        [lab setNumberOfLines:0];
        lab.font=[UIFont fontWithName:FontName size:14];
        [_whiteView addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.equalTo(40 * HeightCoefficient);
            make.width.equalTo(227 * WidthCoefficient);
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

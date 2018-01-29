//
//  LllegaCell.m
//  dssp
//
//  Created by qinbo on 2018/1/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "LllegaCell.h"

@implementation LllegaCell

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
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.multipleSelectionBackgroundView = [UIView new];
    
    self.white = ({
        UIView *whiteV = [[UIView alloc] init];
        whiteV.backgroundColor = [UIColor whiteColor];
        whiteV.layer.cornerRadius = 4;
        whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
        whiteV.layer.shadowOffset = CGSizeMake(0, 5);
        whiteV.layer.shadowRadius = 7;
        whiteV.layer.shadowOpacity = 0.5;
        [self.contentView addSubview:whiteV];
        [whiteV makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(10 * WidthCoefficient, 8 * WidthCoefficient, 0 * WidthCoefficient, 8 * WidthCoefficient));
            make.height.equalTo(100 * WidthCoefficient);
            
        }];
        
        whiteV;
    });
    
//    @property (nonnull,strong)UILabel *topLabel;
//    @property (nonnull,strong)UILabel *centerLabel;
//    @property (nonnull,strong)UILabel *bottomLabel;
//    @property (nonnull,strong)UILabel *rightLabel;
    
    self.topLabel = [[UILabel alloc] init];
    _topLabel.textAlignment = NSTextAlignmentLeft;
    _topLabel.textColor = [UIColor colorWithHexString:@"##333333"];
    _topLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//    _topLabel.text = NSLocalizedString(@"创红的", nil);
    [_white addSubview:_topLabel];
    [_topLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    self.centerLabel = [[UILabel alloc] init];
    _centerLabel.textAlignment = NSTextAlignmentLeft;
    _centerLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _centerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _centerLabel.text = NSLocalizedString(@"位置：武汉市1234556677", nil);
    [_white addSubview:_centerLabel];
    [_centerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(18.5 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
        make.top.equalTo(_topLabel.bottom).offset(5*HeightCoefficient);
    }];
    
    self.bottomLabel = [[UILabel alloc] init];
    [_bottomLabel setNumberOfLines:0];
    _bottomLabel.textAlignment = NSTextAlignmentLeft;
    _bottomLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _bottomLabel.text = NSLocalizedString(@"时间：2019.12.12", nil);
    [_white addSubview:_bottomLabel];
    [_bottomLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(18.5 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
        make.top.equalTo(_centerLabel.bottom).offset(5*HeightCoefficient);
    }];
    
//    self.rightLabel = [[UILabel alloc] init];
//    [_rightLabel setNumberOfLines:0];
//    _rightLabel.textAlignment = NSTextAlignmentLeft;
//    _rightLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
//    _rightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    _rightLabel.text = NSLocalizedString(@"未处理", nil);
//    [_white addSubview:_rightLabel];
//    [_rightLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(42 * WidthCoefficient);
//        make.height.equalTo(22 * HeightCoefficient);
//        make.right.equalTo(-10 * WidthCoefficient);
//        make.top.equalTo(10 * HeightCoefficient);
//    }];
    

}

-(void)setLllegaModel:(LllegaModel *)lllegaModel
{
      NSString *address = [@"位置：" stringByAppendingString:[NSString stringWithFormat:@"%@",lllegaModel.address]];
    
     NSString *time = [@"时间：" stringByAppendingString:[NSString stringWithFormat:@"%@",lllegaModel.time]];
    
    
     _topLabel.text = NSLocalizedString(lllegaModel.violationType, nil);
    _centerLabel.text = NSLocalizedString(address, nil);
     _bottomLabel.text = NSLocalizedString(time, nil);
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

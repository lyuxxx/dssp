//
//  ContractCell.m
//  dssp
//
//  Created by qinbo on 2017/12/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ContractCell.h"
#import <YYCategoriesSub/YYCategories.h>
@implementation ContractCell

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
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 7.5);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(200 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(0 * HeightCoefficient);
    }];
    
    
    UIButton *testdriveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    testdriveBtn.layer.cornerRadius = 20 * HeightCoefficient/2;
    [testdriveBtn setTitle:NSLocalizedString(@"试驾", nil) forState:UIControlStateNormal];
    [testdriveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    testdriveBtn.titleLabel.font = [UIFont fontWithName:FontName size:14];
    [testdriveBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [whiteV addSubview:testdriveBtn];
    [testdriveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
        make.right.equalTo(whiteV.right).offset(-10 * HeightCoefficient);
    }];
    
    UILabel *serialNumber = [[UILabel alloc] init];
    serialNumber.textAlignment = NSTextAlignmentLeft;
    serialNumber.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    serialNumber.text = NSLocalizedString(@"合同编号001", nil);
    [whiteV addSubview:serialNumber];
    [serialNumber makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    NSArray<NSString *> *titles = @[
                                  
                                    NSLocalizedString(@"开始时间:", nil),
                                    NSLocalizedString(@"结束时间:", nil),
                                    NSLocalizedString(@"支付方式:", nil),
                                    NSLocalizedString(@"支付时间:", nil),
                                    NSLocalizedString(@"支付金额:", nil)

                                    ];

    
    UILabel *lastLabel = nil;
    UIView *lastView =nil;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont fontWithName:FontName size:14];
        [whiteV addSubview:label];
        
        UIView *whiteV = [[UIView alloc] init];
//        whiteV.backgroundColor = [UIColor redColor];
        [self addSubview:whiteV];
       
        if (i == 0) {
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(71.5 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(10*WidthCoefficient);
                make.top.equalTo(serialNumber.bottom).offset(10*HeightCoefficient);
                
            }];

            [whiteV makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(150 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(label.right).offset(0*WidthCoefficient);make.top.equalTo(serialNumber.bottom).offset(10*HeightCoefficient);
            }];
            
        } else {
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(71.5 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(10 * WidthCoefficient);
                make.top.equalTo(lastLabel.bottom).offset(10 * HeightCoefficient);
            }];
            
            
            [whiteV makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(150 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(label.right).offset(0*WidthCoefficient);
                make.top.equalTo(lastView.bottom).offset(10*HeightCoefficient);
            }];
        }
        lastLabel = label;
        lastView =whiteV;
        
        
        
        if (i == 0) {
            self.startLabel=({
            UILabel *startLabel = [[UILabel alloc] init];
//            startLabel.text = @"2017/12/31";
            startLabel.textAlignment = NSTextAlignmentLeft;
            startLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            startLabel.font = [UIFont fontWithName:FontName size:14];
            [whiteV addSubview:startLabel];
            [startLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(185 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(0 * WidthCoefficient);
                make.top.equalTo(0);
            }];
                  startLabel;
              });
            
           
        } else if (i == 1) {
            
            self.endLabel=({
            UILabel *endLabel = [[UILabel alloc] init];
//            endLabel.text = @"2018/12/31";
            endLabel.textAlignment = NSTextAlignmentLeft;
            endLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            endLabel.font = [UIFont fontWithName:FontName size:14];
            [whiteV addSubview:endLabel];
            [endLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(185 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(0 * WidthCoefficient);
                make.top.equalTo(0);
            }];
                endLabel;
            });
            
        } else if (i == 2) {
            self.modeLabel=({
                UILabel *modeLabel = [[UILabel alloc] init];
//                modeLabel.text = @"2018/12/31";
                modeLabel.textAlignment = NSTextAlignmentLeft;
                modeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
                modeLabel.font = [UIFont fontWithName:FontName size:14];
                [whiteV addSubview:modeLabel];
                [modeLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0);
                }];
                modeLabel;
            });
            
        }
        else if (i == 3) {
            
            self.paymentLabel=({
            UILabel *paymentLabel = [[UILabel alloc] init];
//            paymentLabel.text = @"2018/12/31 13:22:22";
            paymentLabel.textAlignment = NSTextAlignmentLeft;
            paymentLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            paymentLabel.font = [UIFont fontWithName:FontName size:14];
            [whiteV addSubview:paymentLabel];
            [paymentLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(185 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(0 * WidthCoefficient);
                make.top.equalTo(0);
            }];
                paymentLabel;
            });
            
        }else if (i == 4) {
            
            
            self.moneyLabel=({
               UILabel *moneyLabel = [[UILabel alloc] init];
                //            _moneyLabel.text = @"¥300";
                moneyLabel.textAlignment = NSTextAlignmentLeft;
                moneyLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
                moneyLabel.font = [UIFont fontWithName:FontName size:15];
                [whiteV addSubview:moneyLabel];
                [moneyLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(185 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0);
                    make.top.equalTo(0);
                }];
                moneyLabel;
            });
        }
    }
}


-(void)setContractModel:(ContractModel *)contractModel
{
    _startLabel.text = contractModel.contractBeginTime;
    _endLabel.text = contractModel.contractEndTime;
    _modeLabel.text = [contractModel.payMode isEqualToString:@"1"]?NSLocalizedString(@"分期付款", nil):NSLocalizedString(@"一次性付款", nil);
    _paymentLabel.text = contractModel.payDate;
    _moneyLabel.text = contractModel.contractMoney;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  LllegadetailController.m
//  dssp
//
//  Created by qinbo on 2018/1/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "LllegadetailController.h"

@interface LllegadetailController ()
@property (nonatomic,strong) UIScrollView *sc;
@property (nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,strong) UILabel *placeLabel;
@property (nonatomic,strong) UILabel *vinLabel;
@property (nonatomic,strong) UILabel *officeLabel;
@property (nonatomic,strong) UILabel *fineLabel;
@property (nonatomic,strong) UILabel *HandleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *behaviorLabel;
@property (nonatomic,strong) UILabel *penaltyLabel;
@end

@implementation LllegadetailController

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    [self setupUI];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"违章详细", nil);
    
    UIView *whiteV = [[UIView alloc] init];
//    whiteV.layer.cornerRadius = 4;
//    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
//    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteV.layer.shadowRadius = 7;
//    whiteV.layer.shadowOpacity = 0.5;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 *WidthCoefficient);
        make.height.equalTo(427.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20.5 * HeightCoefficient);
        make.bottom.equalTo(self.view.bottom).offset(-77 * HeightCoefficient - kBottomHeight);
        
    }];
    
//    UILabel *query = [[UILabel alloc] init];
//    query.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//    query.textAlignment = NSTextAlignmentCenter;
//    query.text = NSLocalizedString(@"详细记录", nil);
//    [whiteV addSubview:query];
//    [query makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(whiteV);
//        make.width.equalTo(170 * WidthCoefficient);
//        make.height.equalTo(22.5 * HeightCoefficient);
//        make.top.equalTo(20 * HeightCoefficient);
//    }];
    
    NSArray<NSString *> *titles = @[
                                    
                                    NSLocalizedString(@"违章地点", nil),
                                    NSLocalizedString(@"车架号", nil),
                                    NSLocalizedString(@"采集机关", nil),
                                    NSLocalizedString(@"罚款", nil),
                                    NSLocalizedString(@"是否处理", nil),
                                    NSLocalizedString(@"违章时间", nil),
                                    NSLocalizedString(@"违章行为", nil),
                                    NSLocalizedString(@"罚分", nil)
                                    ];
    
    self.sc = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [whiteV addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(whiteV).offset(UIEdgeInsetsMake(10 * HeightCoefficient, 0, 10 * HeightCoefficient, 0));
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.width.equalTo(whiteV.width);
        }];
        
        UILabel *lastLabel = nil;
        UIView *lastView = nil;
        
        for (NSInteger i = 0 ; i < titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = titles[i];
//              label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor colorWithHexString:@"#A18E79"];
            label.font = [UIFont fontWithName:FontName size:15];
            [contentView addSubview:label];
            
            
            UIView *whiteV = [[UIView alloc] init];
//            whiteV.backgroundColor = [UIColor redColor];
            [contentView addSubview:whiteV];
            
            UIView *whiteView = [[UIView alloc] init];
            whiteView.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
            [contentView addSubview:whiteView];
            
            
            CGRect tmpRect= [_lllegaModel.address boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} context:nil];
            
//            CGFloat contentW = 223 * WidthCoefficient;
//            //label的字体 HelveticaNeue  Courier
//            UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
//            //                    _placeLabel.font = fnt;
//            // iOS7中用以下方法替代过时的iOS6中的sizeWithFont:constrainedToSize:lineBreakMode:方法
//            CGRect tmpRect = [_lllegaModel.address boundingRectWithSize:CGSizeMake(contentW, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
//            // 高度H
            CGFloat contentH = tmpRect.size.height;
//            NSLog(@"调整后的显示宽度:%f,显示高度:%f",contentW,contentH);
         
            CGFloat contentW1 = 223 * WidthCoefficient;
            //label的字体 HelveticaNeue  Courier
            UIFont *fnt1 = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
            //                    _placeLabel.font = fnt;
            // iOS7中用以下方法替代过时的iOS6中的sizeWithFont:constrainedToSize:lineBreakMode:方法
            CGRect tmpRect1 = [_lllegaModel.violationType boundingRectWithSize:CGSizeMake(contentW1, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt1,NSFontAttributeName, nil] context:nil];
            // 高度H
            CGFloat contentH1 = tmpRect1.size.height;
            NSLog(@"调整后的显示宽度:%f,显示高度:%f",contentW1,contentH1);
            
            if (i == 0) {
                
                
                if (contentH>30) {
                 
                    [label makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(85 * WidthCoefficient);
                        make.height.equalTo((contentH+7) * HeightCoefficient);
                        make.left.equalTo(15*WidthCoefficient);

                        make.top.equalTo(0);
                        
                    }];
                    
                    
                    [whiteV makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(-10);
                        make.height.equalTo((contentH+7) * HeightCoefficient);
                        make.left.equalTo(label.right).offset(5*WidthCoefficient);
                        make.top.equalTo(0);
                    }];
                    
                    
                    [whiteView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo((contentH+22) * HeightCoefficient);
                        make.height.equalTo(1);
                        make.left.equalTo(15 * WidthCoefficient);
                        make.right.equalTo(-15 * WidthCoefficient);
                        
                    }];
                    
                }
                else
                {
                    
                    [label makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(85 * WidthCoefficient);
                        make.height.equalTo(21 * HeightCoefficient);
                        make.left.equalTo(15*WidthCoefficient);
                        make.top.equalTo(0);
                        
                    }];
                    
                    
                    [whiteV makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(-10);
                        make.height.equalTo(21 * HeightCoefficient);
                        make.left.equalTo(label.right).offset(5*WidthCoefficient);
                        make.top.equalTo(0);
                    }];
                    
                    
                    [whiteView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(34 * HeightCoefficient);
                        make.height.equalTo(1);
                        make.left.equalTo(15 * WidthCoefficient);
                        make.right.equalTo(-15 * WidthCoefficient);
                        
                    }];
                }
                
            } else{
                
                if(i==6)
                {
                    if (contentH1>30) {
                        
                        [label makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(85 * WidthCoefficient);
                            make.height.equalTo((contentH1+21) * HeightCoefficient);
                            make.left.equalTo(15*WidthCoefficient);
                            make.top.equalTo(lastLabel.bottom).offset(28 * HeightCoefficient);
                        }];
                        
                        
                        [whiteV makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(-10);
                            make.height.equalTo((contentH1+21) * HeightCoefficient);
                            make.left.equalTo(label.right).offset(5*WidthCoefficient);
                            make.top.equalTo(lastLabel.bottom).offset(28*HeightCoefficient);
                        }];
                        
                        [whiteView makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(lastView.bottom).offset((contentH1+50) * HeightCoefficient);
                            make.height.equalTo(1);
                            make.left.equalTo(15 * WidthCoefficient);
                            make.right.equalTo(-15 * WidthCoefficient);
                            
                        }];
                        
                    }
                    else
                    {
                        
                        [label makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(85 * WidthCoefficient);
                            make.height.equalTo(20 * HeightCoefficient);
                            make.left.equalTo(15*WidthCoefficient);
                            make.top.equalTo(lastLabel.bottom).offset(28 * HeightCoefficient);
                        }];
                        
                        [whiteV makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(-10);
                            make.height.equalTo(21 * HeightCoefficient);
                            make.left.equalTo(label.right).offset(5*WidthCoefficient);
                            make.top.equalTo(lastLabel.bottom).offset(28*HeightCoefficient);
                        }];
                        
                        [whiteView makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(lastView.bottom).offset(48 * HeightCoefficient);
                            make.height.equalTo(1);
                            make.left.equalTo(15 * WidthCoefficient);
                            make.right.equalTo(-15 * WidthCoefficient);
                            
                        }];
   
                    }
   
                }
                else
                {

                        [label makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(85 * WidthCoefficient);
                            make.height.equalTo(20 * HeightCoefficient);
                            make.left.equalTo(15*WidthCoefficient);
                            make.top.equalTo(lastLabel.bottom).offset(29 * HeightCoefficient);
                        }];
                        
                        [whiteV makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(-10);
                            make.height.equalTo(21 * HeightCoefficient);
                            make.left.equalTo(label.right).offset(5*WidthCoefficient);
                            make.top.equalTo(lastLabel.bottom).offset(28*HeightCoefficient);
                        }];
                        
                        [whiteView makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(lastView.bottom).offset(48 * HeightCoefficient);
                            make.height.equalTo(1);
                            make.left.equalTo(15 * WidthCoefficient);
                            make.right.equalTo(-15 * WidthCoefficient);
                            
                        }];
                    
                }
 
            }
            lastLabel = label;
            lastView =whiteView;
            
                self.rightLabel = [[UILabel alloc] init];
                [_rightLabel setNumberOfLines:0];
//            _rightLabel.backgroundColor = [UIColor redColor];
                _rightLabel.textAlignment = NSTextAlignmentLeft;
                _rightLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                _rightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
//                _rightLabel.text = NSLocalizedString(@"未处理", nil);
                [whiteV addSubview:_rightLabel];
                [_rightLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(223 * WidthCoefficient);
                    make.height.equalTo(21 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0);
                }];
            
                if (i == 0) {
                    _placeLabel =_rightLabel;
                    _rightLabel.text = _lllegaModel.address;
                   
                     if (contentH>30) {
                         [_rightLabel updateConstraints:^(MASConstraintMaker *make) {
                             make.top.equalTo(0);
                             make.height.equalTo((contentH +7) * HeightCoefficient);
                             
                         }];
                         
                     }else
                     {
                         [_rightLabel updateConstraints:^(MASConstraintMaker *make) {
                             make.top.equalTo(0);
                             make.height.equalTo(21* HeightCoefficient);
                             
                         }];
                         
                     }
                }
                else if (i == 1) {

                    _vinLabel =_rightLabel;
                    _rightLabel.text = _lllegaModel.vin;
                    
                }
                else if (i == 2) {
                    
                    _officeLabel =_rightLabel;
                    _rightLabel.text = _lllegaModel.agency;
                    
                }
                else if (i == 3) {
                    
                    _fineLabel =_rightLabel;
                    _rightLabel.text = _lllegaModel.fine;
                    
                }
                else if (i == 4) {
                    
                _HandleLabel =_rightLabel;
                    _rightLabel.text = [_lllegaModel.handled isEqualToString:@"0"]?@"未处理":@"已处理";
                  _rightLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
                    
                }
                else if (i == 5) {
                    
                    _timeLabel =_rightLabel;
                    _rightLabel.text = _lllegaModel.time;
                    
                }
                else if (i == 6) {
                  
                    if (contentH1>30) {
                        [_rightLabel updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(0);
                            make.height.equalTo((contentH1+21) * HeightCoefficient);
                            
                        }];

                    }else
                    {
                        [_rightLabel updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(0);
                            make.height.equalTo(21 * HeightCoefficient);
                            
                        }];

                    }
                    
                    _behaviorLabel =_rightLabel;
                    _rightLabel.text = _lllegaModel.violationType;
                    _rightLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                    
                }
                else if (i == 7) {
                      whiteView.hidden = YES;
                    _penaltyLabel =_rightLabel;
                    _rightLabel.text = _lllegaModel.point;
                    
                }
            }
           

        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastLabel.bottom).offset(20);
            
        }];
        
        scroll;
    });
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

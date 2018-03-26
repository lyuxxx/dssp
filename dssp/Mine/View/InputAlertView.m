//
//  AlertView.m
//  dssp
//
//  Created by qinbo on 2017/12/25.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "InputAlertView.h"
#import <YYCategoriesSub/YYCategories.h>
@implementation InputAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建遮罩
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackClick)];
        [self.blackView addGestureRecognizer:tap];
        [self addSubview:_blackView];
        
        
        //创建alert
        self.alertview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270*WidthCoefficient , 210 *HeightCoefficient)];
        self.alertview.center = self.center;
        self.alertview.layer.cornerRadius = 4;
        self.alertview.clipsToBounds = YES;
        self.alertview.backgroundColor = [UIColor whiteColor];
        [self addSubview:_alertview];
        [self exChangeOut:self.alertview dur:0.6];
        
        
        //        UIView *whiteView = [[UIView alloc] init];
        //        whiteView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        //        [self.alertview addSubview:whiteView];
        //        [whiteView makeConstraints:^(MASConstraintMaker *make) {
        //            make.height.equalTo(1*HeightCoefficient);
        //            make.left.right.equalTo(0);
        //            make.bottom.equalTo(-48*HeightCoefficient);
        //        }];
        //
        //
        //        UIView *whiteView1 = [[UIView alloc] init];
        //        whiteView1.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        //        [self.alertview addSubview:whiteView1];
        //        [whiteView1 makeConstraints:^(MASConstraintMaker *make) {
        //            make.height.equalTo(48*HeightCoefficient);
        //            make.width.equalTo(1*WidthCoefficient);
        //            make.centerX.equalTo(0);
        //            make.top.equalTo(whiteView.bottom).offset(0);
        //        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tipLable = [[UILabel alloc] init];
    _tipLable.textAlignment = NSTextAlignmentCenter;
    //    [_tipLable setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    //    _tipLable.backgroundColor=[UIColor blackColor];
    
    [_tipLable setFont:[UIFont fontWithName:FontName size:16]];
    //    [_tipLable setFont:[UIFont systemFontOfSize:16]];
    [_tipLable setNumberOfLines:0];
    [_tipLable setTextColor:[UIColor colorWithHexString:@"#333333"]];
    [self.alertview addSubview:_tipLable];
    if (_title) {
        _tipLable.attributedText =_title;
    }
    else
    {
        _tipLable.text = _titleStr;
    }
    
    
    switch (_type) {
            
        case 9:
            //上面是图片，下面是文字
            [self.alertview makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(270 * WidthCoefficient);
                make.height.equalTo(210 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.centerY.equalTo(0);
            }];
            
            [_tipLable makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(200 * WidthCoefficient);
                make.height.equalTo(60 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(88 * HeightCoefficient);
            }];
            [self creatViewInAlert9];
            //            [self createBtnTitle:_btnTitleArr];
            break;
            
        case 10:
            //上面是图片，下面是文字
            [self.alertview makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(270 * WidthCoefficient);
                make.height.equalTo(210 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.centerY.equalTo(0);
            }];
            
            [_tipLable makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(200 * WidthCoefficient);
                make.height.equalTo(60 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(88 * HeightCoefficient);
            }];
            [self creatViewInAlert];
            [self createBtnTitle:_btnTitleArr];
            break;
        case 11:
            //弹出输入框
            [self.alertview makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(270 * WidthCoefficient);
                make.height.equalTo(210 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.centerY.equalTo(0);
                //                make.top.equalTo((160-kNaviHeight)* HeightCoefficient+kNaviHeight);
            }];
            
            
            [_tipLable makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(200 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(19 * HeightCoefficient);
            }];
            
            [self creatinputViewAlert];
            [self createBtnTitle:_btnTitleArr];
            break;
        case 12:
            
            //其他，有需求再加
            [self creatViewWithAlert];
            [self createBtnTitle:_btnTitleArr];
            
        default:
            break;
    }
    self.alertview.center = CGPointMake(self.center.x, self.center.y);
    
}

-(void)creatViewInAlert9
{
    UIImageView *locationImg = [[UIImageView alloc] init];
//    locationImg.contentMode = UIViewContentModeScaleAspectFit;
    locationImg.image = [UIImage imageNamed:_imgStr];
    [self.alertview  addSubview:locationImg];
    [locationImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(24 * HeightCoefficient);
        make.width.equalTo(82.5 * WidthCoefficient);
        make.height.equalTo(43 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    CGFloat m = self.alertview.frame.size.width;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:_btnTitleArr[0] forState:UIControlStateNormal];
    btn.tag = 100;
    //        btn.layer.cornerRadius = 4;
    //        btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitleColor:[UIColor colorWithHexString:@"#AC0042"] forState:UIControlStateNormal];
    
    [self.alertview addSubview:btn];
    
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(48*HeightCoefficient);
        make.width.equalTo(m);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0*HeightCoefficient);
    }];
    
    
    
    
}

- (void)creatViewInAlert
{
    UIImageView *locationImg = [[UIImageView alloc] init];
    locationImg.contentMode = UIViewContentModeScaleAspectFit;
    locationImg.image = [UIImage imageNamed:_imgStr];
    [self.alertview  addSubview:locationImg];
    [locationImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(24 * HeightCoefficient);
        make.width.equalTo(82.5 * WidthCoefficient);
        make.height.equalTo(43 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
}

- (void)creatinputViewAlert
{
    self.pinField = [[UITextField alloc] init];
    _pinField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * WidthCoefficient, 22.5 * HeightCoefficient)];
    _pinField.leftViewMode = UITextFieldViewModeAlways;
    //    _vinField.textColor = [UIColor colorWithHexString:@"#040000"];
    _pinField.font = [UIFont fontWithName:FontName size:16];
    _pinField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写PIN号" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:16]}];
    _pinField.layer.cornerRadius = 2;
    _pinField.backgroundColor = [UIColor colorWithHexString:@"#eae9e9"];
    [self.alertview addSubview:_pinField];
    [_pinField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(240 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_tipLable.bottom).offset(40 * HeightCoefficient);
    }];
}


- (void)creatViewWithAlert
{
    UIImageView *locationImg = [[UIImageView alloc] init];
//    locationImg.contentMode = UIViewContentModeScaleAspectFit;
    locationImg.image = [UIImage imageNamed:_imgStr];
    [self.alertview  addSubview:locationImg];
    [locationImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0 * HeightCoefficient);
        make.width.equalTo(270 * WidthCoefficient);
        make.height.equalTo(162 * HeightCoefficient);
        make.left.equalTo(0);
    }];
    
    _tipLable = [[UILabel alloc] init];
    _tipLable.textAlignment = NSTextAlignmentCenter;
    //    [_tipLable setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    //    _tipLable.backgroundColor=[UIColor blackColor];
    
    [_tipLable setFont:[UIFont fontWithName:FontName size:16]];
    //    [_tipLable setFont:[UIFont systemFontOfSize:16]];
    [_tipLable setNumberOfLines:0];
    [_tipLable setTextColor:[UIColor colorWithHexString:@"#E2CD8D"]];
    [locationImg addSubview:_tipLable];
    if (_title) {
        _tipLable.attributedText =_title;
    }
    else
    {
        _tipLable.text = _titleStr;
    }
    [_tipLable makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(200 * WidthCoefficient);
        make.height.equalTo(60 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(33 * HeightCoefficient);
    }];
    
}


- (void)createBtnTitle:(NSArray *)titleArr
{
    CGFloat m = self.alertview.frame.size.width;
    
    if (_numBtn == 1) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titleArr[0] forState:UIControlStateNormal];
        btn.tag = 100;
        //        btn.layer.cornerRadius = 4;
        //        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        btn.backgroundColor = [UIColor colorWithHexString:@"#151111"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#AC0042"] forState:UIControlStateNormal];
        
        [self.alertview addSubview:btn];
        
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(48*HeightCoefficient);
            make.width.equalTo(m);
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(0*HeightCoefficient);
        }];
        
        //        UIView *whiteView = [[UIView alloc] init];
        //        whiteView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        //        [self.alertview addSubview:whiteView];
        //        [whiteView makeConstraints:^(MASConstraintMaker *make) {
        //            make.height.equalTo(1*HeightCoefficient);
        //            make.left.right.equalTo(0);
        //            make.bottom.equalTo(-48*HeightCoefficient);
        //        }];
        
    }
    else
    {
        for (int i=0; i<_numBtn; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.tag = 100+i;
            btn.layer.cornerRadius = 4;
            btn.clipsToBounds = YES;
            //        btn.backgroundColor =[UIColor redColor];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            if (btn.tag ==101) {
                
                [btn setTitleColor:[UIColor colorWithHexString:@"#AC0042"] forState:UIControlStateNormal];
                
            }else{
                [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            }
            [self.alertview addSubview:btn];
            
            
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(48*HeightCoefficient);
                make.width.equalTo(270 * WidthCoefficient / 2);
                make.left.equalTo(i* (270 * WidthCoefficient /2));
                make.bottom.equalTo(0*HeightCoefficient);
            }];
        }
        
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        [self.alertview addSubview:whiteView];
        [whiteView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(1*HeightCoefficient);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-48*HeightCoefficient);
        }];
        
        
        UIView *whiteView1 = [[UIView alloc] init];
        whiteView1.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        [self.alertview addSubview:whiteView1];
        [whiteView1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(48*HeightCoefficient);
            make.width.equalTo(1*WidthCoefficient);
            make.centerX.equalTo(0);
            make.top.equalTo(whiteView.bottom).offset(0);
        }];
        
        
    }
}


- (void)blackClick
{
    [self cancleView];
}


- (void)cancleView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertview = nil;
    }];
}


-(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
}


-(void)clickButton:(UIButton *)button{
    self.clickBlock(button,_pinField.text);
    [self cancleView];
}


-(void)initWithTitle:(NSString *) title img:(NSString *)img type:(NSInteger)type btnNum:(NSInteger)btnNum btntitleArr:(NSArray *)btnTitleArr
{
    _titleStr = title;
    _type = type;
    _numBtn = btnNum;
    _btnTitleArr = btnTitleArr;
    _imgStr = img;
}


-(void)initWithTitles:(NSAttributedString *) titles img:(NSString *)img type:(NSInteger)type btnNum:(NSInteger)btnNum btntitleArr:(NSArray *)btnTitleArr
{
    _title = titles;
    _type = type;
    _numBtn = btnNum;
    _btnTitleArr = btnTitleArr;
    _imgStr = img;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _password = textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end


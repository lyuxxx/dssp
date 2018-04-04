//
//  HomeBtnsHeader.m
//  dssp
//
//  Created by yxliu on 2018/3/13.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "HomeBtnsHeader.h"
#import "HomeBtn.h"
#import "NSArray+Sudoku.h"

NSString * const HomeBtnsHeaderIdentifier = @"HomeBtnsHeaderIdentifier";
typedef void(^BtnClick)(UIButton *);
@interface HomeBtnsHeader ()
@property (nonatomic, copy) BtnClick btnClick;
@end
@implementation HomeBtnsHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    
    UIView *btnContainer = [[UIView alloc] init];
    btnContainer.layer.cornerRadius = 4;
    btnContainer.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    btnContainer.layer.shadowOffset = CGSizeMake(0, 4);
    btnContainer.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    btnContainer.layer.shadowOpacity = 0.5;
    btnContainer.layer.shadowRadius = 7;
    [self.contentView addSubview:btnContainer];
    [btnContainer makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(11 * WidthCoefficient, 16 * WidthCoefficient, 10 * WidthCoefficient, 16 * WidthCoefficient));
    }];
    
    NSArray *btnImgTitles = @[
                              @"流量查询_icon",
                              @"智慧出行_icon",
                              @"商城",
                              @"违章查询_icon",
                              @"预约保养_icon"
                              ];
    NSArray *btnTitles = @[
                           @"车载流量",
                           @"智慧出行",
                           @"DS商城",
                           @"违章查询",
                           @"预约保养"
                           ];
    
    NSMutableArray<HomeBtn *> *btns = [NSMutableArray new];
    for (NSInteger i = 0; i < btnImgTitles.count; i++) {
        HomeBtn *btn = [HomeBtn buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:btnImgTitles[i]] forState:UIControlStateNormal];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:FontName size:13]];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btnContainer addSubview:btn];
        [btns addObject:btn];
    }
    
    [btns mas_distributeSudokuViewsWithFixedItemWidth:56 * WidthCoefficient fixedItemHeight:59 * WidthCoefficient warpCount:5 topSpacing:10 * WidthCoefficient bottomSpacing:10 * WidthCoefficient leadSpacing:7.5 * WidthCoefficient tailSpacing:7.5 * WidthCoefficient];
    
    UIImageView *line = [[UIImageView alloc] init];
    line.image = [UIImage imageNamed:@"bg_line"];
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(1 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(btnContainer.top).offset(-9 * WidthCoefficient);
    }];
}

- (void)btnClick:(UIButton *)sender {
    self.btnClick(sender);
}

+ (CGFloat)HeaderHeight {
    return 100 * WidthCoefficient;
}

- (void)configWithBtnClick:(void (^)(UIButton *))btnClick {
    self.btnClick = btnClick;
}

@end

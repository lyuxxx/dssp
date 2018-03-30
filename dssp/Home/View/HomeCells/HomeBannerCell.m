//
//  HomeBannerCell.m
//  dssp
//
//  Created by yxliu on 2018/3/17.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "HomeBannerCell.h"
#import "EllipsePageControl.h"
#import <UIImageView+SDWebImage.h>
#import <SDCycleScrollView.h>

NSString * const HomeBannerCellIdentifier = @"HomeBannerCellIdentifier";

@implementation CarouselObject

@end

@implementation CarouselData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"images": [CarouselObject class]
             };
}
@end

@interface HomeBannerCell () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *banner;
@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) NSArray<CarouselObject *> *objs;
@property (nonatomic, copy) CarouselBlock carouselBlock;
@end

@implementation HomeBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"home_banner_placeholder"]];
    _banner.layer.masksToBounds = YES;
    _banner.layer.cornerRadius = 4;
    _banner.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    _banner.layer.shadowOffset = CGSizeMake(0, 6);
    _banner.layer.shadowRadius = 7;
    _banner.layer.shadowOpacity = 0.5;
    _banner.autoScrollTimeInterval = 5.0;
    _banner.infiniteLoop = YES;
    _banner.showPageControl = NO;
    [self.contentView addSubview:_banner];
    [_banner makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(375 * WidthCoefficient);
        make.height.equalTo(200 * WidthCoefficient);
        make.center.equalTo(0);
    }];
    
    self.pageControl = [[EllipsePageControl alloc] init];
    _pageControl.frame = CGRectMake(0, 180 * WidthCoefficient, kScreenWidth, 6 * WidthCoefficient);
    _pageControl.currentColor = [UIColor colorWithHexString:@"#ac0042"];
    _pageControl.otherColor = [UIColor colorWithHexString:GeneralColorString];
    _pageControl.controlSize = 6 * WidthCoefficient;
    _pageControl.controlSpacing = 6 * WidthCoefficient;
    [self.contentView addSubview:_pageControl];
}

- (void)configWithCarousel:(NSArray<CarouselObject *> *)objs block:(CarouselBlock)block {
    if (!objs) {
        CarouselObject *tmp = [[CarouselObject alloc] init];
        tmp.local = YES;
        objs = @[tmp];
    }
    self.carouselBlock = block;
    self.objs = objs;
    _pageControl.numberOfPages = objs.count;
    if (objs.count == 1) {
        _banner.infiniteLoop = NO;
        _pageControl.hidden = YES;
    } else {
        _banner.infiniteLoop = YES;
        _pageControl.hidden = NO;
    }
    if (objs.count == 1 && objs[0].local == YES) {
        self.banner.localizationImageNamesGroup = @[@"home_banner_car"];
    } else {
        NSMutableArray *imgURLs = [NSMutableArray array];
        for (NSInteger i = 0; i < objs.count; i++) {
            [imgURLs addObject:self.objs[i].imgUrl];
        }
        self.banner.imageURLStringsGroup = imgURLs;
    }
}

+ (CGFloat)cellHeight {
    return 200 * WidthCoefficient;
}

#pragma mark - SDCycleScrollViewDelegate -

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *url = self.objs[index].href;
    
    if (self.carouselBlock && url && ![url isEqualToString:@""]) {
        self.carouselBlock(url);
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if (self.pageControl.currentPage != index) {
        self.pageControl.currentPage = index;
    }
}
@end

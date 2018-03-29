//
//  HomeBannerCell.m
//  dssp
//
//  Created by yxliu on 2018/3/17.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "HomeBannerCell.h"
#if DEVELOPMENT == 2
#import "dssp-Swift.h"
#elif DEVELOPMENT == 1
#import "dssp_pre-Swift.h"
#else
#import "dssp_sit-Swift.h"
#endif
#import "EllipsePageControl.h"
#import <UIImageView+SDWebImage.h>

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

@interface HomeBannerCell () <FSPagerViewDelegate, FSPagerViewDataSource>
@property (nonatomic, strong) FSPagerView *banner;
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
    
    self.banner = [[FSPagerView alloc] init];
    _banner.layer.masksToBounds = YES;
    _banner.layer.cornerRadius = 4;
    _banner.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    _banner.layer.shadowOffset = CGSizeMake(0, 6);
    _banner.layer.shadowRadius = 7;
    _banner.layer.shadowOpacity = 0.5;
    _banner.automaticSlidingInterval = 5.0;
    _banner.isInfinite = YES;
    _banner.delegate = self;
    _banner.dataSource = self;
    _banner.itemSize = CGSizeZero;
    [_banner registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"FSPagerViewCell"];
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
        _banner.isInfinite = NO;
        _pageControl.hidden = YES;
    } else {
        _banner.isInfinite = YES;
        _pageControl.hidden = NO;
    }
    [self.banner reloadData];
}

+ (CGFloat)cellHeight {
    return 200 * WidthCoefficient;
}

#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView {
    return self.objs.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"FSPagerViewCell" atIndex:index];
    cell.contentView.layer.shadowRadius = 0;
    cell.imageView.userInteractionEnabled = YES;
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    if (self.objs[index].local) {
        cell.imageView.image = [UIImage imageNamed:@"home_banner_car"];
    } else {
        [cell.imageView downloadImage:self.objs[index].imgUrl placeholder:[UIImage imageNamed:@"home_banner_placeholder"]];
    }
    return cell;
}

#pragma mark - FSPagerViewDelegate

- (void)pagerViewDidScroll:(FSPagerView *)pagerView {
    if (self.pageControl.currentPage != pagerView.currentIndex) {
        self.pageControl.currentPage = pagerView.currentIndex;
    }
}

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index {
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
    self.pageControl.currentPage = index;
    
    NSString *url = self.objs[index].href;
    
    if (self.carouselBlock && url && ![url isEqualToString:@""]) {
        self.carouselBlock(url);
    }
}

- (BOOL)pagerView:(FSPagerView *)pagerView shouldHighlightItemAtIndex:(NSInteger)index {
    NSString *url = self.objs[index].href;
    return url && ![url isEqualToString:@""];
}

- (BOOL)pagerView:(FSPagerView *)pagerView shouldSelectItemAtIndex:(NSInteger)index {
    NSString *url = self.objs[index].href;
    return url && ![url isEqualToString:@""];
}

@end

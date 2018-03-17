//
//  HomeBannerCell.m
//  dssp
//
//  Created by yxliu on 2018/3/17.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "HomeBannerCell.h"
#import "dssp-Swift.h"
#import "EllipsePageControl.h"

NSString * const HomeBannerCellIdentifier = @"HomeBannerCellIdentifier";

@interface HomeBannerCell () <FSPagerViewDelegate, FSPagerViewDataSource>
@property (nonatomic, strong) FSPagerView *banner;
@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) NSArray<NSString *> *URLs;
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
    _banner.automaticSlidingInterval = 3.0;
    _banner.isInfinite = YES;
    _banner.delegate = self;
    _banner.dataSource = self;
    _banner.itemSize = CGSizeZero;
    [_banner registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"FSPagerViewCell"];
    [self.contentView addSubview:_banner];
    [_banner makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(101.5 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(10 * WidthCoefficient);
    }];
    
    self.pageControl = [[EllipsePageControl alloc] init];
    _pageControl.frame = CGRectMake(0, 105 * WidthCoefficient, kScreenWidth, 6 * WidthCoefficient);
    _pageControl.currentColor = [UIColor colorWithHexString:@"#ac0042"];
    _pageControl.otherColor = [UIColor colorWithHexString:GeneralColorString];
    _pageControl.controlSize = 6 * WidthCoefficient;
    _pageControl.controlSpacing = 6 * WidthCoefficient;
    [self.contentView addSubview:_pageControl];
}

- (void)configWithURLs:(NSArray<NSString *> *)urls {
    self.URLs = urls;
    [self.banner reloadData];
    _pageControl.numberOfPages = urls.count;
}

+ (CGFloat)cellHeight {
    return 121.5 * WidthCoefficient;
}

#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView {
    return self.URLs.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"FSPagerViewCell" atIndex:index];
    cell.contentView.layer.shadowRadius = 0;
    cell.imageView.userInteractionEnabled = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.image = [UIImage imageNamed:self.URLs[index]];
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
    NSLog(@"%ld",index);
}

@end

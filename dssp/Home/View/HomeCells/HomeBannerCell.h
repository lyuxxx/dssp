//
//  HomeBannerCell.h
//  dssp
//
//  Created by yxliu on 2018/3/17.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeBannerCellIdentifier;

@interface CarouselObject : NSObject
//请求失败加载本地图片
@property (nonatomic, assign) BOOL local;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *href;
@end

@interface CarouselData : NSObject <YYModel>
@property (nonatomic, strong) NSArray<CarouselObject *> *images;
@property (nonatomic, copy) NSString *type;
@end
typedef void(^CarouselBlock)(NSString *);
@interface HomeBannerCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)configWithCarousel:(NSArray<CarouselObject *> *)objs block:(CarouselBlock)block;

@end

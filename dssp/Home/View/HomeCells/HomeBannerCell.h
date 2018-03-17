//
//  HomeBannerCell.h
//  dssp
//
//  Created by yxliu on 2018/3/17.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeBannerCellIdentifier;

@interface HomeBannerCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)configWithURLs:(NSArray<NSString *> *)urls;

@end

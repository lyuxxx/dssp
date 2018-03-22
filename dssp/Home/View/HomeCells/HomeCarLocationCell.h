//
//  HomeCarLocationCell.h
//  dssp
//
//  Created by yxliu on 2018/3/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeCarLocationCellIdentifier;

@class YYLabel;

@interface HomeCarLocationCell : UITableViewCell

+ (CGFloat)cellHeightWithLocation:(NSString *)location;
- (void)configWithLocation:(NSString *)location withLocationClick:(void(^)(YYLabel *))block;

@end

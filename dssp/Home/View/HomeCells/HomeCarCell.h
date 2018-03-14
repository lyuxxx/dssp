//
//  HomeCarCell.h
//  dssp
//
//  Created by yxliu on 2018/3/13.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeCarCellIdentifier;
@class YYLabel;

@interface HomeCarCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)configWithLocation:(NSString *)locationStr withLocationClick:(void(^)(YYLabel *))block;

@end

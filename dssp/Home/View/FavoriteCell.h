//
//  FavoriteCell.h
//  dssp
//
//  Created by yxliu on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>
#import "POI.h"

@interface FavoriteCell : MGSwipeTableCell

+ (CGFloat)cellHeight;
- (void)configWithModel:(ResultItem *)item;

@end

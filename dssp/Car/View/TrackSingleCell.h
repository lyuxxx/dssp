//
//  TrackSingleCell.h
//  dssp
//
//  Created by yxliu on 2018/3/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@class TrackInfo;

@interface TrackSingleCell : MGSwipeTableCell

- (void)configWithTrackInfo:(TrackInfo *)info;

@end

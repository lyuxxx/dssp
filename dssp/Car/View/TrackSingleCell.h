//
//  TrackSingleCell.h
//  dssp
//
//  Created by yxliu on 2018/3/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackInfo;

@interface TrackSingleCell : UITableViewCell

- (void)configWithTrackInfo:(TrackInfo *)info;

@end
//
//  HomeCarStateCell.h
//  dssp
//
//  Created by yxliu on 2018/3/13.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeCarStateCellIdentifier;

@class TrafficReporData;

@interface HomeCarStateCell : UITableViewCell
+ (CGFloat)cellHeight;
- (void)configWithData:(TrafficReporData *)trafficReporData;
@end

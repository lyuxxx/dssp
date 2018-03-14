//
//  HomeCarReportCell.h
//  dssp
//
//  Created by yxliu on 2018/3/13.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ReportType) {
    ReportTypeCarCondition,
    ReportTypeWeekReport,
    ReportTypeTrackList
};
extern NSString * const HomeCarReportCellIdentifier;

@interface HomeCarReportCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)configWithTitle:(NSString *)title clickEvent:(void(^)(ReportType))reportBlock;

@end

//
//  RangePickerCell.h
//  dssp
//
//  Created by yxliu on 2018/2/27.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>

@interface RangePickerCell : FSCalendarCell

// The start/end of the range
@property (weak, nonatomic) CALayer *selectionLayer;

// The middle of the range
@property (weak, nonatomic) CALayer *middleLayer;

@end

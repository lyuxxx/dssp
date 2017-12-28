//
//  NoticeCell.h
//  dssp
//
//  Created by qinbo on 2017/12/19.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>
#import "NoticeModel.h"
@interface NoticeCell : MGSwipeTableCell
@property (nonatomic ,strong)NoticeModel *noticeModel;
@end

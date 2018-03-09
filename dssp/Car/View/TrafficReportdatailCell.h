//
//  TrafficReportdatailCell.h
//  dssp
//
//  Created by qinbo on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficReportModel.h"
@interface TrafficReportdatailCell : UITableViewCell
@property (nonatomic, strong) UILabel *leftlab;
@property (nonatomic, strong) UILabel *bottolab;
@property (nonatomic, strong) UILabel *rightlab;
@property (nonatomic, strong) UIImageView *rightimg;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) RecordItems *recordItem;
@end

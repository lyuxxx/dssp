//
//  InfoMessageHelpCenterCell.h
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoMessage.h"
typedef void(^ServiceClickBlock)(UIButton *sender);
@interface InfoMessageHelpCenterCell : UITableViewCell

@property (nonatomic, strong) InfoMessage *message;

+ (instancetype)cellWithTableView:(UITableView *)tableView serviceBlock:(void(^)(UIButton *))block;

@end

//
//  InfoMessageUserCell.h
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoMessage.h"

@interface InfoMessageUserCell : UITableViewCell

@property (nonatomic, strong) InfoMessage *message;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

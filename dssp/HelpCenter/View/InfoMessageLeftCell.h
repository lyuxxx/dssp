//
//  InfoMessageLeftCell.h
//  dssp
//
//  Created by qinbo on 2018/2/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoMessage.h"

typedef void(^ServiceClickBlock)(UIButton *sender,NSString *serviceId,NSString *ID,NSString *sourceData);
@interface InfoMessageLeftCell : UITableViewCell

@property (nonatomic, strong) InfoMessage *message;


+ (instancetype)cellWithTableView:(UITableView *)tableView serviceBlock:(void(^)(UIButton *,NSString *,NSString *,NSString *))block;
@end

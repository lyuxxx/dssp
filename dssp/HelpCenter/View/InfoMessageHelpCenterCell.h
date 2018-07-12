//
//  InfoMessageHelpCenterCell.h
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoMessage.h"

#define feedbackTag 100
#define contactServiceTag 101

@class InfoMessageHelpCenterCell;

@protocol SevenProtocolDelegate <NSObject>
- (void)sevenProrocolMethod:(NSString *)cellUrl;
- (void)showPic:(UIImage *)image;
- (void)updateTableViewWithCell:(InfoMessageHelpCenterCell *)cell CellHeight:(CGFloat)height DownloadSuccess:(BOOL)success;
- (void)removeStoredHeightWithCell:(InfoMessageHelpCenterCell *)cell;
- (void)functionButtonAction:(UIButton *)button;
@end

typedef void(^ServiceClickBlock)(UIButton *sender,NSString *serviceId,NSString *serviceParentId,NSString *sourceData,NSString *appNum);

@interface InfoMessageHelpCenterCell : UITableViewCell

@property (nonatomic, weak) id<SevenProtocolDelegate> customDelegate;
@property (nonatomic, strong) InfoMessage *message;

+ (instancetype)cellWithTableView:(UITableView *)tableView serviceBlock:(void(^)(UIButton *,NSString *,NSString *,NSString *,NSString *))block;
@end

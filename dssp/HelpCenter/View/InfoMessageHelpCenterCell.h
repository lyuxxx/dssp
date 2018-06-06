//
//  InfoMessageHelpCenterCell.h
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoMessage.h"

@protocol SevenProtocolDelegate <NSObject>
- (void)sevenProrocolMethod:(NSString *)cellUrl;
- (void)showPic:(UIImage *)image;
@end

typedef void(^ServiceClickBlock)(UIButton *sender,NSString *serviceId,NSString *ID,NSString *sourceData,NSString *appNum);
@interface InfoMessageHelpCenterCell : UITableViewCell

@property (nonatomic, weak) id<SevenProtocolDelegate> customDelegate;
@property (nonatomic, strong) InfoMessage *message;

+ (instancetype)cellWithTableView:(UITableView *)tableView serviceBlock:(void(^)(UIButton *,NSString *,NSString *,NSString *,NSString *))block;
@end

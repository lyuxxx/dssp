//
//  ActivationCodeListCell.h
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivationCode;

@interface ActivationCodeListCell : UITableViewCell

- (void)configWithActivationCode:(ActivationCode *)code;

@end

//
//  SubscriCell.h
//  dssp
//
//  Created by qinbo on 2017/12/20.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribeModel.h"
@interface SubscriCell : UITableViewCell
@property (nonatomic,strong) ChannelModel *channelModel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *bottomLabel;
@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,strong) UILabel *remindLabel;
@end

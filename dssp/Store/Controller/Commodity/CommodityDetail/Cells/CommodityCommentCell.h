//
//  CommodityCommentCell.h
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityComment;

extern NSString * const CommodityCommentCellIdentifier;

@interface CommodityCommentCell : UITableViewCell

- (void)configWithComment:(CommodityComment *)comment;

+ (CGFloat)cellHeightWithComment:(CommodityComment *)comment;

@end

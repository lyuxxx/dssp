//
//  CommodityDescriptionCell.h
//  dssp
//
//  Created by yxliu on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

extern NSString * const CommodityDescriptionCellIdentifier;

@interface CommodityDescriptionCell : UITableViewCell

@property (nonatomic, strong) WKWebView *webView;

//- (void)configWithCommodityDescription:(NSString *)desc;
//
//- (CGFloat)cellHeightWithCommodityDescription:(NSString *)desc;

@end

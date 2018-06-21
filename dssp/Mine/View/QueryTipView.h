//
//  QueryTipView.h
//  dssp
//
//  Created by season on 2018/6/20.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QueryTipView;

@protocol QueryTipViewDelegate<NSObject>
@optional
- (void)queryTipView:(QueryTipView *)queryTipView callButtonAction:(UIButton *)button ;
@end

/**
 最新的实名制查询tip
 */
@interface QueryTipView : UIImageView

@property (nonatomic, weak) id<QueryTipViewDelegate> delegate;
    
- (instancetype)initWithTag:(NSInteger)tag;

@end

//
//  RemindViewController.h
//  dssp
//
//  Created by yxliu on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "BaseViewController.h"
#import "NoticeModel.h"

typedef void(^RemindBackBlcok) (NSString *text);
@interface RemindViewController : BaseViewController
@property(nonatomic,copy) NSString *vin;
@property(nonatomic,copy) NSString *businType;
@property(nonatomic,copy) NSString *noticeId;
@property(nonatomic,copy) NSString *title;
@property (nonatomic,strong) NoticeModel *noticeModel;
@property (nonatomic,strong) NoticedatailModel *notice;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message;
@property (nonatomic,copy)RemindBackBlcok remindBackBlcok;
@end



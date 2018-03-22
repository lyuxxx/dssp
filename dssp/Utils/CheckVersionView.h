//
//  CheckVersionView.h
//  dssp
//
//  Created by yxliu on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionObject : NSObject <YYModel>
@property (nonatomic, copy) NSString *versionName;
@property (nonatomic, assign) NSInteger versionCode;
@property (nonatomic, assign) NSInteger minimumCompatibleVersion;
@property (nonatomic, copy) NSString *updateDesc;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *marketDownloadUrl;
@property (nonatomic, copy) NSString *isCompulsoryEscalation;
@end

@interface CheckVersionView : UIView

+ (instancetype)showWithVersion:(VersionObject *)version;

@end

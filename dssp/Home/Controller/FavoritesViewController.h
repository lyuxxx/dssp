//
//  FavoritesViewController.h
//  dssp
//
//  Created by yxliu on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "BaseViewController.h"

@interface FavoritesViewController : BaseViewController

- (instancetype)initWithType:(PoiType)type checkPoi:(NSString *)serviceId block:(void (^)(BOOL))block;

@end

//
//  FavoritesViewController.h
//  dssp
//
//  Created by yxliu on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"

@interface FavoritesViewController : StoreBaseViewController

- (instancetype)initWithType:(PoiType)type checkPoi:(NSString *)serviceId block:(void (^)(BOOL))block;

@end

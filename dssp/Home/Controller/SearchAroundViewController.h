//
//  SearchAroundViewController.h
//  dssp
//
//  Created by yxliu on 2017/12/26.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MapBaseController.h"
#import <MapSearchObject.h>

@interface SearchAroundViewController : MapBaseController

- (instancetype)initWithType:(PoiType)type address:(MapPoiInfo *)address;

@end

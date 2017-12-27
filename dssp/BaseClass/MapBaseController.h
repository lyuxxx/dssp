//
//  MapBaseController.h
//  dssp
//
//  Created by yxliu on 2017/12/26.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "BaseViewController.h"
#import "MapView.h"

@interface MapBaseController : BaseViewController <MAMapViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;

@end

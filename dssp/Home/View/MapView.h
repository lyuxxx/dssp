//
//  MapView.h
//  sharedMapView
//
//  Created by yxliu on 2017/12/25.
//  Copyright © 2017年 cusc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface MapView : MAMapView

+ (MapView *)sharedMapView;
+ (void)destroy;

@end

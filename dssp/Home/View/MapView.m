//
//  MapView.m
//  sharedMapView
//
//  Created by yxliu on 2017/12/25.
//  Copyright © 2017年 cusc. All rights reserved.
//

#import "MapView.h"

@implementation MapView

static MapView *mapView = nil;
static dispatch_once_t onceToken;

+ (MapView *)sharedMapView {
    dispatch_once(&onceToken, ^{
        [AMapServices sharedServices].apiKey = @"e3aed20c93efeea15495d8bf27a87fac";
        [AMapServices sharedServices].enableHTTPS = YES;
        mapView = [[MapView alloc] init];
        mapView.showsUserLocation = YES;
        mapView.userTrackingMode = MAUserTrackingModeFollow;
        mapView.showsIndoorMap = YES;
        mapView.showTraffic = YES;
        mapView.showsScale = NO;
        mapView.showsCompass = NO;
        mapView.desiredAccuracy = kCLLocationAccuracyBest;
        mapView.zoomLevel = 17.0;
        mapView.touchPOIEnabled = NO;
        
        MAUserLocationRepresentation *representation = [[MAUserLocationRepresentation alloc] init];
        representation.showsAccuracyRing = NO;
        representation.showsHeadingIndicator = NO;
        //    representation.fillColor = [UIColor blueColor];
        //    representation.strokeColor = [UIColor blueColor];
        //    representation.lineWidth = 2;
        //    representation.enablePulseAnnimation = false;
        //    representation.locationDotBgColor = [UIColor greenColor];
        //    representation.locationDotFillColor = [UIColor grayColor];
        //    representation.image = [UIImage imageNamed:@"userPosition"];
        //    representation.image = nil;
        [mapView updateUserLocationRepresentation:representation];
    });
    return mapView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (mapView == nil) {
            mapView = [super allocWithZone:zone];
            return mapView;
        }
    }
    return nil;
}

+ (void)destroy {
    mapView = nil;
    onceToken = 0l;
}

@end

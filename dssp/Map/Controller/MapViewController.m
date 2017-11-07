//
//  MapViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MapViewController.h"
#import <MapManager/MapSearchManager.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "LocationAnnotationView.h"

@interface MapViewController () <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) LocationAnnotationView *locationAnnotationView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createMap];
}

- (void)createMap {
    if (!_mapView) {
        [self.view addSubview:self.mapView];
        [self.mapView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.safeAreaLayoutGuideTop);
                make.bottom.equalTo(self.view.safeAreaLayoutGuideBottom);
            } else {
                make.top.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(- kTabbarHeight);
            }
        }];
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        self.mapView.showsIndoorMap = YES;
        self.mapView.showTraffic = NO;
        self.mapView.showsScale = NO;
        self.mapView.showsCompass = NO;
        self.mapView.desiredAccuracy = kCLLocationAccuracyBest;
        self.mapView.zoomLevel = 17.0;
        
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
        [self.mapView updateUserLocationRepresentation:representation];
    }
}

#pragma mark - MAMapViewDelegate-

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (!updatingLocation && _locationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            _locationAnnotationView.rotateDegree = userLocation.heading.trueHeading - _mapView.rotationDegree;
        }];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[LocationAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:userLocationStyleReuseIndetifier];
            
            annotationView.canShowCallout = YES;
        }
        
        _locationAnnotationView = (LocationAnnotationView *)annotationView;
        [_locationAnnotationView updateImage:[UIImage imageNamed:@"gps_icon"]];
        
        return annotationView;
    }
    return nil;
}

#pragma mark - lazy load -

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
    }
    return _mapView;
}

@end

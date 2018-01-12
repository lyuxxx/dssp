//
//  MapBaseController.h
//  dssp
//
//  Created by yxliu on 2017/12/26.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "BaseViewController.h"
#import "MapView.h"
#import <MapSearchManager.h>
#import "CarAnnotation.h"
#import "POI.h"
#import "FavoritesViewController.h"
#import "SendPoiProgressView.h"

typedef NS_ENUM(NSUInteger, SendPoiResult) {
    SendPoiResultSuccess,
    SendPoiResultFail,
    SendPoiResultTimeOut,
    SendPoiResultCancel,
};

typedef void(^FavoriteCallBack)(ResultItem *);
typedef void(^CheckCarLocationOver)(void);

@interface MapBaseController : BaseViewController <MAMapViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, assign) PoiType type;
@property (nonatomic, copy) FavoriteCallBack favoriteCallBack;
@property (nonatomic, strong) CarAnnotation *carAnnotation;
@property (nonatomic, copy) CheckCarLocationOver checkCarLocationOver;

- (instancetype)initWithType:(PoiType)type;

- (void)checkPoiWithCpid:(NSString *)cpid inResult:(void (^)(BOOL,NSString *))result;
- (void)addPoiWithName:(NSString *)name address:(NSString *)address location:(CLLocationCoordinate2D)location tel:(NSString *)tel cpid:(NSString *)cpid type:(PoiType)type inResult:(void (^)(BOOL,NSString *))result;
- (void)deletePoisWithPoiIds:(NSArray<NSString *> *)ids inResult:(void (^)(BOOL))result;
- (void)sendPoiWithName:(NSString *)name address:(NSString *)address location:(CLLocationCoordinate2D)location inResult:(void (^)(SendPoiResult))result;
- (void)cancelSendPoi;
- (void)showPoiSendAletWithResult:(SendPoiResult)result;
- (void)clear;
- (NSString *)distanceFromUsr:(CLLocationCoordinate2D)location;
- (void)favoritesClick:(UIButton *)sender;

@end

//
//  MapSearchManager.m
//  MapManager
//
//  Created by yxliu on 2017/10/31.
//

#import "MapSearchManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapSearchManager ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, copy) KeyWordSearchBlock keyWordSearchBlock;
@property (nonatomic, copy) TipsSearchBlock tipsSearchBlock;
@property (nonatomic, copy) ReGeocodeSearchBlock reGeocodeSearchBlock;

@end

@implementation MapSearchManager

#pragma mark -public fun-

+ (instancetype)sharedManager {
    static MapSearchManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)keyWordsSearch:(NSString *)keyword city:(NSString *)city returnBlock:(TipsSearchBlock)block {
    if (keyword.length) {
        self.keyWordSearchBlock = block;
        
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        request.keywords = keyword;
        if (city.length) {
            request.city = city;
            request.cityLimit = YES;
        }
        request.requireExtension = YES;
        request.requireSubPOIs = YES;
        
        [self.searchAPI AMapPOIKeywordsSearch:request];
    }
}

- (void)inputTipsSearch:(NSString *)keyword city:(NSString *)city returnBlock:(TipsSearchBlock)block {
    if (keyword.length) {
        self.tipsSearchBlock = block;
        
        AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc] init];
        request.keywords = keyword;
        if (city.length) {
            request.city = city;
//            request.cityLimit = YES;
        }
        
        [self.searchAPI AMapInputTipsSearch:request];
    }
}

- (void)poiReGeocode:(CLLocationCoordinate2D)coordinate returnBlock:(ReGeocodeSearchBlock)block {
    if (coordinate.latitude > 0 && coordinate.longitude > 0) {
        self.reGeocodeSearchBlock = block;
        
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        request.requireExtension = YES;
        
        [self.searchAPI AMapReGoecodeSearch:request];
    }
}

#pragma mark - AMapSearchDelegate -

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    
    NSMutableArray *poiAnnotations = [[NSMutableArray alloc] init];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MapSearchPointAnnotation *annotation = [[MapSearchPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        [annotation setTitle:obj.name];
        [annotation setSubtitle:obj.address];
        
        [poiAnnotations addObject:annotation];
    }];
    
    if (self.keyWordSearchBlock) {
        self.keyWordSearchBlock(poiAnnotations);
    }
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    if (response.tips.count == 0) {
        return;
    }
    
    NSMutableArray *tips = [[NSMutableArray alloc] init];
    
    for (AMapTip *tip in response.tips) {
        if (tip.location.latitude != 0 && ![tip.uid isEqualToString:@""]) {
            MapSearchTip *mTip = [[MapSearchTip alloc] init];
            mTip.name = tip.name;
            mTip.adcode = tip.adcode;
            mTip.district = tip.district;
            mTip.address = tip.address;
            mTip.coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
            
            [tips addObject:mTip];
        }
    }
    
    if (self.tipsSearchBlock) {
        self.tipsSearchBlock(tips);
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response && response.regeocode) {
        NSMutableArray *pois = [[NSMutableArray alloc] init];
        
        for (AMapPOI *poi in response.regeocode.pois) {
            MapSearchPoi *mPoi = [[MapSearchPoi alloc] init];
            mPoi.name = poi.name;
            mPoi.address = poi.name;
            mPoi.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            mPoi.city = poi.city;
            mPoi.cityCode = poi.citycode;
            
            [pois addObject:mPoi];
        }
        
        if (self.reGeocodeSearchBlock) {
            self.reGeocodeSearchBlock(pois);
        }
    }
}

#pragma mark lazy get
- (AMapSearchAPI *)searchAPI {
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

@end

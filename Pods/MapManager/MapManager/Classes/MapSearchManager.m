//
//  MapSearchManager.m
//  MapManager
//
//  Created by yxliu on 2017/10/31.
//

#import "MapSearchManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

typedef NS_ENUM(NSUInteger, SearchType) {
    SearchTypeKeyWord,
    SearchTypeKeyWordAround,
    SearchTypeId,
};

@interface MapSearchManager ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, copy) KeyWordSearchBlock keyWordSearchBlock;
@property (nonatomic, copy) KeyWordAroundBlock keyWordAroundBlock;
@property (nonatomic, copy) TipsSearchBlock tipsSearchBlock;
@property (nonatomic, copy) IDSearchBlock idSearchBlock;
@property (nonatomic, copy) ReGeocodeSearchBlock reGeocodeSearchBlock;
@property (nonatomic, copy) ReGeoInfoBlock reGeoInfoBlock;
@property (nonatomic, copy) WeatherLiveBlock weatherLiveBlock;

@property (nonatomic, assign) BOOL needReGeoInfo;
@property (nonatomic, assign) SearchType searchType;

@end

@implementation MapSearchManager

static MapSearchManager *manager = nil;
static dispatch_once_t mapSearchOnceToken;

#pragma mark -public fun-

+ (instancetype)sharedManager {
    dispatch_once(&mapSearchOnceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)destroyManager {
    manager = nil;
    mapSearchOnceToken = 0l;
}

- (void)keyWordsSearch:(NSString *)keyword city:(NSString *)city returnBlock:(KeyWordSearchBlock)block {
    self.searchType = SearchTypeKeyWord;
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

- (void)keyWordsAround:(NSString *)keyword location:(CLLocationCoordinate2D)coordinate returnBlock:(KeyWordAroundBlock)block {
    self.searchType = SearchTypeKeyWordAround;
    if (keyword.length) {
        self.keyWordAroundBlock = block;
        
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        request.keywords = keyword;
        request.sortrule = 0;
        request.radius = 5000;
        
        request.requireExtension = YES;
        
        [self.searchAPI AMapPOIAroundSearch:request];
    }
}

- (void)idSearch:(NSString *)idStr returnBlock:(IDSearchBlock)block {
    self.searchType = SearchTypeId;
    self.idSearchBlock = block;
    
    AMapPOIIDSearchRequest *request = [[AMapPOIIDSearchRequest alloc] init];
    request.uid = idStr;
    request.requireExtension = YES;
    
    [self.searchAPI AMapPOIIDSearch:request];
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

- (void)inputTipsSearch:(NSString *)keyword city:(NSString *)city location:(CLLocationCoordinate2D)location returnBlock:(TipsSearchBlock)block {
    if (keyword.length) {
        self.tipsSearchBlock = block;
        
        AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc] init];
        request.keywords = keyword;
        if (city.length) {
            request.city = city;
            request.location = [NSString stringWithFormat:@"%f,%f",location.longitude,location.latitude];
            //            request.cityLimit = YES;
        }
        
        [self.searchAPI AMapInputTipsSearch:request];
    }
}

- (void)poiReGeocode:(CLLocationCoordinate2D)coordinate returnBlock:(ReGeocodeSearchBlock)block {
    self.needReGeoInfo = NO;
    if (coordinate.latitude > 0 && coordinate.longitude > 0) {
        self.reGeocodeSearchBlock = block;
        
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        request.requireExtension = YES;
        
        [self.searchAPI AMapReGoecodeSearch:request];
    }
}

- (void)reGeoInfo:(CLLocationCoordinate2D)coordinate returnBlock:(ReGeoInfoBlock)block {
    self.needReGeoInfo = YES;
    if (coordinate.latitude > 0 && coordinate.longitude > 0) {
        self.reGeoInfoBlock = block;
        
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        request.requireExtension = YES;
        
        [self.searchAPI AMapReGoecodeSearch:request];
    }
}

- (void)weatherLive:(NSString *)city returnBlock:(WeatherLiveBlock)block {
    if (city) {
        self.weatherLiveBlock = block;
        
        AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
        request.city = city;
        request.type = AMapWeatherTypeLive;
        
        [self.searchAPI AMapWeatherSearch:request];
    }
}

#pragma mark - AMapSearchDelegate -

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if (self.searchFailBlock) {
        self.searchFailBlock(error);
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    
    NSMutableArray *poiAnnotations = [[NSMutableArray alloc] init];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MapPoiInfo *annotation = [[MapPoiInfo alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        annotation.name = obj.name;
        annotation.address = obj.address;
        annotation.uid = obj.uid;
        annotation.adcode = obj.adcode;
        annotation.district = obj.district;
        annotation.type = obj.type;
        annotation.typecode = obj.typecode;
        annotation.tel = obj.tel;
        annotation.distance = obj.distance;
        annotation.parkingType = obj.parkingType;
        annotation.shopID = obj.shopID;
        annotation.postcode = obj.postcode;
        annotation.website = obj.website;
        annotation.email = obj.email;
        annotation.province = obj.province;
        annotation.pcode = obj.pcode;
        annotation.city = obj.city;
        annotation.citycode = obj.citycode;
        annotation.gridcode = obj.gridcode;
        annotation.direction = obj.direction;
        annotation.businessArea = obj.businessArea;

        [poiAnnotations addObject:annotation];
    }];
    
    if (self.searchType == SearchTypeKeyWordAround) {
        if (self.keyWordAroundBlock) {
            self.keyWordAroundBlock(poiAnnotations);
        }
    }
    if (self.searchType == SearchTypeKeyWord) {
        if (self.keyWordSearchBlock) {
            self.keyWordSearchBlock(poiAnnotations);
        }
    }
    if (self.searchType == SearchTypeId) {
        if (self.idSearchBlock) {
            self.idSearchBlock(poiAnnotations[0]);
        }
    }
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    if (response.tips.count == 0) {
        return;
    }
    
    NSMutableArray *tips = [[NSMutableArray alloc] init];
    
    for (AMapTip *tip in response.tips) {
        MapPoiInfo *mTip = [[MapPoiInfo alloc] init];
        mTip.uid = tip.uid;
        mTip.name = tip.name;
        mTip.adcode = tip.adcode;
        mTip.district = tip.district;
        mTip.address = tip.address;
        mTip.coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
        mTip.typecode = tip.typecode;
        
        [tips addObject:mTip];
    }
    
    if (self.tipsSearchBlock) {
        self.tipsSearchBlock(tips);
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (self.needReGeoInfo) {
        if (response && response.regeocode) {
            MapReGeoInfo *info = [[MapReGeoInfo alloc] init];
            
            AMapAddressComponent *addressComponent = response.regeocode.addressComponent;
            info.formattedAddress = response.regeocode.formattedAddress;
            info.province = addressComponent.province;
            info.city = addressComponent.city;
            info.citycode = addressComponent.citycode;
            info.district = addressComponent.district;
            info.adcode = addressComponent.adcode;
            info.township = addressComponent.township;
            info.towncode = addressComponent.towncode;
            info.neighborhood = addressComponent.neighborhood;
            info.building = addressComponent.building;
            
            if (self.reGeoInfoBlock) {
                self.reGeoInfoBlock(info);
            }
        }
    } else {
        if (response && response.regeocode) {
            NSMutableArray *pois = [[NSMutableArray alloc] init];
            
            for (AMapPOI *obj in response.regeocode.pois) {
                MapPoiInfo *annotation = [[MapPoiInfo alloc] init];
                [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
                annotation.name = obj.name;
                annotation.address = obj.address;
                annotation.uid = obj.uid;
                annotation.adcode = obj.adcode;
                annotation.district = obj.district;
                annotation.type = obj.type;
                annotation.typecode = obj.typecode;
                annotation.tel = obj.tel;
                annotation.distance = obj.distance;
                annotation.parkingType = obj.parkingType;
                annotation.shopID = obj.shopID;
                annotation.postcode = obj.postcode;
                annotation.website = obj.website;
                annotation.email = obj.email;
                annotation.province = obj.province;
                annotation.pcode = obj.pcode;
                annotation.city = obj.city;
                annotation.citycode = obj.citycode;
                annotation.gridcode = obj.gridcode;
                annotation.direction = obj.direction;
                annotation.businessArea = obj.businessArea;
                
                [pois addObject:annotation];
            }
            
            if (self.reGeocodeSearchBlock) {
                self.reGeocodeSearchBlock(pois);
            }
        }
    }
}

- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response {
    if (request.type == AMapWeatherTypeLive) {
        if (response.lives.count == 0) {
            return;
        }
        AMapLocalWeatherLive *liveWeather = [response.lives firstObject];
        if (liveWeather) {
            MapWeatherLive *live = [[MapWeatherLive alloc] init];
            live.adcode = liveWeather.adcode;
            live.province = liveWeather.province;
            live.city = liveWeather.city;
            live.weather = liveWeather.weather;
            live.temperature = liveWeather.temperature;
            live.windDirection = liveWeather.windDirection;
            live.windPower = liveWeather.windPower;
            live.humidity = liveWeather.humidity;
            live.reportTime = liveWeather.reportTime;
            
            if (self.weatherLiveBlock) {
                self.weatherLiveBlock(live);
            }
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

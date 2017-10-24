//
//  CUHTTPHeader.h
//  CUHTTPRequest
//
//  Created by yxliu on 2017/9/20.
//

#ifndef CUHTTPHeader_h
#define CUHTTPHeader_h

typedef NS_ENUM(NSUInteger, CUHTTPNetworkType) {
    NetworkType_WiFi = 399999,
    NetworkType_WWAN,
    NetworkType_NO,//无连接状态
    NetworkType_Unknown,//未知网络状态
};

typedef NS_ENUM(NSUInteger, CUHTTPNetworkUploadDownloadType) {
    UploadDownloadType_Images = 499999,//POST上传图片
    UploadDownloadType_Videos,//POST上传视频
};

#import "CUHTTPRequest.h"

#endif /* CUHTTPHeader_h */

//
//  UIImageView+SDWebImage.h
//  UIImageViewSDWebImage
//
//  Created by yxliu on 2017/9/20.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CUImageCacheType) {
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    CUImageCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    CUImageCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    CUImageCacheTypeMemory
};

typedef void(^DownloadSuccessBlock)(CUImageCacheType cacheType, UIImage *image);
typedef void(^DownloadFailureBlock)(NSError *error);
typedef void(^DownloadProgressBlock)(CGFloat progress);

@interface UIImageView (SDWebImage)

/**
 SDWebImage 下载并缓存图片
 
 @param url 图片的url
 @param placeholder 还未下载成功的占位图
 */
- (void)downloadImage:(NSString *)url
          placeholder:(UIImage *)placeholder;

/**
 SDWebImage 下载并缓存图片和下载进度
 
 @param url 图片的url
 @param placeholder 还未下载成功的占位图
 @param success 图片下载成功回调
 @param failure 图片下载失败回调
 @param progress 图片下载进度回调
 */
- (void)downloadImage:(NSString *)url
          placeholder:(UIImage *)placeholder
              success:(DownloadSuccessBlock)success
              failure:(DownloadFailureBlock)failure
             received:(DownloadProgressBlock)progress;

@end

//
//  UIImageView+SDWebImage.m
//  UIImageViewSDWebImage
//
//  Created by yxliu on 2017/9/20.
//

#import "UIImageView+SDWebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SDWebImage)

- (void)downloadImage:(NSString *)url placeholder:(UIImage *)placeholder {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

- (void)downloadImage:(NSString *)url placeholder:(UIImage *)placeholder success:(DownloadSuccessBlock)success failure:(DownloadFailureBlock)failure received:(DownloadProgressBlock)progress {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:SDWebImageLowPriority | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        progress((float)receivedSize / expectedSize);
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            failure(error);
        } else {
            if (cacheType == SDImageCacheTypeNone) {
                success(CUImageCacheTypeNone, image);
            } else if (cacheType == SDImageCacheTypeDisk) {
                success(CUImageCacheTypeDisk, image);
            } else if (cacheType == SDImageCacheTypeMemory) {
                success(CUImageCacheTypeMemory, image);
            }
        }
    }];
}

@end

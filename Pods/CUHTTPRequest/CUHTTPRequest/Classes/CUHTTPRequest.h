//
//  CUHTTPRequest.h
//  CUHTTPRequest
//
//  Created by yxliu on 2017/9/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CUHTTPHeader.h"

@interface CUHTTPRequest : NSObject

/**
 设置请求头

 @param header 请求头字典
 */
+ (void)setHTTPHeader:(NSDictionary *)header;

#pragma mark --网络状态--

/**
 检查网络连接，是否可用block回调
 
 @param isDuplicates YES:重复获取网络状态,当网络状态改变的时候会回调block;NO:只获取一次
 @param statusNetWork CUHTTPNetworkType类型
 */
+ (void)netWorkDuplicates:(BOOL)isDuplicates
                   status:(void (^)(CUHTTPNetworkType type))statusNetWork;

#pragma mark --GET--

/**
 GET请求，请求普通接口(客户端请求开始连接，服务器返回数据结束连接)

 @param URL 请求的URL
 @param parameters 请求的参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)GET:(NSString *)URL
 parameters:(id)parameters
    success:(void (^)(id responseData))success
    failure:(void (^)(NSInteger code))failure;

/**
  GET下载文件

 @param URL 下载的文件的URL
 @param parameters 请求的参数
 @param filePath 文件夹的路径(不包括具体文件,会覆盖,请分清楚文件夹的路径和具体文件)
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)GETDownload:(NSString *)URL
         parameters:(id)parameters
           filePath:(NSString *)filePath
            success:(void (^)(id responseData))success
            failure:(void (^)(NSInteger code))failure;

#pragma mark --HEAD--

/**
  HEAD请求，请求普通接口(客户端请求开始连接，服务器返回数据结束连接)

 @param URL 请求的URL
 @param parameters 请求的参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)HEAD:(NSString *)URL
  parameters:(id)parameters
     success:(void (^)(id responseData))success
     failure:(void (^)(NSInteger code))failure;

#pragma mark --PUT--

/**
  PUT请求，请求普通接口(客户端请求开始连接,服务器返回数据结束连接)

 @param URL 请求的URL
 @param parameters 请求的参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)PUT:(NSString *)URL
 parameters:(id)parameters
    success:(void (^)(id responseData))success
    failure:(void (^)(NSInteger code))failure;

#pragma mark --PATCH--

/**
  PATCH请求，请求普通接口(客户端请求开始连接,服务器返回数据结束连接)

 @param URL 请求的URL
 @param parameters 请求的参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)PATCH:(NSString *)URL
   parameters:(id)parameters
      success:(void (^)(id responseData))success
      failure:(void (^)(NSInteger code))failure;

#pragma mark --DELETE--

/**
  DELETE请求,请求普通接口(客户端请求开始连接，服务器返回数据结束连接)

 @param URL 请求的URL
 @param parameters 请求的参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)DELETE:(NSString *)URL
    parameters:(id)parameters
       success:(void (^)(id responseData))success
       failure:(void (^)(NSInteger code))failure;

#pragma mark --POST--

/**
 POST请求,请求普通接口(客户端请求开始连接,服务器返回数据结束连接)

 @param URL 请求的URL
 @param parameters 请求的参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)POST:(NSString *)URL
  parameters:(id)parameters
     success:(void (^)(id responseData))success
     failure:(void (^)(NSInteger code))failure;

/**
 POST请求上传图片,MP3,视频,文件

 @param URL 上传的URL
 @param parameters 上传的参数
 @param uploadType 上传的是图片还是视频
 @param arrayData 装的NSData对象 @[NSData *]
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)POSTUpload:(NSString *)URL
        parameters:(id)parameters
        uploadType:(CUHTTPNetworkUploadDownloadType)uploadType
         dataArray:(NSArray<NSData *> *)arrayData
           success:(void (^)(id responseData))success
           failure:(void (^)(NSInteger code))failure;

#pragma mark --断点上传--

/**
 Upload断点上传

 @param URL 上传的URL
 @param uploadData 文件的二进制流
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)upload:(NSString *)URL
    uploadData:(NSData *)uploadData
       success:(void (^)(id responseData))success
       failure:(void (^)(NSInteger code))failure;

#pragma mark --下载--

/**
 download普通下载

 @param URL 下载的URL
 @param filePath 下载到沙盒中文件的位置
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)download:(NSString *)URL
        filePath:(NSString *)filePath
         success:(void (^)(id responseData))success
         failure:(void (^)(NSInteger code))failure;

/**
 断点下载,过程:先进行普通下载,然后不可以调用cancel方法,要用cacelByProducingResumeData方法,接收下载时的详细数据保存:http://blog.csdn.net/majiakun1/article/details/38133789

 @param data 断点下载中需要恢复下载的数据
 @param filePath 下载到沙盒中文件的位置
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)downloadBreakpoint:(NSData *)data
                  filePath:(NSString *)filePath
                   success:(void (^)(id responseData))success
                   failure:(void (^)(NSInteger code))failure;

#pragma mark --NSURLSessionTask相关--

/**
 每一个Task的State,返回四种状态,正在请求,暂停请求,取消请求,完成请求(默认状态)
 
 @param URL 传入作为KEY值遍历Task,返回状态
 @return 返回状态
 */
+ (NSURLSessionTaskState)requestATaskStateWith:(NSString *)URL;

/**
 根据URL返回一个Task句柄
 
 @param URL 传入作为KEY值遍历Task
 @return 返回具体的某一个Task,使用时需要判断是否为空
 */
+ (NSURLSessionTask *)requestATaskWith:(NSString *)URL;

#pragma mark --停止请求任务的方法--

/**
 取消所有的会话任务,和所有的NSURLSessionTask回调代理
 */
+ (void)cancelAllTasksAndOperationQueues;

/**
 停止单个的请求任务,当某一个请求正在请求时不想让其请求,不包括NSURLSessionStreamTask
 
 @param URL 传入URL作为KEY值停止其请求任务
 */
+ (void)cancelATaskWith:(NSString *)URL;

/**
 暂停单个的请求任务,不包括NSURLSessionStreamTask
 
 @param URL 传入URL作为KEY值暂停任务
 */
+ (void)suspendATaskWith:(NSString *)URL;

/**
 恢复单个的请求任务,不包括NSURLSessionStreamTask
 
 @param URL 传入URL作为KEY值恢复任务
 */
+ (void)resumeATaskWith:(NSString *)URL;

#pragma mark --AFNetworking网络请求图片缓存策略--

/**
 UIButton和UIImageView的图片缓存,内存缓存和硬盘缓存,如果不用AFNetworking的图片缓存机制,最好不要调用该方法避免无用内存加载
 */
+ (void)setCacheForUIButtonAndUIImageView;

@end

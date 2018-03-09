//
//  CUHTTPRequest.m
//  CUHTTPRequest
//
//  Created by yxliu on 2017/9/20.
//

#import "CUHTTPRequest.h"
#import "AFNetworking/AFNetworking.h"
#import "UIKit+AFNetworking.h"

@implementation CUHTTPRequest

+ (void)customSecurityPolicyWithCerPath:(NSString *)path {
    NSData *certData = [NSData dataWithContentsOfFile:path];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    NSSet *set = [NSSet setWithArray:@[certData]];
    [securityPolicy setPinnedCertificates:set];
    AFHTTPSessionManager *manager = [self getSessionManagerCustom];
    [manager setSecurityPolicy:securityPolicy];
    
    //关闭缓存避免干扰测试r
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    NSString *p12Path = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:p12Path]) {
        return;
    }
    //启用双向认证需要下面的代码，如果只是单向认证则不需要下面代码，下面是开启客户端验证的代码。
    __weak typeof(manager)weakSelf = manager;
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        __strong typeof(manager) man = weakSelf;
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential =nil;
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if([man.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition =NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            // 客户端验证
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            //客户端证书路径
            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:p12]){ NSLog(@"client.p12:not exist"); }
            else {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                if ([self extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data]) {
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[] = {certificate};
                    CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition = NSURLSessionAuthChallengeUseCredential;
                    CFRelease(certArray);
                }
            }
        }
        *_credential = credential;
        return disposition;
    }];
}

+ (BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //客户端证书密码
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:@"123456"
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        return NO;
    }
    return YES;
}

+ (void)setHTTPHeader:(NSDictionary *)header {
    AFHTTPSessionManager *manager = [self getSessionManagerCustom];
    for (NSString *key in header) {
        NSString *value = header[key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

#pragma mark --网络状态--

+ (void)netWorkDuplicates:(BOOL)isDuplicates status:(void (^)(CUHTTPNetworkType))statusNetWork {
    AFNetworkReachabilityManager *__weak reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            statusNetWork(NetworkType_Unknown);
        } else if (status == AFNetworkReachabilityStatusNotReachable) {
            statusNetWork(NetworkType_NO);
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            /*
             //采用遍历查找状态栏的显示网络状态的子视图,通过判断该子视图的类型来更详细的判断网络类型
             NSArray *subviewArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
             NSInteger typeViewState = 0;
             for (id subview in subviewArray) {
             if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
             //0:无网,1:2G,2:3G,3:4G,5:WIFI
             typeViewState = [[subview valueForKeyPath:@"dataNetworkType"] integerValue];
             if (typeViewState == 1) {
             statusNetWork(NetworkType_2G);
             break;
             } else if (typeViewState == 2) {
             statusNetWork(NetworkType_3G);
             break;
             } else if (typeViewState == 3) {
             statusNetWork(NetworkType_4G);
             break;
             }
             }
             }
             */
            statusNetWork(NetworkType_WWAN);
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            statusNetWork(NetworkType_WiFi);
        }
        if (!isDuplicates) {
            [reachability stopMonitoring];
        }
    }];
}

#pragma mark --HTTP/HTTPS的Session基础设置--

static AFHTTPSessionManager *sessionManager = nil;
+ (AFHTTPSessionManager *)getSessionManagerCustom {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [AFHTTPSessionManager manager];
        sessionManager.attemptsToRecreateUploadTasksForBackgroundSessions = YES;
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        sessionManager.requestSerializer.timeoutInterval = 120.0;
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/force-download", @"application/soap+xml; charset=utf-8",@"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/html; charset=iso-8859-1", @"text/html; charset=utf-8", @"text/plain",@"text/css",@"application/x-plist",@"image/*", nil];
    });
    return sessionManager;
}

+ (NSString *)URLEncoding:(NSString *)URL {
    return [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark --GET--

//GET请求获得数据
+ (void)GET:(NSString *)URL parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    [session GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
        NSInteger statusCode = [response statusCode];
        if (failure) {
            failure(statusCode);
        }
    }];
}

//GET下载文件
+ (void)GETDownload:(NSString *)URL parameters:(id)parameters filePath:(NSString *)filePath success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    [session GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *finalFilePath = [NSString stringWithFormat:@"%@/%@",filePath,task.response.suggestedFilename];
        BOOL isOK = [responseObject writeToFile:finalFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if (!isOK) {
            NSLog(@"写入文件错误,文件无法下载到指定位置");
        } else {
            if (success) {
                success(finalFilePath);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
        NSInteger statusCode = [response statusCode];
        if (failure) {
            failure(statusCode);
        }
    }];
}

#pragma mark --HEAD--

+ (void)HEAD:(NSString *)URL parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    [session HEAD:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task) {
        if (success) {
            NSDictionary *dict = @{
                                   @"任务描述性标签":task.taskDescription,
                                   @"文件类型":task.response.suggestedFilename,
                                   @"收到的字节数":[NSString stringWithFormat:@"%lld",task.countOfBytesReceived],
                                   @"希望收到的字节数":[NSString stringWithFormat:@"%lld",task.countOfBytesExpectedToReceive]
                                   };
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
        NSInteger statusCode = [response statusCode];
        if (failure) {
            failure(statusCode);
        }
    }];
}

#pragma mark --PUT--

+ (void)PUT:(NSString *)URL parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    //PUT 文件上传
    [session PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
        NSInteger statusCode = [response statusCode];
        if (failure) {
            failure(statusCode);
        }
    }];
}

#pragma mark --PATCH--

+ (void)PATCH:(NSString *)URL parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    [session PATCH:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
        NSInteger statusCode = [response statusCode];
        if (failure) {
            failure(statusCode);
        }
    }];
}

#pragma mark --DELETE--

+ (void)DELETE:(NSString *)URL parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    [session DELETE:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
        NSInteger statusCode = [response statusCode];
        if (failure) {
            failure(statusCode);
        }
    }];
}

#pragma mark --POST--
//POST请求获得数据
+ (void)POST:(NSString *)URL parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    if (parameters && [parameters isKindOfClass:[NSString class]]) {
        //根据指定的block设置一个自定义查询字符序列化的方法
        [session.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            if (error) {
                return nil;
            }
            return [NSString stringWithFormat:@"%@",parameters];
        }];
    }
    [session POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
        NSInteger statusCode = [response statusCode];
        if (failure) {
            failure(statusCode);
        }
    }];
}

+ (void)POSTUpload:(NSString *)URL parameters:(id)parameters uploadType:(CUHTTPNetworkUploadDownloadType)uploadType dataArray:(NSArray<NSData *> *)arrayData success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    //    NSString *stringBoundary = @"---------";
    //    [session.requestSerializer setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary] forHTTPHeaderField:@"Content-Type"];///这个地方需要服务器给出,不然就是AF里面默认的.
    /*
     采用的是uploadTaskWithStreamedRequest:方法上传
     */
    [session POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         name：部分是服务器用来解析的字段
         fileName则是直接上传上去的图片或视频等等
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *str = [formatter stringFromDate:[NSDate date]];
         */
        if (uploadType == UploadDownloadType_Images) {
            for (NSInteger i = 0; i < arrayData.count; i++) {
                NSTimeInterval time = [NSDate date].timeIntervalSince1970 * 1000;
                NSString *name = [NSString stringWithFormat:@"file%.0f",time + i];
                name = @"file";
                [formData appendPartWithFileData:arrayData[i] name:name fileName:[NSString stringWithFormat:@"%@_%ld.jpg",name,(long)i] mimeType:@"image/jpeg"];
            }
        } else if (uploadType == UploadDownloadType_Videos) {
            for (NSInteger i = 0; i < arrayData.count; i++) {
                NSTimeInterval time = [NSDate date].timeIntervalSince1970 * 1000;
                NSString *name = [NSString stringWithFormat:@"video%.0f",time + i];
                [formData appendPartWithFileData:arrayData[i] name:name fileName:[NSString stringWithFormat:@"%@_%ld.mov",name,(long)i] mimeType:@"video/quicktime"];//video/mpeg4
            }
        } else {
            NSLog(@"没有选择上传类型,不能上传");
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
        NSInteger statusCode = [response statusCode];
        if (failure) {
            failure(statusCode);
        }
    }];
}

#pragma mark --断点上传--

+ (void)upload:(NSString *)URL uploadData:(NSData *)uploadData success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    //采用的是uploadTaskWithRequest: fromData:方法上传的数据
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]] fromData:uploadData progress:nil completionHandler:^(NSURLResponse * _Nonnull responses, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
            NSInteger statusCode = [response statusCode];
            failure(statusCode);
        } else {
            success(responseObject);
        }
    }];
    [task resume];
}

#pragma mark --下载--

+ (void)download:(NSString *)URL filePath:(NSString *)filePath success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    URL = [CUHTTPRequest URLEncoding:URL];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull responses) {
        NSString *path = [filePath stringByAppendingPathComponent:responses.suggestedFilename];
        //将下载文件保存在缓存路径中,指定下载文件保存的路径
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull responses, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
            NSInteger statusCode = [response statusCode];
            failure(statusCode);
        } else {
            success(filePath);
        }
    }];
    [task resume];
}

+ (void)downloadBreakpoint:(NSData *)data filePath:(NSString *)filePath success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    NSURLSessionDownloadTask *task = [session downloadTaskWithResumeData:data progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull responses) {
        //将下载文件保存在缓存路径中,指定下载文件保存的路径
        NSString *path = [filePath stringByAppendingPathComponent:responses.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull responses, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *) [task response];
            NSInteger statusCode = [response statusCode];
            failure(statusCode);
        } else {
            success(filePath);
        }
    }];
    [task resume];
}

#pragma mark --请求的状态--

+ (NSURLSessionTaskState)requestATaskStateWith:(NSString *)URL {
    NSURLSessionTask *task = [self.class requestATaskWith:URL];
    return task?task.state:NSURLSessionTaskStateCompleted;
}

+ (NSURLSessionTask *)requestATaskWith:(NSString *)URL {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    for (NSURLSessionTask *task in session.tasks) {
        BOOL isTask = [task.originalRequest.URL.absoluteString isEqualToString:URL];
        if (isTask) {
            return task;
        }
        //服务器重定向导致的request变更,这个地方理解不深,可能出现错误
        isTask = [task.currentRequest.URL.absoluteString isEqualToString:URL];
        if (isTask) {
            return task;
        }
    }
    return nil;
}

#pragma mark --停止请求的方法--
//取消所有的请求,和所有的NSURLSessionTask回调代理
+ (void)cancelAllTasksAndOperationQueues {
    AFHTTPSessionManager *session = [self.class getSessionManagerCustom];
    for (NSURLSessionTask *task in session.tasks) {
        [task cancel];
    }
    [session.operationQueue cancelAllOperations];
}

//取消单个的会话任务
+ (void)cancelATaskWith:(NSString *)URL {
    NSURLSessionTask *task = [self.class requestATaskWith:URL];
    [task cancel];
}

//暂停单个的请求任务
+ (void)suspendATaskWith:(NSString *)URL {
    NSURLSessionTask *task = [self.class requestATaskWith:URL];
    [task suspend];
}

//恢复单个的请求任务
+ (void)resumeATaskWith:(NSString *)URL {
    NSURLSessionTask *task = [self.class requestATaskWith:URL];
    [task resume];
}

#pragma mark --AFNetwork网络请求图片缓存策略--
//UIButton和UIImageView的图片缓存,内存缓存和硬盘缓存,如果不用AFNetworking的图片缓存机制,最好不要调用该方法避免无用内存加载
+ (void)setCacheForUIButtonAndUIImageView {
    [UIButton setSharedImageDownloader:[UIButton sharedImageDownloader]];
    [UIImageView setSharedImageDownloader:[UIImageView sharedImageDownloader]];
}

@end

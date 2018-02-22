//
//  CUPayTool.h
//  Pods-CUPayTool_Example
//
//  Created by yxliu on 2018/2/12.
//

#import <Foundation/Foundation.h>

#import <WXApi.h>
#import <WechatAuthSDK.h>

#import <AlipaySDK/AlipaySDK.h>

/**
 respCode:
 
 @param respCode
 0    -    支付成功
 -1   -    支付失败
 -2   -    支付取消
 -3   -    未安装App(适用于微信)
 -99  -    未知错误
 @param respMsg 返回信息
 */
typedef void(^CUPayToolRespBlock)(NSInteger respCode, NSString *respMsg);

@interface CUPayTool : NSObject <WXApiDelegate>

/**
 获取支付工具实例

 @return 支付工具实例
 */
+ (CUPayTool *)getInstance;

#pragma mark - WeChat Pay -

/**
 微信支付结果回调
 */
@property (nonatomic, copy) CUPayToolRespBlock wechatRespBlock;

/**
 检查是否安装微信
 
 @return 是否安装微信
 */
+ (BOOL)isWXAppInstalled;

/**
 注册微信appId
 
 @param appId appId
 @return 返回值
 */
+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId;

/**
 处理微信通过URL启动App时传递回来的数据
 
 @param url URL
 @return 返回值
 */
+ (BOOL)wechatHandleOpenURL:(NSURL *)url;

/**
 发起微信支付
 
 @param appId appId
 @param partnerId partnerId
 @param prepayId prepayId
 @param package package
 @param nonceStr nonceStr
 @param timeStamp timeStamp
 @param sign sign
 @param block block
 */
- (void)wechatPayWithAppId:(NSString *)appId
                 partnerId:(NSString *)partnerId
                  prepayId:(NSString *)prepayId
                   package:(NSString *)package
                  nonceStr:(NSString *)nonceStr
                 timeStamp:(NSString *)timeStamp
                      sign:(NSString *)sign
                 respBlock:(CUPayToolRespBlock)block;

#pragma mark - Alipay -

/**
 支付宝结果回调
 */
@property (nonatomic, copy) CUPayToolRespBlock alipayRespBlock;

/**
 处理支付宝通过URL启动App时传递回来的数据
 
 @param url url
 @return 返回值
 */
+ (BOOL)alipayHandleOpenURL:(NSURL *)url;

/**
 发起支付宝支付
 
 @param order order
 @param scheme scheme
 @param block block
 */
- (void)aliPayOrder:(NSString *)order
             scheme:(NSString *)scheme
          respBlock:(CUPayToolRespBlock)block;

@end

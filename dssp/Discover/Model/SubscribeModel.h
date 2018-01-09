//
//  SubscribeModel.h
//  dssp
//
//  Created by qinbo on 2017/12/28.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
@interface SubscribeModel : NSObject
@property (nonatomic , assign) NSInteger              currentPage;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , copy)   NSString              * subscribeId;
@property (nonatomic , copy)   NSString              * name;
@property (nonatomic , copy)   NSString              * depict;
@property (nonatomic , copy)   NSString              * isEnable;
@property (nonatomic , copy)   NSString              * piority;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              lastUpdateTime;
@property (nonatomic , copy)   NSString              * isDel;
@end


@interface ChannelModel : NSObject<YYModel>
@property (nonatomic , assign) NSInteger              currentPage;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , copy) NSString              * listId;
@property (nonatomic , copy) NSString              * channelId;
@property (nonatomic , copy) NSString              * channelName;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * piority;
@property (nonatomic , copy) NSString              * depict;
@property (nonatomic , copy) NSString              * picture1;
@property (nonatomic , copy) NSString              * picture2;
@property (nonatomic , copy) NSString              * readingVolume;
@property (nonatomic , copy) NSString              * invalidTime;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , copy) NSString              * lastUpdateTime;
@property (nonatomic , copy) NSString              * isDel;
@property (nonatomic , copy) NSString              * isTop;
@end


@interface SubscribedatailModel : NSObject<YYModel>
@property (nonatomic , assign) NSInteger              currentPage;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , copy) NSString              * subscribedataiId;
@property (nonatomic , copy) NSString              * channelId;
@property (nonatomic , copy) NSString              * channelName;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * piority;
@property (nonatomic , copy) NSString              * depict;
@property (nonatomic , copy) NSString              * readingVolume;
@property (nonatomic , assign) NSInteger              invalidTime;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              lastUpdateTime;
@property (nonatomic , copy) NSString              * isDel;
@property (nonatomic , copy) NSString              * isTop;
@end

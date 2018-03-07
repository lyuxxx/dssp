//
//  Statistics.m
//  dssp
//
//  Created by qinbo on 2018/3/1.
//  Copyright © 2018年 capsa. All rights reserved.
//


//#define MY_ARRAY [[NSMutableArray alloc] init]
#import "Statistics.h"
#import "QDataSaver.h"
//#import "MassageModel.h"

@interface Statistics ()
//@property (nonatomic,strong) NSMutableArray *dataSources;
@end


@implementation Statistics
static NSMutableArray *dataSources;
/*
 key值-Value值对应关系:
 
 界面名称:----访问次数
 
 1界面名称----进入界面时刻
 
 2界面名称-----离开界面时刻
 
 界面名称histime------界面停留历史时间
 
 界面名称time--------界面停留总时间
 
 界面名称oppositeTime----相对时间
 */

+ (void)initialize
{
    dataSources = [[NSMutableArray alloc] init];
}

//+ (NSMutableArray *)dataSources {
//    if (!self.dataSources) {
//        dataSources = [[NSMutableArray alloc] init];
//    }
//    return dataSources;
//}
#pragma mark-

#pragma mark 统计次数

+(void)staticsvisitTimesDataWithViewControllerType:(NSString *)type
{
    NSString * timesStart=[QDataSaver getStringForKey:type]?[QDataSaver getStringForKey:type]:nil;
    
    int add=[timesStart intValue];
    add++;
    [QDataSaver saveString:[NSString stringWithFormat:@"%d",add] forKey:type];
}

+(void)staticsstayTimeDataWithType:(NSString *)type WithController:(NSString *)name//计算一次在该界面停留的时间
{
    switch ([type intValue]) {
        case 1://用来获取进入界面的时间
        {
            NSDate * date=[NSDate date];
            //用于格式化NSDate对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设置格式：zzz表示时区
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //NSDate转NSString
            NSString *currentDateString = [dateFormatter stringFromDate:date];
            
            NSString * dateStr=[NSString stringWithFormat:@"%0.f",[date timeIntervalSince1970]];
//            存储开始时间
            [QDataSaver saveString:currentDateString forKey:@"currentTime"];
            
            [QDataSaver saveString:dateStr forKey:[NSString stringWithFormat:@"%@%@",type,name]];
            
//           //点击btn
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSNumber *userId = [defaults objectForKey:@"userId"];
//            NSString *userIdStr = [userId stringValue];
//
//            NSDictionary * dic=@{@"userId":userIdStr,
//                                 @"deviceType":@"3",
//                                 @"businessCode":[NSString stringWithFormat:@"%@",name],
//                                 @"currentTime":[QDataSaver getStringForKey:@"currentTime"]
//                                 };
//            [dataSources addObject:dic];
//
//            NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/myJson.txt"];
//            //            NSDictionary *json_dic = @{@"arr":dataSources};//key为arr value为arr数组的字典
//            //            NSData *json_data = [NSJSONSerialization dataWithJSONObject:dataSources options:NSJSONWritingPrettyPrinted error:nil];
//            //数组转json存储
//            NSString *jsonString = [Statistics arrayToJSONString:dataSources];
//            [jsonString writeToFile:filePath atomically:YES];
            
        }
        break;
        case 2://用来获取离开界面的时间    /**/
        {
            NSDate * date=[NSDate date];
            
            NSString * dateStr=[NSString stringWithFormat:@"%0.f",[date timeIntervalSince1970]];
            
            [QDataSaver saveString:dateStr forKey:[NSString stringWithFormat:@"%@%@",type,name]];
            
            NSString * startTime=[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@%@",@"1",name]]?[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@%@",@"1",name]]:@"0";//进入界面时间
            
            NSString * endTime=[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@%@",@"2",name]]?[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@%@",@"2",name]]:@"0";;//离开界面时间
            
            long  time=0;
            
            if([endTime longLongValue]==0)
                
            {
                time=0;
                [QDataSaver removeStringForKey:[NSString stringWithFormat:@"%@%@",@"1",name]];//移除开始时间
                [QDataSaver removeStringForKey:[NSString stringWithFormat:@"%@%@",@"2",name]];
            }
            else
            {
                
                time=[endTime longLongValue]-[startTime longLongValue];
                
                [QDataSaver removeStringForKey:[NSString stringWithFormat:@"%@%@",@"1",name]];
                
                [QDataSaver removeStringForKey:[NSString stringWithFormat:@"%@%@",@"2",name]];
            }
            
            
            NSString * hisTime=[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@histime",name]];//历史时间
            
            long ZTime=[hisTime longLongValue]+time;
            
            NSString * Time=[NSString stringWithFormat:@"%ld",ZTime];//该界面的总时间
            
            [QDataSaver saveString:Time forKey:[NSString stringWithFormat:@"%@time",name]];//存储总时间
            
            [QDataSaver saveString:Time forKey:[NSString stringWithFormat:@"%@histime",name]];//存储历史时间
            
//            MassageModel *massageModel = [[MassageModel alloc] init];
//            massageModel.path = [NSString stringWithFormat:@"%@",name];
//            massageModel.userId = @"15871707603";
//            massageModel.deviceType = @"3";
//            massageModel.businessCode = @"";
//            massageModel.remainTime = longStr;
//            massageModel.currentTime = [CUDataSaver getStringForKey:[NSString stringWithFormat:@"%@%@",@"1",name]]?[CUDataSaver getStringForKey:[NSString stringWithFormat:@"%@%@",@"1",name]]:@"0";
//            NSString * time1=[Statistics getStayTime:[NSString stringWithFormat:@"%@",name]];//判断是否一直停留在该界面,离开取总时间,停留取相对时间
//
            
            NSNumber *longNumber = [NSNumber numberWithLong:time];
            NSString *longStr = [longNumber stringValue];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSNumber *userId = [defaults objectForKey:@"userId"];
            NSString *userIdStr = [userId stringValue];
           
            NSDictionary * dic=@{@"userId":userIdStr,
                                 @"deviceType":@"3",
                                 @"businessCode":[NSString stringWithFormat:@"%@",name],
                                 @"remainTime":longStr,
                                 @"currentTime":[QDataSaver getStringForKey:@"currentTime"]
                                 };
            [dataSources addObject:dic];

            NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/myJson.txt"];
//            NSDictionary *json_dic = @{@"arr":dataSources};//key为arr value为arr数组的字典
//            NSData *json_data = [NSJSONSerialization dataWithJSONObject:dataSources options:NSJSONWritingPrettyPrinted error:nil];
            //数组转json存储
            NSString *jsonString = [Statistics arrayToJSONString:dataSources];
            [jsonString writeToFile:filePath atomically:YES];
        }
        break;
        case 3://用来获取进入界面的时间
        {
            NSDate * date=[NSDate date];
            //用于格式化NSDate对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设置格式：zzz表示时区
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //NSDate转NSString
            NSString *currentDateString = [dateFormatter stringFromDate:date];
            
            NSString * dateStr=[NSString stringWithFormat:@"%0.f",[date timeIntervalSince1970]];
            //            存储开始时间
            [QDataSaver saveString:currentDateString forKey:@"currentTime"];
            
            [QDataSaver saveString:dateStr forKey:[NSString stringWithFormat:@"%@%@",type,name]];
            
            
            //点击btn
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSNumber *userId = [defaults objectForKey:@"userId"];
            NSString *userIdStr = [userId stringValue];
            
            NSDictionary * dic=@{@"userId":userIdStr,
                                 @"deviceType":@"3",
                                 @"businessCode":[NSString stringWithFormat:@"%@",name],
                                 @"currentTime":[QDataSaver getStringForKey:@"currentTime"]
                                 };
            [dataSources addObject:dic];
            
            NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/myJson.txt"];
            //            NSDictionary *json_dic = @{@"arr":dataSources};//key为arr value为arr数组的字典
            //            NSData *json_data = [NSJSONSerialization dataWithJSONObject:dataSources options:NSJSONWritingPrettyPrinted error:nil];
            //数组转json存储
            NSString *jsonString = [Statistics arrayToJSONString:dataSources];
            [jsonString writeToFile:filePath atomically:YES];
            
        }
            break;
        default:
            break;
    }
 
}


//数组转json
+(NSString *)arrayToJSONString:(NSArray *)array

{
    NSError *error = nil;
    //    NSMutableArray *muArray = [NSMutableArray array];
    //    for (NSString *userId in array) {
    //        [muArray addObject:[NSString stringWithFormat:@"\"%@\"", userId]];
    //    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"json array is: %@", jsonResult);
    return jsonString;
}


//字典转数组
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
//        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}


+(NSString *)staticsTimeDataWithController:(NSString *)name
{
    NSString * hisTime=[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@histime",name]];//历史时间
    
    NSString * startTime=[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@%@",@"1",name]]?[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@%@",@"1",name]]:@"0";//进入界面时间
    
    long oppositeTime=[hisTime longLongValue]-[startTime longLongValue];//相对时间,针对只有开始时间,一直停留在该界面的处理情况
    NSDate * date=[NSDate date];
    NSString * dateStr=[NSString stringWithFormat:@"%0.f",[date timeIntervalSince1970]];
    long time=[dateStr longLongValue]+oppositeTime;
    
    [QDataSaver saveString:[NSString stringWithFormat:@"%ld",time] forKey:[NSString stringWithFormat:@"%@ztime",name]];
    
    [QDataSaver saveString:dateStr forKey:[NSString stringWithFormat:@"%@%@",@"1",name]];
    
    [Statistics staticsvisitTimesDataWithViewControllerType:name];
    
    return [NSString stringWithFormat:@"%ld",time];
    
}

+(NSString *)getStayTime:(NSString *)controller
{
    NSString * time=[QDataSaver getStringForKey:[NSString stringWithFormat:@"1%@",controller]]&&![QDataSaver getStringForKey:[NSString stringWithFormat:@"2%@",controller]]?[Statistics staticsTimeDataWithController:[NSString stringWithFormat:@"%@",controller]]:[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@time",controller]];
    
    return time;
}

+(void)removeLocalDataWithController:(NSString *)name
{
    [QDataSaver removeStringForKey:[NSString stringWithFormat:@"%@",name]];
    
    [QDataSaver removeStringForKey:[NSString stringWithFormat:@"%@time",name]];
    
    [QDataSaver removeStringForKey:[NSString stringWithFormat:@"%@histime",name]];
    
//    Save(@"",@"StaticsArray");
    
//    Remove(@"StaticsArray");
    
}

+(NSDictionary *)packageDictionary:(NSString *)name WithType:(NSString *)type
//打包字典
{
    NSString * time=[Statistics getStayTime:[NSString stringWithFormat:@"%@",name]];//判断是否一直停留在该界面,离开取总时间,停留取相对时间
    
//    NSMutableArray * dataArray=Get(@"StaticsArray")?Get(@"StaticsArray"):[NSMutableArray array];
    
    NSMutableArray * dataArray = [NSMutableArray array];
    
    NSDictionary * dic=@{@"path":[NSString stringWithFormat:@"%@",name],@"visitType":[NSString stringWithFormat:@"%@",type],@"visitTimes":[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@",name]]?[QDataSaver getStringForKey:[NSString stringWithFormat:@"%@",name]]:@"0",@"staySeconds":time?time:@"0",@"deviceType":[NSString stringWithFormat:@"%@",@"2"]};
    
    [dataArray addObject:dic];
    
//    Save(dataArray, @"StaticsArray");
    
    NSDictionary * BigDic=@{@"list":dataSources};
    
    return BigDic;

}
@end

//
//  SubscriCell.m
//  dssp
//
//  Created by qinbo on 2017/12/20.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "SubscriCell.h"
#import <YYCategoriesSub/YYCategories.h>
#import "UIImageView+WebCache.h"
@implementation SubscriCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
        
    }
    return self;
}

-(void)createUI
{
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.contentView addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(110 * HeightCoefficient);
        make.top.equalTo(0 * HeightCoefficient);
    }];
    
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
    [self.contentView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1 * HeightCoefficient);
        make.left.equalTo(15 * WidthCoefficient);
        make.right.equalTo(0);
        make.bottom.equalTo(1 - 1 * HeightCoefficient);
    }];
    
    
    self.bgImgV = [[UIImageView alloc] init];
//    _bgImgV.image = [UIImage imageNamed:@"cell_bg"];
    [self.bgImgV setContentMode:UIViewContentModeScaleAspectFill];
    
    self.bgImgV.clipsToBounds = YES;
    _bgImgV.layer.cornerRadius = 2;
    _bgImgV.layer.masksToBounds =YES;
    [whiteV addSubview:_bgImgV];
    [_bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.height.equalTo(80 * HeightCoefficient);
        make.width.equalTo(85 * HeightCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
    }];
    
    
    self.remindLabel = [[UILabel alloc] init];
//    _remindLabel.backgroundColor =[UIColor redColor];
    _remindLabel.textAlignment = NSTextAlignmentLeft;
    _remindLabel.numberOfLines = 0;
    _remindLabel.textColor = [UIColor whiteColor];
    _remindLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//    _remindLabel.text = NSLocalizedString(@"22", nil);
    [self.contentView addSubview:_remindLabel];
    [_remindLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgImgV.left).offset(-15*WidthCoefficient);
        make.height.equalTo(50 * HeightCoefficient);
        make.left.equalTo(16 * HeightCoefficient);
        make.top.equalTo(15 * HeightCoefficient);
    }];
    
//    self.contentLabel = [[UILabel alloc] init];
//    [_contentLabel setNumberOfLines:0];
//    _contentLabel.textAlignment = NSTextAlignmentLeft;
//    _contentLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF "];
//    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
////    _contentLabel.text = NSLocalizedString(@"今年的广州车展期间,国产东风正式亮相,新车定位于紧凑型SUV，是目前DS品牌的全新的车型", nil);
//    [_bgImgV addSubview:_contentLabel];
//    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(339 * WidthCoefficient);
//        make.height.equalTo(40.5 * HeightCoefficient);
//        make.left.equalTo(10 * HeightCoefficient);
//        make.top.equalTo(_remindLabel.bottom).offset(10*HeightCoefficient);
//    }];
    
    
//    self.bottomLabel = [[UILabel alloc] init];
//    _bottomLabel.textAlignment = NSTextAlignmentLeft;
//    _bottomLabel.textColor = [UIColor colorWithHexString:@"#A18E79"];
//    _bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
//    _bottomLabel.text = NSLocalizedString(@"品牌", nil);
//    [whiteV addSubview:_bottomLabel];
//    [_bottomLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(22 * WidthCoefficient);
//        make.height.equalTo(15 * HeightCoefficient);
//        make.left.equalTo(16 * HeightCoefficient);
//        make.top.equalTo(_remindLabel.bottom).offset(21 * HeightCoefficient);
//    }];
    
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
//    _timeLabel.text = NSLocalizedString(@"| 30分钟前发布", nil);
    [whiteV addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(116 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.top.equalTo(_remindLabel.bottom).offset(21 * HeightCoefficient);;
    }];
}

-(void)setChannelModel:(ChannelModel *)channelModel
{
//     NSString *createTime = [NSString stringWithFormat:@"| %@",[self setWithTimeString:channelModel.createTime]];
    _remindLabel.text = NSLocalizedString(channelModel.title, nil);
    _contentLabel.text = NSLocalizedString(channelModel.content, nil);
//    _bottomLabel.text = NSLocalizedString(channelModel.channelName, nil);
    _timeLabel.text = [self setWithTimeString:channelModel.createTime];
    
     NSString *string = [channelModel.picture2 stringByReplacingOccurrencesOfString:@"tp=webp" withString:@""];
    
    [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@""]];


}

-(NSString *)setWithTimeString:(NSInteger)time
{
    if (time) {
        
        NSString *dueDateStr = [NSString stringWithFormat: @"%ld", time];
        NSString *publishString = dueDateStr;
        double publishLong = [publishString doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        
        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong/1000];
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        publishDate = [publishDate  dateByAddingTimeInterval: interval];
        publishString = [formatter stringFromDate:publishDate];
        return publishString;
        
        
    }else
    {
        return nil;
        
    }
    
}


- (CGSize)getImageSizeWithURL:(id)imageURL
{
    
    NSURL* URL = nil;
    
    if([imageURL isKindOfClass:[NSURL class]]){
        
        URL = imageURL;
        
    }
    
    if([imageURL isKindOfClass:[NSString class]]){
        
        URL = [NSURL URLWithString:imageURL];
        
    }
    
    if(URL == nil)
        
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    
    
    CGSize size = CGSizeZero;
    
    if([pathExtendsion isEqualToString:@"png"]){
        
        size =  [self getPNGImageSizeWithRequest:request];
        
    }
    
    else if([pathExtendsion isEqual:@"gif"])
        
    {
        
        size =  [self getGIFImageSizeWithRequest:request];
        
    }
    
    else{
        
        size = [self getJPGImageSizeWithRequest:request];
        
    }
    
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
        
    {
        
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        
        UIImage* image = [UIImage imageWithData:data];
        
        if(image)
            
        {
            
            size = image.size;
            
        }
        
    }
    
    return size;
    
}

-(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request

{
    
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length == 8)
        
    {
        
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        
        return CGSizeMake(w, h);
        
    }
    
    return CGSizeZero;
    
}

#pragma mark   获取gif图片的大小

- (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request

{
    
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length == 4)
        
    {
        
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        short w = w1 + (w2 << 8);
        
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        
        short h = h1 + (h2 << 8);
        
        return CGSizeMake(w, h);
        
    }
    
    return CGSizeZero;
    
}

#pragma mark   获取jpg图片的大小

-(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request

{
    
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    
    if ([data length] <= 0x58) {
        
        return CGSizeZero;
        
    }
    
    
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        
        short w = (w1 << 8) + w2;
        
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        
        short h = (h1 << 8) + h2;
        
        return CGSizeMake(w, h);
        
    } else {
        
        short word = 0x0;
        
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        
        if (word == 0xdb) {
            
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            
            if (word == 0xdb) {// 两个DQT字段
                
                short w1 = 0, w2 = 0;
                
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
                
            } else {// 一个DQT字段
                
                short w1 = 0, w2 = 0;
                
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
                
            }
            
        } else {
            
            return CGSizeZero;
            
        }
        
    }
    
}



- (UIImage *)imageFromURLString: (NSString *) urlstring
{
    // This call is synchronous and blocking
    return [UIImage imageWithData:[NSData
                                   dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}


-(UIImage*)image:(UIImage*)image fortargetSize: (CGSize)targetSize{
    
          UIImage *sourceImage = image;
    
          CGSize imageSize = sourceImage.size;//图片的size
    
          CGFloat imageWidth = imageSize.width;//图片宽度
    
          CGFloat imageHeight = imageSize.height;//图片高度
    
          NSInteger judge;//声明一个判断属性
    
           //判断是否需要调整尺寸(这个地方的判断标准又个人决定,在此我是判断高大于宽),因为图片是800*480,所以也可以变成480*800
    
           if(( imageHeight - imageWidth) > 0) {
        
                       //在这里我将目标尺寸修改成480*800
        
                       CGFloat tempW = targetSize.width;
        
                       CGFloat tempH = targetSize.height;
        
                       targetSize.height= tempW;
        
                       targetSize.width= tempH;
        
                }
    
             CGFloat targetWidth = targetSize.width;//获取最终的目标宽度尺寸
    
             CGFloat targetHeight = targetSize.height;//获取最终的目标高度尺寸
    
             CGFloat scaleFactor ;//先声明拉伸的系数
    
             CGFloat scaledWidth = targetWidth;
    
             CGFloat scaledHeight = targetHeight;
    
             CGPoint thumbnailPoint =CGPointMake(0.0,0.0);//这个是图片剪切的起点位置
    
             //第一个判断,图片大小宽跟高都小于目标尺寸,直接返回image
    
             if( imageHeight < targetHeight && imageWidth < targetWidth) {
        
                        return image;
        
                 }
    
           if ( CGSizeEqualToSize(imageSize, targetSize ) ==NO )
        
              {
            
                          CGFloat widthFactor = targetWidth / imageWidth;  //这里是目标宽度除以图片宽度
            
                           CGFloat heightFactor = targetHeight / imageHeight; //这里是目标高度除以图片高度
            
                           //分四种情况,
            
                           //第一种,widthFactor,heightFactor都小于1,也就是图片宽度跟高度都比目标图片大,要缩小
            
                    if(widthFactor <1 && heightFactor<1){
                
                               //第一种,需要判断要缩小哪一个尺寸,这里看拉伸尺度,我们的scale在小于1的情况下,谁越小,等下就用原图的宽度高度✖️那一个系数(这里不懂的话,代个数想一下,例如目标800*480  原图1600*800  系数就采用宽度系数widthFactor = 1/2  )
                
                        if(widthFactor > heightFactor){
                    
                                  judge =1;//右部分空白
                    
                                   scaleFactor = heightFactor; //修改最后的拉伸系数是高度系数(也就是最后要*这个值)
                    
                           }
                
                       else
                    
                          {
                        
                                      judge =2;//下部分空白
                        
                                      scaleFactor = widthFactor;
                        
                              }
                
            }
            
               else if(widthFactor >1&& heightFactor <1){
                
                           //第二种,宽度不够比例,高度缩小一点点(widthFactor大于一,说明目标宽度比原图片宽度大,此时只要拉伸高度系数)
                
                           judge =3;//下部分空白
                
                            //采用高度拉伸比例
                
                           scaleFactor = imageWidth / targetWidth;// 计算高度缩小系数
                
            }else if(heightFactor >1&& widthFactor <1){
                
                         //第三种,高度不够比例,宽度缩小一点点(heightFactor大于一,说明目标高度比原图片高度大,此时只要拉伸宽度系数)
                
                         judge =4;//下边空白
                
                         //采用高度拉伸比例
                
                        scaleFactor = imageHeight / targetWidth;
                
                     }else{
                    
                               //第四种,此时宽度高度都小于目标尺寸,不必要处理放大(如果有处理放大的,在这里写).
                    
                         }
            
                   scaledWidth= imageWidth * scaleFactor;
            
                   scaledHeight = imageHeight * scaleFactor;
            
        }
    
    if(judge ==1){
        
               //右部分空白
        
               targetWidth = scaledWidth;//此时把原来目标剪切的宽度改小,例如原来可能是800,现在改成780
        
    }else if(judge ==2){
        
        //下部分空白
        
               targetHeight = scaledHeight;
        
    }else if(judge ==3){
        
              //第三种,高度不够比例,宽度缩小一点点
        
               targetWidth  = scaledWidth;
        
    }else{
        
              //第三种,高度不够比例,宽度缩小一点点
        
               targetHeight= scaledHeight;
        
    }
    
          UIGraphicsBeginImageContext(targetSize);//开始剪切
    
          CGRect thumbnailRect =CGRectZero;//剪切起点(0,0)
    
          thumbnailRect.origin= thumbnailPoint;
    
          thumbnailRect.size.width= scaledWidth;
    
          thumbnailRect.size.height= scaledHeight;
    
           [sourceImage drawInRect:thumbnailRect];
    
           UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
    
        return newImage;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  JC_Tools.m
//  JC_Tools
//  Created by JackerooChu on 2021/5/8.
//
//
//
//  If debugging a program bothers you, don't give up.
//    Success is always around the corner.
//    You never know how far you are from him unless you come to the corner.
//    So remember,
//    persevere until you succeed.
//
        
//MARK:--应用程序的屏幕宽高
#define kWindowH   UIApplication.sharedApplication.keyWindow.frame.size.height
#define kWindowW   UIApplication.sharedApplication.keyWindow.frame.size.width
#import "JC_Tools.h"


dispatch_source_t timer;

@implementation JC_Tools

//电话号码匹配
+ (BOOL)checkPhoneNumInput:(NSString *)phoneStr
{
    NSString *photoRange = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";//正则表达式
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",photoRange];
    BOOL result = [regexMobile evaluateWithObject:phoneStr];
    if (result)
    {
        return YES;
    } else
    {
        return NO;
    }
}
//截屏
+ (UIImage *)screenShot{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowW, kWindowH), YES, 0);
    //设置截屏大小
    [[UIApplication.sharedApplication.keyWindow layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
//判断昵称只能由中文、字母或数字组成
+ (BOOL)judgeUserNameStrForLetterAndDigital:(NSString *)text{
    NSString * regex = @"^[\u4e00-\u9fa5a-zA-Z-z0-9]{3,14}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:text];
    return isMatch;
}
#pragma mark - 匹配6-12位的密码
+ (BOOL)matchPassword:(NSString *)password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL result = [regexMobile evaluateWithObject:password];
    if (result)
    {
        return YES;
    } else
    {
        return NO;
    }
}
//MARK:--时间字符串转化 formatterStr为转化格式 yyyy/MM/dd HH:mm:ss
+(NSString *)transformForTimeString:(NSString *)timeStr withFormatterStr:(NSString *)formatterStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *array = [timeStr componentsSeparatedByString:@" "];
    if (array.count == 1) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *someDay = [formatter dateFromString:timeStr];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:formatterStr];
    NSString *currentDateString = [formatter1 stringFromDate:someDay];
    return currentDateString;
}
//MARK:--判断是否含有表情文字
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

//判断当前控制器
+ (UIViewController *)getCurrentViewController{
    
    UIViewController* currentViewController = [self getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}
+ (UIViewController *)getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}
//改变字符串某个颜色
+(NSMutableAttributedString *)changeColorForStr:(NSString *)contentStr withChangeColorStr:(NSString *)changeStr withChangeColor:(UIColor *)changeColor withFont:(UIFont *)font{
    contentStr = [NSString stringWithFormat:@"%@",contentStr];
    changeStr = [NSString stringWithFormat:@"%@",changeStr];
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[contentAttributedString string] rangeOfString:changeStr].location, [[contentAttributedString string] rangeOfString:changeStr].length);
    //修改特定字符的颜色
    [contentAttributedString setAttributes:@{NSForegroundColorAttributeName: changeColor,NSFontAttributeName:font} range:redRange];
    [contentAttributedString addAttribute:NSForegroundColorAttributeName value:changeColor range:redRange];
    return contentAttributedString;
    
}
//改变富文本字符串某个颜色
+(NSMutableAttributedString *)changeColorForAttributedString:(NSMutableAttributedString *)contentStr withChangeColorStr:(NSString *)changeStr withChangeColor:(UIColor *)changeColor withFont:(UIFont *)font{
    changeStr = [NSString stringWithFormat:@"%@",changeStr];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:changeStr].location, [[contentStr string] rangeOfString:changeStr].length);
    //修改特定字符的颜色
    [contentStr setAttributes:@{NSForegroundColorAttributeName: changeColor,NSFontAttributeName:font} range:redRange];
    [contentStr addAttribute:NSForegroundColorAttributeName value:changeColor range:redRange];
    return contentStr;
}
//MARK--计算文字的高度
+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font withSpacing:(CGFloat)space {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = space;
    NSDictionary *dic = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle };
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  ceilf(size.height);
}
//MARK--计算文字的宽度
+ (CGFloat)getWidthLineWithString:(NSString *)string withHeight:(CGFloat)height withFont:(UIFont *)font{
    
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);     //设置字符串的宽高  MAXFLOAT为最大宽度极限值  height为固定高度
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.width); //此方法结合  预编译字符串  字体font  字符串宽高  三个参数计算文本  返回字符串宽度
    
}
//MARK:--字符串转译处理
+(NSString *)getEncodedString:(NSString *)string{
    
    for (int i=0; i<string.length; i++) {
        NSRange range =NSMakeRange(i, 1);
        NSString * strFromSubStr=[string substringWithRange:range];
        const char * cStringFromstr=[strFromSubStr UTF8String];
        if (strlen(cStringFromstr)==3) {
            //有汉字
            string = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
            
        }
    }
    return string;
}

//MARK:--字符串生成二维码
+ (UIImage *)createNonInterpolatedUIImageForQRForString:(NSString *)qrString withSize:(CGFloat) size withWaterimageName:(NSString *)waterimageName withWaterimageSize:(CGFloat)waterimageSize{
    
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    CIImage *image = qrFilter.outputImage;
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //水印图
    UIImage *waterimage = [UIImage imageNamed:waterimageName];
    [waterimage drawInRect:CGRectMake((size-waterimageSize)/2.0, (size-waterimageSize)/2.0, waterimageSize, waterimageSize)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
//MARK:--- 计算两个经纬度之间的距离
+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lng1 :(double)lat2 :(double)lng2 {
    
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //返回 m
    return   distance;
}

//MARK:--- 隐藏手机号中间位数
+(NSString *)hidePhoneCenterNumWithPhone:(NSString *)phone{
    if (phone.length >= 7) {
        NSString *beforeStr = [phone substringToIndex:3];
        NSString *backStr = [phone substringFromIndex:phone.length- 4 ];
        NSString *telStr = [NSString stringWithFormat:@"%@****%@",beforeStr,backStr];
        phone = telStr;
    }
    return phone;
}
//MARK:--判断身份证号是否正确
+(BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) {
        return NO;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
                NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
                
                //4：检测ID的校验位
                if ([lastStr isEqualToString:@"x"]) {
                    if ([M isEqualToString:@"X"]) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                        return YES;
                    }else {
                        return NO;
                    }
                }
            }else {
                return NO;
            }
        default:
            return NO;
    }
}
//MARK:--获取当前时间（毫秒）
+ (NSString *)getCurrentTimeMilliSecond {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}
//MARK:--拨打号码
+(void)callPhoneNumber{
    //客服专线拨号---会回去到原来的程序里,也会弹出提示
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//MARK:--获取当前日期 yyyyMMdd yyyy-MM-dd HH:mm:ss HH:mm MM/dd
+ (NSString *)getCurrentTimeWithFormatterStr:(NSString *)formatterStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//MARK:--当前日期加减天数
+(NSString *)addOrRediceWithDateStr:(NSString *)dateStr withYear:(NSInteger)year withMonth:(NSInteger)month withDay:(NSInteger)day withHour:(NSInteger)hour withMinute:(NSInteger)minute{
    NSCalendar *calender2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calender2 setFirstWeekday:2];// 国外是从周日 开始算的 我们是周一 所以 写了2
    NSDateComponents *components2 = nil;
    NSDate *currentDate;
    if (dateStr.length==0) {
        currentDate = [self getCurrentTimeDateWithFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        currentDate = [self stringTransformDate:dateStr withFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
    }
    components2 = [calender2 components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc]init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    [adcomps setHour:hour];
    [adcomps setMinute:minute];
    NSDate *newdate = [calender2 dateByAddingComponents:adcomps toDate:currentDate options:0];
    return [self dateTransformString:newdate withFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)getTimeWithFormatterStr:(NSString *)formatterStr contentStr:(NSString *)contentStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *array = [contentStr componentsSeparatedByString:@" "];
    if (array.count == 1) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *someDay = [formatter dateFromString:contentStr];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:formatterStr];
    NSString *currentDateString = [formatter1 stringFromDate:someDay];
    return currentDateString;
}
//MARK:--NSDate转字符串
+ (NSString *)dateTransformString:(NSDate *)date withFormatterStr:(NSString *)formatterStr{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    // 下面的格式设置成你想要转化的样子, 2017-07-24 17:47:10
    [formatter setDateFormat:formatterStr];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}
//MARK:--获取当前日期NSDate
+ (NSDate *)getCurrentTimeDateWithFormatterStr:(NSString *)formatterStr{
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatterStr];
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    nowDate = [nowDate dateByAddingTimeInterval:interval];
    return nowDate;
}
//MARK:--当前字符串转date
+ (NSDate *)stringTransformDate:(NSString *)timeStr withFormatterStr:(NSString *)formatterStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *someDay = [formatter dateFromString:timeStr];
    return someDay;
}
+ (NSString *)getCurrentTimeStamp{
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[nowDate timeIntervalSince1970]];
    return timeStamp;
}
//MARK:--设置View圆角
+(void)setViewCornersWithView:(UIView *)view withViewFrame:(CGRect)viewFrame withCorners:(UIRectCorner)corners withCornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewFrame byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = view.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+(NSString*)getPhoneVersion{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}
+ (NSString *)getAppVersion{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

//MARK:--计算图片collection的高度并刷新collection
+(CGFloat)calculateCollectionHeightWithNum:(NSInteger)num withArrCount:(NSInteger)arrCount withBgHeight:(CGFloat)height withSpace:(NSInteger)space{
    NSInteger totalNum;
    NSInteger num1 = arrCount/num;
    NSInteger num2 = arrCount%num;
    if (num2 == 0) {
        totalNum = num1;
    }else{
        totalNum = num1+1;
    }
    return height*totalNum+(totalNum-1)*space;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


//MARK:--比较日期大小默认会比较到秒
+(int)compareOneDayStr:(NSString *)oneDayStr withAnotherDayStr:(NSString *)anotherDayStr{
    NSDate *dateA = [self stringTransformDate:oneDayStr withFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateB = [self stringTransformDate:anotherDayStr withFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    }else if (result ==NSOrderedAscending){
        return -1;
    }else{
        return 0;
    }
}

//MARK:--图片的Url转成UIImage
+(UIImage *)getImageFromURL:(NSString *)fileURL{
    
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
    
}
+ (NSString *) compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    
    //得到两个时间差
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}
+(NSInteger )dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
  
    NSDate *startD =[self stringTransformDate:startTime withFormatterStr:@"yyyy-MM-dd HH:mm"];
    NSDate *endD =[self stringTransformDate:endTime withFormatterStr:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
//    NSInteger second = (int)value /60;//秒
//    NSInteger minute = (int)value /60%60;
//    NSInteger house = (int)value % (24 * 3600)/3600;
//    NSInteger day = (int)value / (24 * 3600);
    return value;
}
+ (UIColor *)generateDynamicColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        UIColor *dyColor =
            [UIColor colorWithDynamicProvider:^UIColor *_Nonnull(UITraitCollection *_Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return darkColor;
                } else {
                    return lightColor;
                }
            }];
        return dyColor;
    } else {
        return lightColor;
    }
}

+ (BOOL)includeChinese:(NSString *)string {
    for (int i = 0; i < [string length]; i++) {
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end

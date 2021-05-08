//
//  JC_Tools.h
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
        

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JC_Tools : NSObject
+ (BOOL)checkPhoneNumInput:(NSString *)phoneStr;//电话号码匹配
//截图
+ (UIImage *)screenShot;
//判断昵称只能由中文、字母或数字组成
+ (BOOL)judgeUserNameStrForLetterAndDigital:(NSString *)text;
//匹配6-12位的密码
+ (BOOL)matchPassword:(NSString *)password;

//MARK:--时间字符串转化 formatterStr为转化格式 yyyy/MM/dd HH:mm:ss
+(NSString *)transformForTimeString:(NSString *)timeStr withFormatterStr:(NSString *)formatterStr;
//MARK:--判断是否含有表情文字
+ (BOOL)stringContainsEmoji:(NSString *)string;

//判断当前控制器
+ (UIViewController *)getCurrentViewController;

//改变字符串某个颜色
+(NSMutableAttributedString *)changeColorForStr:(NSString *)contentStr withChangeColorStr:(NSString *)changeStr withChangeColor:(UIColor *)changeColor withFont:(UIFont *)font;
//改变富文本字符串某个颜色
+(NSMutableAttributedString *)changeColorForAttributedString:(NSMutableAttributedString *)contentStr withChangeColorStr:(NSString *)changeStr withChangeColor:(UIColor *)changeColor withFont:(UIFont *)font;

//MARK--计算文字的高度
+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font withSpacing:(CGFloat)space;

//MARK--计算文字的宽度
+ (CGFloat)getWidthLineWithString:(NSString *)string withHeight:(CGFloat)height withFont:(UIFont *)font;

//MARK:--字符串转译处理
+(NSString *)getEncodedString:(NSString *)string;


//MARK:--字符串生成二维码
+ (UIImage *)createNonInterpolatedUIImageForQRForString:(NSString *)qrString withSize:(CGFloat) size withWaterimageName:(NSString *)waterimageName withWaterimageSize:(CGFloat)waterimageSize;

//MARK:--- 计算两个经纬度之间的距离
+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lng1 :(double)lat2 :(double)lng2;

//MARK:--- 判断UITextField小数点位数
+ (UITextField *)judgeDecimalPointForTextField:(UITextField *)sender withVC:(UIViewController *)vc withPoint:(NSInteger)point;

//MARK:--- 隐藏手机号中间位数
+(NSString *)hidePhoneCenterNumWithPhone:(NSString *)phone;

//MARK:--判断身份证号是否正确
+(BOOL)validateIDCardNumber:(NSString *)value;

//MARK:--获取当前时间（毫秒）
+ (NSString *)getCurrentTimeMilliSecond;

//MARK:--拨打号码
+(void)callPhoneNumber;

//MARK:--获取当前日期
+ (NSString *)getCurrentTimeWithFormatterStr:(NSString *)formatterStr;

//MARK:--获取当前日期
+ (NSString *)getCurrentTimeStamp;

//MARK:--获取指定格式的时见日期
+ (NSString *)getTimeWithFormatterStr:(NSString *)formatterStr contentStr:(NSString *)contentStr;
//MARK:--获取当前日期NSDate
+ (NSDate *)getCurrentTimeDateWithFormatterStr:(NSString *)formatterStr;

//MARK:--当前字符串转date
+ (NSDate *)stringTransformDate:(NSString *)timeStr withFormatterStr:(NSString *)formatterStr;

//MARK:--当前日期加减天数
+(NSString *)addOrRediceWithDateStr:(NSString *)dateStr withYear:(NSInteger)year withMonth:(NSInteger)month withDay:(NSInteger)day withHour:(NSInteger)hour withMinute:(NSInteger)minute;

//MARK:--设置View圆角
+(void)setViewCornersWithView:(UIView *)view withViewFrame:(CGRect)viewFrame withCorners:(UIRectCorner)corners withCornerRadii:(CGSize)cornerRadii;

/**获取手机系统版本*/
+(NSString*)getPhoneVersion;
/**获取App版本*/
+(NSString*)getAppVersion;

//MARK:--计算图片collection的高度并刷新collection
+(CGFloat)calculateCollectionHeightWithNum:(NSInteger)num withArrCount:(NSInteger)arrCount withBgHeight:(CGFloat)height withSpace:(NSInteger)space;

//MARK:--json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//MARK:--比较日期大小默认会比较到秒
+(int)compareOneDayStr:(NSString *)oneDayStr withAnotherDayStr:(NSString *)anotherDayStr;

//MARK:--图片的Url转成UIImage
+(UIImage *)getImageFromURL:(NSString *)fileURL;
//MARK:--显示发送时间（几分钟前，几小时前，几天前）
+(NSString *)compareCurrentTime:(NSString *)str;
//MARK:--两个时间差多少秒
+(NSInteger )dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
/**
动态颜色设置

 @param lightColor  亮色
 @param darkColor  暗色
 @return 修正后的图片
*/
+ (UIColor *)generateDynamicColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;
/// 判断字符串中是否包含汉字
+ (BOOL)includeChinese:(NSString *)string;
@end

NS_ASSUME_NONNULL_END

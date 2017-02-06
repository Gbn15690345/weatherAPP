//
//  FutureWeatherViewController.h
//  天气
//
//  Created by  wyzc02 on 16/12/16.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FutureWeatherViewController : UIViewController
@property (nonatomic,strong)UIImageView * backImage;
//当前日期
@property (nonatomic,strong)NSString * firstDate;
//明天日期
@property (nonatomic,strong)NSString * twoDate;
//后天日期
@property (nonatomic,strong)NSString * threeDate;
//第二天最高
@property (nonatomic,strong)NSString * twoMaxDegrees;
//第二天最低
@property (nonatomic,strong)NSString * twoMinDegrees;
//第三天最高
@property (nonatomic,strong)NSString * threeMaxDegrees;
//第三天最低
@property (nonatomic,strong)NSString * threeMinDegrees;
//第二天日出
@property (nonatomic,strong)NSString * twoSunrise;
//第二天日落
@property (nonatomic,strong)NSString * twoSunset;
//第三天日出
@property (nonatomic,strong)NSString * threeSunrise;
//第三天日落
@property (nonatomic,strong)NSString * threeSunset;
//第二天天气状况
@property (nonatomic,strong)NSString * twoWeatherCond;
//第三天天气状况
@property (nonatomic,strong)NSString * threeWeatherCond;
//第一天天气状况
@property (nonatomic,strong)NSString * weatherCond;
//日出
@property (nonatomic,strong)NSString * sunrise;
//日落
@property (nonatomic,strong)NSString * sunset;
//最高温度
@property (nonatomic,strong)NSString * maxDegrees;
//最低温度
@property (nonatomic,strong)NSString * minDegrees;

@end

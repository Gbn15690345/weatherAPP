//
//  ElseCityViewController.m
//  天气
//
//  Created by  wyzc02 on 16/12/16.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "ElseCityViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "POP.h"
#import "CommonCityViewController.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "FutureWeatherViewController.h"
#import "LifeIndexViewController.h"
//实况天气接口
#define NOWWEATHER @"https://free-api.heweather.com/v5/now"
//3天天气接口
#define FORECASTWEATHER @"https://free-api.heweather.com/v5/forecast"
//生活指数接口
#define LIFE @"https://free-api.heweather.com/v5/suggestion"
//key值
#define KEY @"705280c8fcd146a4aa98d4b6539081e6"

@interface ElseCityViewController ()<AVSpeechSynthesizerDelegate>
//背景图
@property (nonatomic,strong)UIImageView * image;
//更新时间
@property (nonatomic,strong)NSString * updateTime;
//天气状况
@property (nonatomic,strong)NSString * weatherCond;
//天气状况代码（用于加载图片）
@property (nonatomic,strong)NSString * condNum;
//当前温度
@property (nonatomic,strong)NSString * degrees;
//相对湿度
@property (nonatomic,strong)NSString * hum;
//降水量
@property (nonatomic,strong)NSString * pcpn;
//能见度
@property (nonatomic,strong)NSString * vis;
//风力
@property (nonatomic,strong)NSString * wind;
//日出
@property (nonatomic,strong)NSString * sunrise;
//日落
@property (nonatomic,strong)NSString * sunset;
//最高温度
@property (nonatomic,strong)NSString * maxDegrees;
//最低温度
@property (nonatomic,strong)NSString * minDegrees;
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
//定位的位置
@property (nonatomic,strong)NSString * weizhi;
//空气质量
@property (nonatomic,strong)NSString * kongQi;
//舒适度
@property (nonatomic,strong)NSString * shuShi;
//洗车
@property (nonatomic,strong)NSString * xiChe;
//穿衣
@property (nonatomic,strong)NSString * chuanYi;
//感冒
@property (nonatomic,strong)NSString * ganMao;
//运动
@property (nonatomic,strong)NSString * yunDong;
//旅游
@property (nonatomic,strong)NSString * lvYou;
//紫外线
@property (nonatomic,strong)NSString * ziWaiXian;
//实况天气语音播报的内容
@property (nonatomic,strong)NSString * speechText;
//三天语音播报
@property (nonatomic,strong)NSString * threeSpeech;
//生活指数播报
@property (nonatomic,strong)NSString * lifeSpeech;
// 创建语音合成器
@property (nonatomic,strong)AVSpeechSynthesizer * synthesizer;
//选择播报的界面
@property (nonatomic,strong)UIView * speechView;
//语音播报的button
@property (nonatomic,strong)UIButton * button;
//选中的button
@property (nonatomic,strong)UIButton * selectedButton;
//更多功能选择界面
@property (nonatomic,strong)UIView * moreView;
//天气状况图的url
@property (nonatomic,strong)NSString * condstr;
//导航栏右侧按钮
@property (nonatomic,strong)UIButton * rightButton;
//这个view放需要刷新显示的控件
@property (nonatomic,strong)UIView * refreshView;
//button动画时间
@property (nonatomic,strong)NSMutableArray * times;
//右滑手势
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@end

@implementation ElseCityViewController
- (NSMutableArray *)times{
    if (!_times) {
        //每一个动画的时间
        _times = [@[@0.8,@0.8,@0.8] mutableCopy];
    }
    return _times;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIApplication *myApplication = [UIApplication sharedApplication];
    // 不隐藏
    [myApplication setStatusBarHidden:NO];
    // 设置为白色
    [myApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景图
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_sunny_day"]];
    image.frame = [UIScreen mainScreen].bounds;
    image.userInteractionEnabled = YES;
    [self.view insertSubview:image atIndex:0];
    _image = image;
    
    self.view.userInteractionEnabled = NO;
    
    _refreshView = [[UIView alloc]init];
    [self.view addSubview:_refreshView];
    [_refreshView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(self.view.bottom).offset(-200);
    }];
    //导航栏标题
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:@"返回我的城市" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    [titleButton sizeToFit];
    titleButton.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleButton;
    
    [self setupSubView];
    [self setupSubViews];
    [self addElseButton];
    [self requestData];
    _synthesizer = [[AVSpeechSynthesizer alloc] init];
    _synthesizer.delegate = self;
    
     self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fanhui)];
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
     [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    // Do any additional setup after loading the view.
}
- (void)fanhui{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)titleClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)addElseButton{
    // 存放按钮数据的数组
    NSArray *images = @[@"newweilai", @"chengshi", @"newlife"];
    int buttonCount = (int)images.count;
    //每行的按钮数量
    int maxRowButtonNumber = 3;
    //继续计算按钮的尺寸
    CGFloat buttonWid = [UIScreen mainScreen].bounds.size.width / maxRowButtonNumber;;
    CGFloat buttonHei = 80;
    for (int i = 0; i < buttonCount; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 500 + i;
        [self.view addSubview:button];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        //frame
        CGFloat buttonx = (i % maxRowButtonNumber) * buttonWid;
        CGFloat buttony = [UIScreen mainScreen].bounds.size.height - 175;
        //添加button的动画效果
        //弹簧动画
        POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonx, buttony - 800, buttonWid, buttonHei)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(buttonx, buttony, buttonWid, buttonHei)];
        //弹簧速度
        animation.springSpeed = 1;
        animation.springBounciness = 1;
        // CACurrentMediaTime()获取到当前的时间
        animation.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [animation setCompletionBlock:^(POPAnimation * anim, BOOL finsh) {
            if (finsh) {
                self.view.userInteractionEnabled = YES;
            }
        }];
        [button pop_addAnimation:animation forKey:nil];
    }
}
//按钮点击
- (void)buttonClick:(UIButton *)button{
    if (button.tag == 500) {
        FutureWeatherViewController * future = [[FutureWeatherViewController alloc]init];
        future.firstDate = _firstDate;
        future.twoDate = _twoDate;
        future.threeDate = _threeDate;
        future.maxDegrees = _maxDegrees;
        future.minDegrees = _minDegrees;
        future.twoMaxDegrees = _twoMaxDegrees;
        future.twoMinDegrees = _twoMinDegrees;
        future.threeMaxDegrees = _threeMaxDegrees;
        future.threeMinDegrees = _threeMinDegrees;
        future.weatherCond = _weatherCond;
        future.twoWeatherCond = _twoWeatherCond;
        future.threeWeatherCond = _threeWeatherCond;
        future.sunrise = _sunrise;
        future.sunset = _sunset;
        future.twoSunrise = _twoSunrise;
        future.twoSunset = _twoSunset;
        future.threeSunrise = _threeSunrise;
        future.threeSunset = _threeSunset;
        future.backImage = _image;
        [self.navigationController pushViewController:future animated:YES];
    }else if (button.tag == 501){
        CommonCityViewController * city = [[CommonCityViewController alloc]init];
        [self.navigationController pushViewController:city animated:YES];
    }else{
        LifeIndexViewController * life = [[LifeIndexViewController alloc]init];
        life.shuShi = _shuShi;
        life.xiChe = _xiChe;
        life.ganMao = _ganMao;
        life.lvYou = _lvYou;
        life.yunDong = _yunDong;
        life.ziWaiXian = _ziWaiXian;
        life.chuanYi = _chuanYi;
        [self.navigationController pushViewController:life animated:YES];
    }
}
- (void)setupSubView{
    //定位城市
    UILabel * cityLabel = [[UILabel alloc]init];
    cityLabel.text = self.cityName;
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.font = [UIFont systemFontOfSize:25];
    [_refreshView addSubview:cityLabel];
    //当前温度
    UILabel * nowDegreesLabel = [[UILabel alloc]init];
    nowDegreesLabel.text = _degrees;
    nowDegreesLabel.textAlignment = NSTextAlignmentCenter;
    nowDegreesLabel.textColor = [UIColor whiteColor];
    nowDegreesLabel.font = [UIFont systemFontOfSize:40];
    [_refreshView addSubview:nowDegreesLabel];
    //空气质量
    UILabel * airLabel = [[UILabel alloc]init];
    airLabel.text = [NSString stringWithFormat:@"空气质量:%@",_kongQi];
    airLabel.numberOfLines = 0;
    airLabel.textAlignment = NSTextAlignmentCenter;
    airLabel.textColor = [UIColor whiteColor];
    airLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:airLabel];
    //空气状况
    UILabel * condLabel = [[UILabel alloc]init];
    condLabel.text = _weatherCond;
    condLabel.textAlignment = NSTextAlignmentCenter;
    condLabel.textColor = [UIColor whiteColor];
    condLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:condLabel];
    //天气状况图
    UIImageView * condImage = [[UIImageView alloc]init];
    [condImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",_condNum]]];
    [_refreshView addSubview:condImage];
    //最高、最低温度
    UILabel * maxAddMinLabel = [[UILabel alloc]init];
    maxAddMinLabel.text = [NSString stringWithFormat:@"%@/%@℃",_maxDegrees,_minDegrees];
    maxAddMinLabel.textAlignment = NSTextAlignmentCenter;
    maxAddMinLabel.textColor = [UIColor whiteColor];
    maxAddMinLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:maxAddMinLabel];
    //日出
    UILabel * sunrLabel = [[UILabel alloc]init];
    sunrLabel.text = _sunrise;
    sunrLabel.textAlignment = NSTextAlignmentCenter;
    sunrLabel.textColor = [UIColor whiteColor];
    sunrLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:sunrLabel];
    //日落
    UILabel * sunsetLabel = [[UILabel alloc]init];
    sunsetLabel.text = _sunset;
    sunsetLabel.textAlignment = NSTextAlignmentCenter;
    sunsetLabel.textColor = [UIColor whiteColor];
    sunsetLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:sunsetLabel];
    //风力
    UILabel * windLabel = [[UILabel alloc]init];
    windLabel.text = [NSString stringWithFormat:@"风力:%@",_wind];
    windLabel.textAlignment = NSTextAlignmentCenter;
    windLabel.textColor = [UIColor whiteColor];
    windLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:windLabel];
    //湿度
    UILabel * humLabel = [[UILabel alloc]init];
    humLabel.text = _hum;
    humLabel.textAlignment = NSTextAlignmentCenter;
    humLabel.textColor = [UIColor whiteColor];
    humLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:humLabel];
    //降水量
    UILabel * pcpnLabel = [[UILabel alloc]init];
    pcpnLabel.text = _pcpn;
    pcpnLabel.textAlignment = NSTextAlignmentCenter;
    pcpnLabel.textColor = [UIColor whiteColor];
    pcpnLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:pcpnLabel];
    //能见度
    UILabel * visLabel = [[UILabel alloc]init];
    visLabel.text = _vis;
    visLabel.textAlignment = NSTextAlignmentCenter;
    visLabel.textColor = [UIColor whiteColor];
    visLabel.font = [UIFont systemFontOfSize:20];
    [_refreshView addSubview:visLabel];
    //更新时间
    UILabel * updateTimeLabel = [[UILabel alloc]init];
    updateTimeLabel.text = _updateTime;
    updateTimeLabel.textAlignment = NSTextAlignmentCenter;
    updateTimeLabel.textColor = [UIColor whiteColor];
    updateTimeLabel.font = [UIFont systemFontOfSize:15];
    [_refreshView addSubview:updateTimeLabel];
    
    [cityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_refreshView.top).offset(30);
        make.centerX.equalTo(_refreshView.centerX);
    }];
    [nowDegreesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_refreshView.centerX);
        make.top.equalTo(cityLabel.bottom).offset(10);
    }];
    [maxAddMinLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nowDegreesLabel.bottom).offset(10);
        make.centerX.equalTo(_refreshView.centerX);
    }];
    [condLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_refreshView.centerX).offset(1);
        make.top.equalTo(maxAddMinLabel.bottom).offset(10);
    }];
    [condImage makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_refreshView.centerX).offset(-1);
        make.top.equalTo(maxAddMinLabel.bottom).offset(0);
        make.width.equalTo(50);
        make.height.equalTo(50);
    }];
    [sunrLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(condLabel.bottom).offset(10);
        make.right.equalTo(_refreshView.centerX).offset(-5);
    }];
    [sunsetLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(condLabel.bottom).offset(10);
        make.left.equalTo(_refreshView.centerX).offset(5);
    }];
    [humLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sunrLabel.bottom).offset(10);
        make.right.equalTo(_refreshView.centerX).offset(-5);
    }];
    [pcpnLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sunsetLabel.bottom).offset(10);
        make.left.equalTo(_refreshView.centerX).offset(5);
    }];
    [visLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(humLabel.bottom).offset(10);
        make.right.equalTo(_refreshView.centerX).offset(-5);
    }];
    [windLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pcpnLabel.bottom).offset(10);
        make.left.equalTo(_refreshView.centerX).offset(5);
    }];
    [updateTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_refreshView.right).offset(-10);
        make.top.equalTo(_refreshView.top).offset(10);
    }];
    [airLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(windLabel.bottom).offset(30);
        make.left.equalTo(_refreshView.left).offset(20);
        make.right.equalTo(_refreshView.right).offset(-20);
    }];
}
- (void)refresh{
    for (UIView * view in _refreshView.subviews) {
        [view removeFromSuperview];
    }
    [self setupSubView];
    
}
- (void)setupSubViews{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(5, 5, 30, 30);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"刷新高亮"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left;
    //语音播报按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"homepage_voice_1"] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"homepage_voice_3"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.equalTo(200);
        make.width.equalTo(30);
        make.height.equalTo(30);
    }];
    //语音播报按钮手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    
    [button addGestureRecognizer:panGestureRecognizer];
    //语音播报选择界面
    UIView * speechView = [[UIView alloc]init];
    [self.view addSubview:speechView];
    self.speechView = speechView;
    [speechView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100);
        make.height.equalTo(150);
        make.top.equalTo(button.bottom);
        make.right.equalTo(self.view.right).offset(100);
    }];
    UIImageView * speechImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"a.jpg"]];
    speechImage.frame = CGRectMake(0, 0, 100, 150);
    [self.speechView addSubview:speechImage];
    UIImageView * mohui = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 150)];
    mohui.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.speechView addSubview:mohui];
    NSArray * arr = @[@"实况天气",@"三天预报",@"生活指数"];
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonwidth = 100;
        CGFloat buttonheight = 50;
        CGFloat buttonx = 0;
        CGFloat buttony = 0 + buttonheight * i;
        button.frame = CGRectMake(buttonx, buttony, buttonwidth, buttonheight);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(speech:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 200 + i;
        [self.speechView addSubview:button];
    }
}
//button移动
- (void) handlePan:(UIPanGestureRecognizer*) recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat centerX=recognizer.view.center.x+ translation.x;
    CGFloat thecenter=0;
    recognizer.view.center=CGPointMake(centerX,recognizer.view.center.y+ translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    if(recognizer.state==UIGestureRecognizerStateEnded|| recognizer.state==UIGestureRecognizerStateCancelled) {
        if(centerX > [UIScreen mainScreen].bounds.size.width/2) {
            thecenter= [UIScreen mainScreen].bounds.size.width - 15;
        }else{
            thecenter= 15;
        }
        [UIView animateWithDuration:0.3 animations:^{
            recognizer.view.center=CGPointMake(thecenter,recognizer.view.center.y+ translation.y);
        }];
    }
}
- (void)speech:(UIButton *)button {
    // 创建嗓音，指定嗓音不存在则返回nil
    AVSpeechSynthesisVoice * voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    _speechText = [NSString stringWithFormat:@"%@当前天气状况%@。最高气温%@摄氏度。最低气温%@摄氏度。现在气温%@。空气质量为%@",self.cityName,_weatherCond,_maxDegrees,_minDegrees,_degrees,_kongQi];
    _threeSpeech = [NSString stringWithFormat:@"%@。%@。最高气温%@℃。最低气温%@℃。%@。%@。最高气温%@℃。最低气温%@℃。%@。%@。最高气温%@℃。最低气温%@℃",_firstDate,_weatherCond,_maxDegrees,_minDegrees,_twoDate,_twoWeatherCond,_twoMaxDegrees,_twoMinDegrees,_threeDate,_threeWeatherCond,_threeMaxDegrees,_threeMinDegrees];
    _lifeSpeech = [NSString stringWithFormat:@"今天天气舒适度指数为,%@。洗车指数为,%@。穿衣指数为,%@。感冒指数为,%@。运动指数为,%@。旅游指数为,%@。紫外线指数,为%@",_shuShi,_xiChe,_chuanYi,_ganMao,_yunDong,_lvYou,_ziWaiXian];
    
    if (button.tag == 200) {
        //初始化发声
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.speechText];
        utterance.voice = voice;
        //语速
        utterance.rate = 0.4;
        //读完1段停顿几秒
        utterance.postUtteranceDelay = 3;
        if (button.selected == NO) {
            button.selected = YES;
            self.selectedButton = button;
            // 朗读的内容
            [_synthesizer speakUtterance:utterance];
        }else{
            button.selected = NO;
            [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        }
    }else if (button.tag == 201){
        //初始化发声
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.threeSpeech];
        utterance.voice = voice;
        //语速
        utterance.rate = 0.4;
        //读完1段停顿几秒
        utterance.postUtteranceDelay = 3;
        if (button.selected == NO) {
            button.selected = YES;
            self.selectedButton = button;
            // 朗读的内容
            [_synthesizer speakUtterance:utterance];
        }else{
            button.selected = NO;
            [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        }
    }else{
        //初始化发声
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.lifeSpeech];
        utterance.voice = voice;
        //语速
        utterance.rate = 0.4;
        //读完1段停顿几秒
        utterance.postUtteranceDelay = 3;
        if (button.selected == NO) {
            button.selected = YES;
            self.selectedButton = button;
            // 朗读的内容
            [_synthesizer speakUtterance:utterance];
        }else{
            button.selected = NO;
            [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        }
        
    }
}
//朗读完走的方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    self.selectedButton.selected = NO;
}
- (void)pushView:(UIButton *)button{
    if (button.selected == NO) {
        button.selected =YES;
        POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake([UIScreen mainScreen].bounds.size.width,self.speechView.frame.origin.y,100,150)];
        if (self.button.frame.origin.x == 0) {
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, self.button.frame.origin.y+30,100,150)];
        }else{
            animation.toValue = [NSValue valueWithCGRect:CGRectMake([UIScreen mainScreen].bounds.size.width-100, self.button.frame.origin.y+30,100,150)];
        }
        animation.springSpeed = 10;
        animation.springBounciness = 10;
        animation.beginTime = CACurrentMediaTime() + 0.3;
        [self.speechView pop_addAnimation:animation forKey:nil];
    }else{
        button.selected = NO;
        POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake([UIScreen mainScreen].bounds.size.width-100, self.speechView.frame.origin.y,100,150)];;
        animation.toValue = [NSValue valueWithCGRect:CGRectMake([UIScreen mainScreen].bounds.size.width, self.button.frame.origin.y+30,100,150)];
        animation.beginTime = CACurrentMediaTime() + 0.3;
        [self.speechView pop_addAnimation:animation forKey:nil];
    }
}
- (void)requestData{
    __weak typeof(self) tempSelf = self;
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            
            dic[@"city"] = self.cityName;
            
            dic[@"key"] = KEY;
            
            [manager GET:NOWWEATHER parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //更新时间
                NSString *str2 = [responseObject[@"HeWeather5"] firstObject][@"basic"][@"update"][@"loc"];
                NSArray * arr = [str2 componentsSeparatedByString:@" "];
                NSString * updateTime =[NSString stringWithFormat:@"更新于:%@",arr[1]];
                //天气状况
                NSString * weatherCond = [responseObject[@"HeWeather5"] firstObject][@"now"][@"cond"][@"txt"];
                //天气状况代码
                NSString * condNum = [responseObject[@"HeWeather5"] firstObject][@"now"][@"cond"][@"code"];
                //体感温度
                NSString * degrees = [NSString stringWithFormat:@"%@℃",[responseObject[@"HeWeather5"] firstObject][@"now"][@"fl"]];
                //相对湿度
                NSString * hum = [NSString stringWithFormat:@"湿度:%@%%",[responseObject[@"HeWeather5"] firstObject][@"now"][@"hum"]];
                //降水量
                NSString * pcpn = [NSString stringWithFormat:@"降水量:%@mm",[responseObject[@"HeWeather5"] firstObject][@"now"][@"pcpn"]];
                //能见度
                NSString * vis = [NSString stringWithFormat:@"能见度:%@km",[responseObject[@"HeWeather5"] firstObject][@"now"][@"vis"]];
                //风力
                NSString * wind = [NSString stringWithFormat:@"%@%@级",[responseObject[@"HeWeather5"] firstObject][@"now"][@"wind"][@"dir"],[responseObject[@"HeWeather5"] firstObject][@"now"][@"wind"][@"sc"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    tempSelf.updateTime = updateTime;
                    tempSelf.weatherCond = weatherCond;
                    if ([tempSelf.weatherCond containsString:@"晴"]) {
                        tempSelf.image.image = [UIImage imageNamed:@"bg_sunny_day"];
                    }else if ([tempSelf.weatherCond containsString:@"多云"]){
                        tempSelf.image.image = [UIImage imageNamed:@"bg_na"];
                    }else if ([tempSelf.weatherCond containsString:@"雾"]){
                        tempSelf.image.image = [UIImage imageNamed:@"bg_fog_day"];
                    }else if ([tempSelf.weatherCond containsString:@"霾"]){
                        tempSelf.image.image = [UIImage imageNamed:@"bg_haze"];
                    }else if ([tempSelf.weatherCond containsString:@"雨"]){
                        tempSelf.image.image = [UIImage imageNamed:@"bg_rain_day"];
                    }else if ([tempSelf.weatherCond containsString:@"雪"]){
                        tempSelf.image.image = [UIImage imageNamed:@"bg_snow_day"];
                    }
                    tempSelf.condNum = condNum;
                    tempSelf.degrees = degrees;
                    tempSelf.hum = hum;
                    tempSelf.pcpn = pcpn;
                    tempSelf.vis = vis;
                    tempSelf.wind = wind;
                    //[tempSelf refresh];
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            [manager GET:FORECASTWEATHER parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //日出
                NSString * sunrise = [NSString stringWithFormat:@"日出:%@",[[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] firstObject][@"astro"][@"sr"]];
                //日落
                NSString * sunset = [NSString stringWithFormat:@"日落:%@",[[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] firstObject][@"astro"][@"ss"]];
                //最高温度
                NSString * max = [[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] firstObject][@"tmp"][@"max"];
                //最低温度
                NSString * min = [[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] firstObject][@"tmp"][@"min"];
                //当前日期
                NSString * firstDate = [[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] firstObject][@"date"];
                //第二天日期
                NSString * twoDate = [responseObject[@"HeWeather5"] firstObject][@"daily_forecast"][1][@"date"];
                //第三天日期
                NSString * threeDate = [[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] lastObject][@"date"];
                //第二天最高
                NSString * twoMax = [responseObject[@"HeWeather5"] firstObject][@"daily_forecast"][1][@"tmp"][@"max"];
                //第三天最高
                NSString * threeMax = [[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] lastObject][@"tmp"][@"max"];
                //第二天最低
                NSString * twoMin = [responseObject[@"HeWeather5"] firstObject][@"daily_forecast"][1][@"tmp"][@"min"];
                //第三天最低
                NSString * threeMin = [[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] lastObject][@"tmp"][@"min"];
                //第二天日出
                NSString * twoSunrise = [NSString stringWithFormat:@"日出:%@",[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"][1][@"astro"][@"sr"]];
                //第三天日出
                NSString * threeSunrise = [NSString stringWithFormat:@"日出:%@",[[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] lastObject][@"astro"][@"sr"]];
                //第二天日落
                NSString * twoSunset = [NSString stringWithFormat:@"日出:%@",[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"][1][@"astro"][@"ss"]];
                //第三天日落
                NSString * threeSunset = [NSString stringWithFormat:@"日出:%@",[[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] lastObject][@"astro"][@"ss"]];
                //第二天天气状况
                NSString * twoWeatherCond = [responseObject[@"HeWeather5"] firstObject][@"daily_forecast"][1][@"cond"][@"txt_d"];
                //第三天天气状况
                NSString * threeWeatherCond = [[responseObject[@"HeWeather5"] firstObject][@"daily_forecast"] lastObject][@"cond"][@"txt_d"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    tempSelf.sunrise = sunrise;
                    tempSelf.sunset = sunset;
                    tempSelf.maxDegrees = max;
                    tempSelf.minDegrees = min;
                    tempSelf.firstDate = firstDate;
                    tempSelf.twoDate = twoDate;
                    tempSelf.threeDate = threeDate;
                    tempSelf.twoMaxDegrees = twoMax;
                    tempSelf.twoMinDegrees = twoMin;
                    tempSelf.threeMaxDegrees = threeMax;
                    tempSelf.threeMinDegrees = threeMin;
                    tempSelf.twoSunrise = twoSunrise;
                    tempSelf.twoSunset = twoSunset;
                    tempSelf.threeSunrise = threeSunrise;
                    tempSelf.threeSunset = threeSunset;
                    tempSelf.twoWeatherCond = twoWeatherCond;
                    tempSelf.threeWeatherCond = threeWeatherCond;
                    //[tempSelf refresh];
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            [manager GET:LIFE parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString * kongQi = [responseObject[@"HeWeather5"] lastObject][@"suggestion"][@"air"][@"txt"];
                NSString * shuShi = [responseObject[@"HeWeather5"] lastObject][@"suggestion"][@"comf"][@"txt"];
                NSString * xiChe = [responseObject[@"HeWeather5"] lastObject][@"suggestion"][@"cw"][@"txt"];
                NSString * chuanYi = [responseObject[@"HeWeather5"] lastObject][@"suggestion"][@"drsg"][@"txt"];
                NSString * ganMao = [responseObject[@"HeWeather5"] lastObject][@"suggestion"][@"flu"][@"txt"];
                NSString * yunDong = [responseObject[@"HeWeather5"] lastObject][@"suggestion"][@"sport"][@"txt"];
                NSString * lvYou = [responseObject[@"HeWeather5"] lastObject][@"suggestion"][@"trav"][@"txt"];
                NSString * ziWaiXian = [responseObject[@"HeWeather5"] lastObject][@"suggestion"][@"uv"][@"txt"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    tempSelf.kongQi = kongQi;
                    tempSelf.shuShi = shuShi;
                    tempSelf.chuanYi = chuanYi;
                    tempSelf.xiChe = xiChe;
                    tempSelf.ganMao = ganMao;
                    tempSelf.yunDong = yunDong;
                    tempSelf.lvYou = lvYou;
                    tempSelf.ziWaiXian = ziWaiXian;
                    [tempSelf refresh];
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"已更新至最新天气" preferredStyle:UIAlertControllerStyleAlert];
                    [self showDetailViewController:alert sender:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
}
- (void)leftClick{
    [self requestData];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

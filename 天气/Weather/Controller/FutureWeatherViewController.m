//
//  FutureWeatherViewController.m
//  天气
//
//  Created by  wyzc02 on 16/12/16.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "FutureWeatherViewController.h"
#import "ThreeDayTableViewCell.h"
#import "UUChart.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
@interface FutureWeatherViewController ()<UITableViewDelegate,UITableViewDataSource,UUChartDataSource>

@end

@implementation FutureWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * image = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    image.image = _backImage.image;
    [self.view insertSubview:image atIndex:0];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"ThreeDayTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:tableView];
    UUChart * chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 64 + [UIScreen mainScreen].bounds.size.height/2-60, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height/2-180) withSource:self withStyle:UUChartLineStyle];
    chartView.backgroundColor = [UIColor clearColor];
    [chartView showInView:self.view];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top).offset(64);
        make.height.equalTo(200);
    }];
    [chartView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(tableView.bottom).offset(30);
        make.height.equalTo(200);
    }];
    // Do any additional setup after loading the view.
}
- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    NSArray *arr = @[_firstDate,_twoDate,_threeDate];
    
    return arr;
}
- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    NSArray *ary1 = @[_maxDegrees,_twoMaxDegrees,_threeMaxDegrees];
    NSArray *ary2 = @[_minDegrees,_twoMinDegrees,_threeMinDegrees];
    return @[ary1,ary2];
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart{
    return @[UUWhite,UUWhite];
}
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart{
    NSMutableArray * max = [NSMutableArray arrayWithObjects:_maxDegrees,_twoMaxDegrees,_threeMaxDegrees, nil];
    NSMutableArray * min = [NSMutableArray arrayWithObjects:_minDegrees,_twoMinDegrees,_threeMinDegrees, nil];
    for (int  i =0; i<[max count]-1; i++) {
        for (int j = i+1; j<[max count]; j++) {
            if ([max[i] intValue]>[max[j] intValue]) {
                [max exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    for (int  i =0; i<[min count]-1; i++) {
        for (int j = i+1; j<[min count]; j++) {
            if ([min[i] intValue]>[min[j] intValue]) {
                [min exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return CGRangeMake([[max lastObject] intValue]+5,[[min firstObject] intValue]-5);
}
//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index{
    return NO;
}
//判断是否显示竖条
- (BOOL)UUChart:(UUChart *)chart ShowVerticalLineAtIndex:(NSInteger)index{
    return NO;
}
//判断显示值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index{
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThreeDayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.firstDateLabel.text = _firstDate;
    cell.twoDateLabel.text = _twoDate;
    cell.threeDateLabel.text = _threeDate;
    cell.firstCondLabel.text = _weatherCond;
    cell.twoCondLabel.text = _twoWeatherCond;
    cell.threeCondLabel.text = _threeWeatherCond;
    cell.firstMaxdeLabel.text = [NSString stringWithFormat:@"%@/%@℃",_maxDegrees,_minDegrees];
    cell.twoMaxdeLabel.text = [NSString stringWithFormat:@"%@/%@℃",_twoMaxDegrees,_twoMinDegrees];
    cell.threeMaxdeLabel.text = [NSString stringWithFormat:@"%@/%@℃",_threeMaxDegrees,_threeMinDegrees];
    cell.firstSunreisLabel.text = _sunrise;
    cell.firstSunsetLabel.text = _sunset;
    cell.twoSunreisLabel.text = _twoSunrise;
    cell.twoSunsetLabel.text = _twoSunset;
    cell.threeSunreisLabel.text = _threeSunrise;
    cell.threeSunsetLabel.text = _threeSunset;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
/*
- (void)setupSubView{
    
    UILabel * firstDateLabel = [[UILabel alloc]init];
    [self.view addSubview:firstDateLabel];
    UILabel * twoDateLabel = [[UILabel alloc]init];
    [self.view addSubview:twoDateLabel];
    UILabel * threeDateLabel = [[UILabel alloc]init];
    [self.view addSubview:threeDateLabel];
    UILabel * firstWeatherCondLabel = [[UILabel alloc]init];
    [self.view addSubview:firstWeatherCondLabel];
    UILabel * twoWeatherCondLabel = [[UILabel alloc]init];
    [self.view addSubview:twoWeatherCondLabel];
    UILabel * threeWeatherCondLabel = [[UILabel alloc]init];
    [self.view addSubview:threeWeatherCondLabel];
    UILabel * firstMaxAndMinLabel = [[UILabel alloc]init];
    [self.view addSubview:firstMaxAndMinLabel];
    UILabel * twoMaxAndMinLabel = [[UILabel alloc]init];
    [self.view addSubview:twoMaxAndMinLabel];
    UILabel * threeMaxAndMinLabel = [[UILabel alloc]init];
    [self.view addSubview:threeMaxAndMinLabel];
    UILabel * firstSunrLaebl = [[UILabel alloc]init];
    [self.view addSubview:firstSunrLaebl];
    UILabel * twoSunrLaebl = [[UILabel alloc]init];
    [self.view addSubview:twoSunrLaebl];
    UILabel * threeSunrLaebl = [[UILabel alloc]init];
    [self.view addSubview:threeSunrLaebl];
    
}
 */
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

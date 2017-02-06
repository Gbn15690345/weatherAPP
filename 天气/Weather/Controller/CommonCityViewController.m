//
//  CommonCityViewController.m
//  天气
//
//  Created by  wyzc02 on 16/12/14.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "CommonCityViewController.h"
#import "MoreCityViewController.h"
#import "CommonCityTableViewCell.h"
#import "DataBaseManager.h"
#import "ElseCityViewController.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
@interface CommonCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)DataBaseManager * manager;
@end

@implementation CommonCityViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _manager = [[DataBaseManager alloc]init];
    [_manager createTableViewName:@"commoncity"];
    [_manager selectAllCityFromTable:@"commoncity"];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button1 setTitle:@"返回我的城市" forState:UIControlStateNormal];
//    [button1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [button1 sizeToFit];
//    button1.layer.borderWidth = 0.5;
//    button1.layer.cornerRadius = 10;
//    button1.layer.borderColor = [[UIColor blueColor] CGColor];
//    [button1 addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:button1];
//    self.navigationItem.leftBarButtonItem = left;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"常用城市";
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1444980172592.jpg"]];
    image.frame = [UIScreen mainScreen].bounds;
    image.userInteractionEnabled = YES;
    [self.view insertSubview:image atIndex:0];

//    //导航栏标题
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    label.text = @"常用城市";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:20];
//    self.navigationItem.titleView = label;
    // 添加右边加号
    UIBarButtonItem *addCityButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addcity)];
    self.navigationItem.rightBarButtonItem = addCityButton;
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"CommonCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"清空列表" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(qingkong) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    button.layer.cornerRadius = 10;
    button.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(-5);
        make.height.equalTo(30);
    }];

    // Do any additional setup after loading the view.
}
- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qingkong{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您是否要把常用城市列表清空❓" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_manager deleteTable:@"commoncity"];
        [self.tableView reloadData];
        UIAlertController * alert1 = [UIAlertController alertControllerWithTitle:@"✅" message:@"清空列表成功" preferredStyle:UIAlertControllerStyleAlert];
        [self showDetailViewController:alert1 sender:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert1 dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        });
        
    }];
    [alert addAction:action1];
    [alert addAction:action];
    [self showDetailViewController:alert sender:nil];
}

- (void)addcity{
    MoreCityViewController * more = [[MoreCityViewController alloc]init];
    [self.navigationController pushViewController:more animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _manager.allCityArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonCityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.commonCityLabel.text = _manager.allCityArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ElseCityViewController * city = [[ElseCityViewController alloc]init];
    city.cityName = _manager.allCityArray[indexPath.row];
    [self.navigationController pushViewController:city animated:YES];
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

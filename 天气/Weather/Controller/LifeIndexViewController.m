//
//  LifeIndexViewController.m
//  天气
//
//  Created by  wyzc02 on 16/12/16.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "LifeIndexViewController.h"
#import "LifeTableViewCell.h"
@interface LifeIndexViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LifeIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [tableView registerNib:[UINib nibWithNibName:@"LifeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tableView];
    
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LifeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.shuShiLabel.text = _shuShi;
    cell.chuanYiLabel.text = _chuanYi;
    cell.ganMaoLabel.text = _ganMao;
    cell.yunDongLabel.text = _yunDong;
    cell.lvYouLabel.text = _lvYou;
    cell.ziWaiXianLabel.text = _ziWaiXian;
    cell.xiCheLabel.text = _xiChe;
    return cell;
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

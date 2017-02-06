//
//  MoreCityViewController.m
//  天气
//
//  Created by  wyzc02 on 16/12/14.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "MoreCityViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DataBaseManager.h"

@interface MoreCityViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray *cityData; // 城市数据
@property (nonatomic, strong) NSMutableArray *searchResults; // 搜索的结果
@property (nonatomic, strong) UITableView *tableView; // 城市列表
@property (nonatomic, strong) UISearchController *searchController; // 搜索栏
@property (nonatomic, strong) UITextField *locationEditField; // 编辑框
@end

@implementation MoreCityViewController
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1444980172592.jpg"]];
    image.frame = [UIScreen mainScreen].bounds;
    image.userInteractionEnabled = YES;
    [self.view insertSubview:image atIndex:0];
    // 设置tableview, 顶部是从导航栏以下算起的
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.backgroundColor = [UIColor clearColor];
    _tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    //_tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    // 添加搜索栏
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.frame = CGRectMake(0, 0, 0, 44); // 只需要指定高度
    self.searchController.dimsBackgroundDuringPresentation = NO; // 保证能选择cell
    self.searchController.hidesNavigationBarDuringPresentation = NO; // 不隐藏导航栏
    self.searchController.searchBar.backgroundColor = [UIColor orangeColor];
    
    self.searchController.searchResultsUpdater = self;
    _tableView.tableHeaderView = self.searchController.searchBar; // 需要添加到表头
    [self.searchController.searchBar sizeToFit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择城市";
    // 解析json城市数据
    NSString* path = [[NSBundle mainBundle] pathForResource:@"CityList" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    
    NSError *error;
    
    NSArray * jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonObj || error)
    {
        NSLog(@"解析数据出错");
    }
    // 把需要的数据存入一个数组
    self.cityData = [NSMutableArray array];
    for(NSDictionary *dict in jsonObj)
    {
        [self.cityData addObject:dict[@"name"]];
    }
    
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _searchController.active = NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchController.active)
    {
        return _searchResults.count;
    }
    else
    {
        return _cityData.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // 设置选中时背景颜色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    }
    //三目运算，根据搜索框是否处于活跃状态加载不同数据
    cell.textLabel.text = self.searchController.active ? _searchResults[indexPath.row] : _cityData[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchController.searchBar resignFirstResponder];
    NSString * str = [NSString stringWithFormat:@"你是否确定要把%@添加到常用城市列表",self.searchController.active ? _searchResults[indexPath.row] : _cityData[indexPath.row]];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DataBaseManager * manager = [[DataBaseManager alloc]init];
        [manager createTableViewName:@"commoncity"];
        
        [manager selectAllCityFromTable:@"commoncity"];
        if ([manager.allCityArray containsObject:self.searchController.active ? _searchResults[indexPath.row] : _cityData[indexPath.row]]) {
            UIAlertController * alert1 = [UIAlertController alertControllerWithTitle:@"❎" message:[NSString stringWithFormat:@"添加%@失败，常用城市中已经存在",self.searchController.active ? _searchResults[indexPath.row] : _cityData[indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];
            [self showDetailViewController:alert1 sender:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert1 dismissViewControllerAnimated:YES completion:^{
                    _searchController.active = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            });
        }else{
            [manager insertDataToTableName:@"commoncity" WithCTName:self.searchController.active ? _searchResults[indexPath.row] : _cityData[indexPath.row]];
        UIAlertController * alert1 = [UIAlertController alertControllerWithTitle:@"✅" message:[NSString stringWithFormat:@"添加%@成功",self.searchController.active ? _searchResults[indexPath.row] : _cityData[indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];
        [self showDetailViewController:alert1 sender:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert1 dismissViewControllerAnimated:YES completion:^{
            _searchController.active = NO;
            [self.navigationController popViewControllerAnimated:YES];
            }];
        });
        }
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self showDetailViewController:alert sender:nil];
}

//失去第一响应者
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//过滤搜索结果
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchResults removeAllObjects];
    // 谓词
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchController.searchBar.text];
    // 过滤table
    self.searchResults = [[self.cityData filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    // 刷新表格
    [self.tableView reloadData];
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

//
//  CityListController.m
//  CityList
//
//  Created by MyMac on 15/11/5.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import "CityListController.h"
#import <MJExtension.h>
#import "Cities.h"
#import "CityLists.h"
#import "City.h"
#import "ZYPinYinSearch.h"
#import "PinYinForObjc.h"
#import "CityGroupView.h"

@interface CityListController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CityGroupViewDelegate>

@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) NSMutableArray *keys; /**< 索引*/

@property (nonatomic,strong) NSArray *citiesArray; /**< */

@property (nonatomic,strong) NSMutableArray *cities; /**< */

@property (nonatomic,strong) NSMutableArray *allCities; /**< 所有的cities*/

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) CityGroupView *locationCityGroup; /**< 城市定位*/

@property (nonatomic,strong) CityGroupView *historyGroup; /**< 最近访问城市*/

@property (nonatomic,strong) CityGroupView *hotCityGroup; /**< 热门城市*/



@property (nonatomic,strong) UIView *tipsView;

@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic,strong) NSTimer *timer;

//搜索框
@property (nonatomic,strong) UIView *searchView;

@property (nonatomic,strong) UIView *searchBg;

@property (nonatomic,strong) UIImageView *searchBarIcon;

@property (nonatomic,strong) UITextField *searchText;

@end

@implementation CityListController

- (void)initialize{
    self.keys = [[NSMutableArray alloc] init];
    self.cities = [[NSMutableArray alloc] init];
    self.allCities = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化操作
    [self initialize];
    
    self.view.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    
    //
    [self getCityData];
    
    //添加搜索
    [self.view addSubview:self.searchView];
    [self.searchView addSubview:self.searchBg];
    [self.searchBg addSubview:self.searchBarIcon];
    [self.searchBg addSubview:self.searchText];
    
    
    [self.view addSubview:self.tableView];
    
    [self initHeaderView];
    
}

#pragma mark - 获取城市数据
- (void)getCityData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    Cities *cities = [Cities objectWithKeyValues:data];
    
    self.citiesArray = [CityLists objectArrayWithKeyValuesArray:cities.cityList];
    
    for (CityLists *list in self.citiesArray) {
        NSArray *array = [City objectArrayWithKeyValuesArray:list.city];
        [self.cities addObject:array];
        [self.keys addObject:list.key];
    }
    
    for (int i = 0; i < self.cities.count; i ++) {
        NSArray *array = [City objectArrayWithKeyValuesArray:self.cities[i]];
        for (City *city in array) {
            [self.allCities addObject:city.city_name];
        }
    }
}

#pragma mark - UITableView Header
- (void)initHeaderView{
    
    //定位城市
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.headerView.frame.size.width, 28)];
    locationLabel.text = @"定位城市";
    locationLabel.font = [UIFont systemFontOfSize:12.0f];
    locationLabel.textColor = [UIColor colorWithRed:136 / 255.0 green:136 / 255.0 blue:136 / 255.0 alpha:1.0];
    locationLabel.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    [self.headerView addSubview:locationLabel];
    
    self.locationCityGroup = [[CityGroupView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(locationLabel.frame), self.headerView.frame.size.width, 30) cities:@[@"武汉"]];
    self.locationCityGroup.delegate = self;
    [self.headerView addSubview:self.locationCityGroup];
    
    //最近访问城市
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.locationCityGroup.frame), self.headerView.frame.size.width, 28)];
    historyLabel.text = @"最近访问城市";
    historyLabel.font = [UIFont systemFontOfSize:12.0f];
    historyLabel.textColor = [UIColor colorWithRed:136 / 255.0 green:136 / 255.0 blue:136 / 255.0 alpha:1.0];
    historyLabel.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    [self.headerView addSubview:historyLabel];
    
    self.historyGroup = [[CityGroupView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(historyLabel.frame), self.headerView.frame.size.width, 30) cities:@[@"武汉",@"杭州",@"上海"]];
    self.historyGroup.delegate = self;
    [self.headerView addSubview:self.historyGroup];
    
    //热门城市
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.historyGroup.frame), self.headerView.frame.size.width, 28)];
    hotLabel.text = @"热门城市";
    hotLabel.font = [UIFont systemFontOfSize:12.0f];
    hotLabel.textColor = [UIColor colorWithRed:136 / 255.0 green:136 / 255.0 blue:136 / 255.0 alpha:1.0];
    hotLabel.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    [self.headerView addSubview:hotLabel];
    
    NSArray *hotArray = @[@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州",@"成都",@"重庆"];
    long row = hotArray.count / 3;
    if (hotArray.count % 3 > 0) {
        row += 1;
    }
    
    CGFloat hotViewHeight = 45 * row;
    self.hotCityGroup = [[CityGroupView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotLabel.frame), self.headerView.frame.size.width, hotViewHeight) cities:hotArray];
    self.hotCityGroup.delegate = self;
    [self.headerView addSubview:self.hotCityGroup];
    self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, CGRectGetMaxY(self.hotCityGroup.frame));
    
    self.tableView.tableHeaderView.frame = self.headerView.frame;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - CityGroupView delegate
- (void)cityGroupView:(CityGroupView *)cityGroupView didClickedButtonTitle:(NSString *)title{
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(didClickedWithCityName:)]) {
        [self.delegate didClickedWithCityName:title];
    }
}

#pragma mark - tableView

//每个section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.0;
}

//自定义每个section中header的view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    bgView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0f];
    
    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 250, bgView.frame.size.height)];
    headerTitleLabel.backgroundColor = [UIColor clearColor];
    headerTitleLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    headerTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 27, tableView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:0.2];
    
    NSString *key = [self.keys objectAtIndex:section];
    headerTitleLabel.text = key;
    
    [bgView addSubview:headerTitleLabel];
    [bgView addSubview:line];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *indexNumber = [NSMutableArray arrayWithArray:self.keys];
    return indexNumber;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [self showTipsWithTitle:title];
    return index;
}


//显示tips
- (void)showTipsWithTitle:(NSString *)title{
    
    //获取当前屏幕
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    self.tipsView.center = window.center;
    [window addSubview:self.tipsView];
    self.tipsLabel.text = title;
    [self.tipsView addSubview:self.tipsLabel];
    
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(hiddenTipsView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)hiddenTipsView{
    [UIView animateWithDuration:0.2 animations:^{
        self.tipsView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tipsView removeFromSuperview];
        self.tipsLabel = nil;
        self.tipsView = nil;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *city = self.cities[section];
    return city.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    
    NSString *cityName;
    if (self.searchText.text.length > 0) {
        NSArray *array = self.cities[indexPath.section];
        cityName = array[indexPath.row];
    }else{
        NSArray *array = [City objectArrayWithKeyValuesArray:self.cities[indexPath.section]];
        City *city = [City objectWithKeyValues:array[indexPath.row]];
        cityName = city.city_name;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.8f];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    cell.textLabel.text = cityName;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *cityName;
    if (self.searchText.text.length > 0) {
        NSArray *array = self.cities[indexPath.section];
        cityName = array[indexPath.row];
    }else{
        NSArray *array = [City objectArrayWithKeyValuesArray:self.cities[indexPath.section]];
        City *city = [City objectWithKeyValues:array[indexPath.row]];
        cityName = city.city_name;
    }
    if ([self.delegate respondsToSelector:@selector(didClickedWithCityName:)]) {
        [self.delegate didClickedWithCityName:cityName];
    }
    
}



#pragma mark - UITextField editing change method
- (void)textChange:(UITextField *)textField{
    [self filterContentForSearchText:textField.text];
}

#pragma mark - 通过搜索条件过滤得到搜索结果
- (void)filterContentForSearchText:(NSString *)searchText{
    if (searchText.length > 0) {
        
        //去除原有的值
        [self.keys removeAllObjects];
        [self.cities removeAllObjects];
        
        NSArray *resultArray = [ZYPinYinSearch searchWithOriginalArray:self.allCities andSearchText:searchText andSearchByPropertyName:@""];
        for (NSString *city in resultArray) {
            NSString *pinYinHead = [PinYinForObjc chineseConvertToPinYinHead:city].uppercaseString;
            NSString *firstHeadPinYin = [pinYinHead substringToIndex:1];
            [self.keys addObject:firstHeadPinYin];
        }
        
        NSSet *set = [NSSet setWithArray:self.keys];
        self.keys = [[[set allObjects] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        
        //得到分组城市
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.keys.count; i ++) {
            NSString *key = self.keys[i];
            for (NSString *city in resultArray) {
                NSString *pinYinHead = [PinYinForObjc chineseConvertToPinYinHead:city].uppercaseString;
                NSString *firstHeadPinYin = [pinYinHead substringToIndex:1];
                if ([key isEqualToString:firstHeadPinYin]) {
                    [array addObject:city];
                }
            }
            
            [self.cities addObject:[array mutableCopy]];
            [array removeAllObjects];
        }
        [self.tableView reloadData];
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = [[UIView alloc] init];
        
    }else{
        [self.keys removeAllObjects];
        [self.cities removeAllObjects];
        [self.allCities removeAllObjects];
        self.tableView.tableHeaderView = self.headerView;
        [self getCityData];
        [self.tableView reloadData];
    }
}


#pragma mark - getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, self.searchView.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height - self.searchView.frame.size.height - 20);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 44.0f;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionIndexColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.4];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return _tableView;
}


- (UIView *)tipsView{
    if (!_tipsView) {
        _tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _tipsView.backgroundColor = [UIColor blackColor];
        _tipsView.alpha = 0.2;
        _tipsView.layer.masksToBounds = YES;
        _tipsView.layer.cornerRadius = 15;
        _tipsView.layer.borderColor = [UIColor whiteColor].CGColor;
        _tipsView.layer.borderWidth = 2;
    }
    return _tipsView;
}


- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tipsView.frame.size.width, self.tipsView.frame.size.height)];
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.font = [UIFont boldSystemFontOfSize:50.0f];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor colorWithRed:132/155.0 green:132/155.0 blue:132/155.0 alpha:1.0f];
    }
    return _tipsLabel;
}


- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
        _searchView.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0f];
        
    }
    return _searchView;
}


- (UIView *)searchBg{
    if (!_searchBg) {
        _searchBg = [[UIView alloc] init];
        _searchBg.frame = CGRectMake(10, 7, self.searchView.frame.size.width - 20, self.searchView.frame.size.height - 14);
        _searchBg.backgroundColor = [UIColor whiteColor];
        _searchBg.layer.borderColor = [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1.0f].CGColor;
        _searchBg.layer.borderWidth = 1.0f;
        _searchBg.layer.masksToBounds = YES;
        _searchBg.layer.cornerRadius = 15.0f;
    }
    return _searchBg;
}


- (UIImageView *)searchBarIcon{
    if (!_searchBarIcon) {
        _searchBarIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        CGFloat y = self.searchBg.frame.size.height - _searchBarIcon.image.size.height;
        _searchBarIcon.frame = CGRectMake(5, y / 2, _searchBarIcon.image.size.width, _searchBarIcon.image.size.height);
    }
    return _searchBarIcon;
}

- (UITextField *)searchText{
    if (!_searchText) {
        _searchText = [[UITextField alloc] init];
        _searchText.frame = CGRectMake(self.searchBarIcon.frame.size.width + self.searchBarIcon.frame.origin.x + 3, self.searchBarIcon.frame.origin.y, self.searchBg.frame.size.width - self.searchBarIcon.frame.size.width * 2 - 6, self.searchBarIcon.frame.size.height);
        _searchText.font = [UIFont systemFontOfSize:12.0f];
        _searchText.placeholder = @"请输入城市名称或者首字母查询";
        _searchText.returnKeyType = UIReturnKeySearch;
        _searchText.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0f];
        _searchText.tintColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0f];
        _searchText.delegate = self;
        [_searchText addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchText;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 250);
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}


@end

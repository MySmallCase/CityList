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

@interface CityListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

//自己添加
@property (nonatomic,strong) NSMutableArray *keys;

@property (nonatomic,strong) NSArray *citiesArray;

@property (nonatomic,strong) NSMutableArray *cities;



@property (nonatomic,strong) UIView *tipsView;

@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation CityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.keys = [[NSMutableArray alloc] init];
    self.cities = [[NSMutableArray alloc] init];
    
    [self getCityData];
    
    [self.view addSubview:self.tableView];
    
    
    
}

#pragma mark - 获取城市数据
- (void)getCityData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    Cities *cities = [Cities objectWithKeyValues:data];
    
    self.citiesArray = [CityLists objectArrayWithKeyValuesArray:cities.cityList];
    
    for (CityLists *list in self.citiesArray) {
        
        NSArray *array = [City objectArrayWithKeyValuesArray:list.city];
        
//        NSLog(@"%@",array);
        
        [self.cities addObject:array];
        
        [self.keys addObject:list.key];
    }
    
//    NSLog(@"%@",self.cities);
    
    
}

NSInteger cityNameSort(id str1, id str2, void *context)
{
    NSString *string1 = (NSString*)str1;
    NSString *string2 = (NSString*)str2;
    
    return  [string1 localizedCompare:string2];
}

#pragma mark - getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 44.0f;
        _tableView.dataSource = self;
        _tableView.delegate = self;
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
    line.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    
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
    return self.citiesArray.count;
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
    
    NSArray *array = [City objectArrayWithKeyValuesArray:self.cities[indexPath.section]];
    City *city = [City objectWithKeyValues:array[indexPath.row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.8f];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    cell.textLabel.text = city.city_name;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *array = [City objectArrayWithKeyValuesArray:self.cities[indexPath.section]];
    City *city = [City objectWithKeyValues:array[indexPath.row]];
    if ([self.delegate respondsToSelector:@selector(didClickedWithCityName:)]) {
        [self.delegate didClickedWithCityName:city.city_name];
    }
    
}


@end

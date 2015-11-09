//
//  ViewController.m
//  CityList
//
//  Created by MyMac on 15/11/5.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import "ViewController.h"
#import "CityListController.h"

@interface ViewController ()<CityListDelegate>

@property (nonatomic,strong) UIButton *clickButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.clickButton];
    
}

- (UIButton *)clickButton{
    if (!_clickButton) {
        _clickButton = [[UIButton alloc] init];
        [_clickButton setTitle:@"点击" forState:UIControlStateNormal];
        [_clickButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_clickButton addTarget:self action:@selector(clickButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _clickButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _clickButton.frame = CGRectMake(20, 100, 150, 30);
    }
    return _clickButton;
}


- (void)clickButtonClicked:(UIButton *)sender{
//    NSLog(@"clicked");
    CityListController *cityList = [[CityListController alloc] init];
    cityList.delegate = self;
//    [self.navigationController pushViewController:cityList animated:YES];
    [self presentViewController:cityList animated:YES completion:nil];
}


- (void)didClickedWithCityName:(NSString *)cityName{
    [self.clickButton setTitle:cityName forState:UIControlStateNormal];
}


@end

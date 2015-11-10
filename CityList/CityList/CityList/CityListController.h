//
//  CityListController.h
//  CityList
//
//  Created by MyMac on 15/11/5.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CityListDelegate <NSObject>

@optional
- (void)didClickedWithCityName:(NSString *)cityName;

@end

@interface CityListController : UIViewController

@property (nonatomic,strong) NSArray *LocateCity; /**< 定位城市*/

@property (nonatomic,strong) NSMutableArray *HistoryCities; /**< 最近访问城市*/

@property (nonatomic,strong) NSMutableArray *HotCities; /**< 热门城市*/

@property (nonatomic,weak) id<CityListDelegate> delegate;

@end

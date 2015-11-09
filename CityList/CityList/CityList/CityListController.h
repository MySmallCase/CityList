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

@property (nonatomic,weak) id<CityListDelegate> delegate;

@end

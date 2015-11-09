//
//  CityLists.h
//  CityList
//
//  Created by MyMac on 15/11/6.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;
@interface CityLists : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) NSArray<City *> *city;

@end

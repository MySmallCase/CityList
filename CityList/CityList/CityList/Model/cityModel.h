//
//  cityModel.h
//  CityList
//
//  Created by MyMac on 15/12/5.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Citys : NSObject

@property (nonatomic,copy) NSString *city_name; 

@end

@interface CityList : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) NSArray<Citys *> *city;

@end


@interface allCity : NSObject

@property (nonatomic, strong) NSArray<CityList *> *cityList;

@end


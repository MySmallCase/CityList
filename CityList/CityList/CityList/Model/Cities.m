//
//  Cities.m
//  CityList
//
//  Created by MyMac on 15/11/6.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import "Cities.h"
#import "CityLists.h"

@implementation Cities

+ (NSDictionary *)objectClassInArray{
    return @{@"cityList" : [CityLists class]};
}

@end

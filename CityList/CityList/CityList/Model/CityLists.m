//
//  CityLists.m
//  CityList
//
//  Created by MyMac on 15/11/6.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import "CityLists.h"
#import "City.h"

@implementation CityLists

+ (NSDictionary *)objectClassInArray{
    return @{@"city" : [City class]};
}

@end

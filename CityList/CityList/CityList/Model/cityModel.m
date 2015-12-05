//
//  cityModel.m
//  CityList
//
//  Created by MyMac on 15/12/5.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import "cityModel.h"
#import <MJExtension.h>

@implementation Citys


@end


@implementation CityList

+ (NSDictionary *)objectClassInArray{
    return @{@"city" : [Citys class]};
}

@end


@implementation allCity

+ (NSDictionary *)objectClassInArray{
    return @{@"cityList" : [CityList class]};
}

@end

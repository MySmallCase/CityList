//
//  CityGroupView.m
//  CityList
//
//  Created by MyMac on 15/11/10.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import "CityGroupView.h"

@interface CityGroupView ()

@property (nonatomic,strong) NSArray *cities;

@end

@implementation CityGroupView

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
////        self.cities = @[@"武汉",@"杭州",@"上海"];
//        self.columns = 3;
//        self.margin = 15;
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame cities:(NSArray *)cities
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.cities = cities;
        self.columns = 3;
        self.margin = 15;
        
        [self addCityButtons];
    }
    return self;
}

- (void)addCityButtons{
    
    CGFloat buttonW = (self.bounds.size.width - (self.columns + 1) * self.margin) / self.columns;
    CGFloat buttonH = 30;
    
    
    for (int i = 0; i < self.cities.count; i ++) {
        int rowNum = i % self.columns;
        int columnNum = i / self.columns;
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:self.cities[i] forState:UIControlStateNormal];
        button.frame = CGRectMake((buttonW + self.margin) * rowNum + self.margin, (buttonH + self.margin) * columnNum, buttonW, buttonH);
        [button setTitleColor:[UIColor colorWithRed:34 / 255.0 green:34 / 255.0 blue:34 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.layer.borderColor = [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1.0].CGColor;
        button.layer.borderWidth = 1.0f;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(cityGroupView:didClickedButtonTitle:)]) {
        [self.delegate cityGroupView:self didClickedButtonTitle:button.titleLabel.text];
    }
    
}


@end

//
//  CityGroupView.h
//  CityList
//
//  Created by MyMac on 15/11/10.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityGroupView;
@protocol CityGroupViewDelegate <NSObject>

@optional
- (void)cityGroupView:(CityGroupView *)cityGroupView didClickedButtonTitle:(NSString *)title;

@end

@interface CityGroupView : UIView

- (instancetype)initWithFrame:(CGRect)frame cities:(NSArray *)cities;

@property (nonatomic,assign) NSInteger columns;  /**< 可不填 默认每行3个*/

@property (nonatomic,assign) CGFloat margin; /**< 默认边距为15*/

@property (nonatomic,weak) id<CityGroupViewDelegate> delegate;

@end

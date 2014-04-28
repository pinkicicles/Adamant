//
//  JBBarChartFooterView.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBConstants.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBFontConstants.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBStringConstants.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBColorConstants.h>

@interface JBBarChartFooterView : UIView

@property (nonatomic, strong) UIColor *footerBackgroundColor; // footer background (default = black)
@property (nonatomic, assign) CGFloat padding; // label left & right padding (default = 4.0)
@property (nonatomic, readonly) UILabel *leftLabel;
@property (nonatomic, readonly) UILabel *rightLabel;

@end

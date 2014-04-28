//
//  JBLineChartFooterView.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/8/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBConstants.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBFontConstants.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBStringConstants.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBColorConstants.h>




@interface JBLineChartFooterView : UIView

@property (nonatomic, strong) UIColor *footerSeparatorColor; // footer separator (default = white)
@property (nonatomic, assign) NSInteger sectionCount; // # of notches (default = 2 on each edge)
@property (nonatomic, readonly) UILabel *leftLabel;
@property (nonatomic, readonly) UILabel *rightLabel;

@end
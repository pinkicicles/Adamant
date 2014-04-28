//
//  CPWAdamantViewController.h
//  Adamant
//
//  Created by Connie Wu on 4/8/14.
//  Copyright (c) 2014 Connie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JBChartView/JBBarChartView.h>
#import <JBChartView/JBChartView.h>
#import <JBChartView/JBLineChartView.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/Classes/JBChartHeaderView.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBLineChartFooterView.h>
#import </Users/conniewu/Documents/CIS 195/Adamant/Pods/JBChartView/JBChartInformationView.h>
#import "BLEDevice.h"

@interface CPWAdamantViewController : UIViewController <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) BLEDevice *d;

@end

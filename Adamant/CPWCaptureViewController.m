//
//  CPWCaptureViewController.m
//  Adamant
//
//  Created by Connie Wu on 5/12/14.
//  Copyright (c) 2014 Connie Wu. All rights reserved.
//

#import "CPWCaptureViewController.h"
#import "JBLineChartViewController.h"
#import "CPWDataManager.h"
#import "CPWAppDelegate.h"

// Views
#import "JBLineChartView.h"
#import "JBChartHeaderView.h"
#import "JBLineChartFooterView.h"
#import "JBChartInformationView.h"
#import "JBConstants.h"
#define ARC4RANDOM_MAX 0x100000000

//JBChartInformationView *informationView;
//JBLineChartView *lineChartView;
JBLineChartFooterView *footerView;
JBChartHeaderView *headerView;


typedef NS_ENUM(NSInteger, JBLineChartLine){
	JBLineChartLineSolid,
    JBLineChartLineDashed,
    JBLineChartLineCount
};

// Numerics
CGFloat const LineChartViewControllerChartHeight = 250.0f;
CGFloat const LineChartViewControllerChartPadding = 10.0f;
CGFloat const LineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const LineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const LineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const LineChartViewControllerChartSolidLineWidth = 6.0f;
CGFloat const LineChartViewControllerChartDashedLineWidth = 2.0f;
NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;





@interface CPWCaptureViewController() <JBLineChartViewDelegate, JBLineChartViewDataSource>


@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) JBLineChartFooterView *footerView;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *timeData;

//@property (nonatomic, strong) NSMutableArray *savedData;


@property (nonatomic, strong) NSMutableArray *savedHumidity;
@property (nonatomic, strong) NSMutableArray *savedPressure;
@property (nonatomic, strong) NSMutableArray *savedaTemp;
@property (nonatomic, strong) NSMutableArray *savedirTemp;

@property (nonatomic, strong) NSMutableArray *savedhumiditytimestamps;
@property (nonatomic, strong) NSMutableArray *savedpressuretimestamps;
@property (nonatomic, strong) NSMutableArray *savedaTemptimestamps;
@property (nonatomic, strong) NSMutableArray *savedirTemptimestamps;

@property (nonatomic, strong) NSArray *daysOfWeek;



// Buttons
- (IBAction) pauseButton:(id)sender;
- (IBAction) captureandSave:(id)sender;


// Helpers
- (void)initFakeData;
//- (NSArray *)largestLineData; // largest collection of fake line data


@end

@implementation CPWCaptureViewController
@synthesize d,sensorType;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initFakeData];
    }
    
    self.chartData = self.dataModel.humidity;
    self.timeData = self.dataModel.humiditytimestamps;


    return self;
   }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initFakeData];
    }
    self.chartData = self.dataModel.humidity;
    self.timeData = self.dataModel.humiditytimestamps;

    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.chartData = self.dataModel.humidity;
    self.timeData = self.dataModel.humiditytimestamps;

    return self;
}



#pragma mark - Date

- (CPWDataManager *)dataModel{
    if(!_dataModel)
        _dataModel = [[CPWDataManager alloc] init];

    return _dataModel;
}

- (void)initFakeData
{
    _chartData = self.dataModel.humidity;
    _daysOfWeek = self.dataModel.humiditytimestamps;;
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(LineChartViewControllerChartPadding, LineChartViewControllerChartPadding, self.view.bounds.size.width - (LineChartViewControllerChartPadding * 2), LineChartViewControllerChartHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = LineChartViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = [UIColor grayColor];

    
    headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(LineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(LineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (LineChartViewControllerChartPadding * 2), LineChartViewControllerChartHeaderHeight)];
    
    if([self.sensorType isEqualToString:@"rH"]){
        headerView.titleLabel.text = [@"Today's Humidity Measurement" uppercaseString];
    }else if([self.sensorType isEqualToString:@"pressure"]){
        headerView.titleLabel.text = [@"Today's Pressure Measurement" uppercaseString];
    }else if([self.sensorType isEqualToString:@"aTemp"]){
        headerView.titleLabel.text = [@"Today's Ambient Temperature" uppercaseString];
    }else if([self.sensorType isEqualToString:@"irTemp"]){
        headerView.titleLabel.text = [@"Today's IR Temperature" uppercaseString];
    }
    
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    
    
    headerView.titleLabel.text = [@"Today's Humidity Measurement" uppercaseString];
    headerView.titleLabel.textColor = kJBColorLineChartHeader;
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.text = dateString;
    headerView.subtitleLabel.textColor = kJBColorLineChartHeader;
    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
    self.lineChartView.headerView = headerView;
    
    footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(LineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(LineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (LineChartViewControllerChartPadding * 2), LineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = [[self.dataModel.humiditytimestamps firstObject] uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [[self.dataModel.humiditytimestamps lastObject] uppercaseString];;
    footerView.rightLabel.textColor = [UIColor whiteColor];
    //footerView.sectionCount = [[self largestLineData] count];
    self.lineChartView.footerView = footerView;
    
    [self.view addSubview:self.lineChartView];
    
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    [self.informationView setTitleTextColor:kJBColorLineChartHeader];
    [self.informationView setTextShadowColor:nil];
    [self.informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
    [self.informationView setHidden:YES animated:NO];
    [self.view addSubview:self.informationView];
    
    [self.lineChartView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBar.tintColor= [UIColor clearColor];
    
    [self.lineChartView reloadData];
}

- (IBAction)pauseButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    //return [self.chartData count];
    return 1; // number of lines in chart
}

//
//- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex{
//    return YES;
//}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    NSLog(@"Size of array %d",[self.dataModel.humiditytimestamps count]);
    return [self.dataModel.humidity count];
    //return 100; // number of values for a line
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[self.dataModel.humidity objectAtIndex:horizontalIndex] floatValue];
}


- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    
    NSNumber *valueNumber = [self.dataModel.humidity objectAtIndex:horizontalIndex];
    [self.informationView setValueText:[NSString stringWithFormat:@"%.2f", [valueNumber floatValue]] unitText:kJBStringLabelrH];
    
    
//    if([self.sensorType isEqualToString:@"rH"]){
//        [self.informationView setTitleText:@"Relative Humidity"];
//    }else if([self.sensorType isEqualToString:@"pressure"]){
//        [self.informationView setTitleText:@"Barometer Pressure"];
//    }else if([self.sensorType isEqualToString:@"aTemp"]){
//        [self.informationView setTitleText:@"Ambient Temperature"];
//    }else if([self.sensorType isEqualToString:@"irTemp"]){
//        [self.informationView setTitleText:@"IR Temperature"];
//    }
    //[self.informationView setTitleText:lineIndex == JBLineChartLineSolid ? @"Acetone Concentration" : @"Water Concentration"];
    [self.informationView setHidden:NO animated:YES];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    [self.tooltipView setText:[[self.dataModel.humiditytimestamps objectAtIndex:horizontalIndex] uppercaseString]];
    
}

- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self.informationView setHidden:NO animated:YES];
    [self setTooltipVisible:NO animated:YES];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? JBLineChartViewLineStyleSolid : JBLineChartViewLineStyleDashed;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Overrides

- (JBChartView *)chartView
{
    return self.lineChartView;
}



@end

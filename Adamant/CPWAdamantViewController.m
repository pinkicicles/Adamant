//
//  CPWAdamantViewController.m
//  Adamant
//
//  Created by Connie Wu on 4/8/14.
//  Copyright (c) 2014 Connie Wu. All rights reserved.
//

#import "CPWAdamantViewController.h"
#import "JBLineChartViewController.h"

JBChartInformationView *informationView;


typedef NS_ENUM(NSInteger, JBLineChartLine){
	JBLineChartLineSolid,
    JBLineChartLineDashed,
    JBLineChartLineCount
};

// Numerics
CGFloat const kJBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kJBBarChartViewControllerChartPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kJBBarChartViewControllerBarPadding = 1;
NSInteger const kJBBarChartViewControllerNumBars = 12;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 5;


//// Numerics
CGFloat const kJBLineChartViewControllerChartHeight1 = 250.0f;
CGFloat const kJBLineChartViewControllerChartPadding1 = 10.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight1 = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding1 = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight1 = 20.0f;
CGFloat const kJBLineChartViewControllerChartSolidLineWidth1 = 6.0f;
CGFloat const kJBLineChartViewControllerChartDashedLineWidth1 = 2.0f;
NSInteger const kJBLineChartViewControllerMaxNumChartPoints1 = 7;



// Views


@interface CPWAdamantViewController()


@property (nonatomic, strong) JBBarChartView *barChartView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *monthlySymbols;


- (void)initFakeData;
- (IBAction)saveAndContinue:(id)sender;


@end




@implementation CPWAdamantViewController
@synthesize d;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initFakeData];
    }
    return self;
}

#pragma mark - Date

- (void)initFakeData
{
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<kJBBarChartViewControllerNumBars; i++)
    {
        NSInteger delta = (kJBBarChartViewControllerNumBars - abs((kJBBarChartViewControllerNumBars - i) - i)) + 2;
        [mutableChartData addObject:[NSNumber numberWithFloat:MAX((delta * kJBBarChartViewControllerMinBarHeight), arc4random() % (delta * kJBBarChartViewControllerMaxBarHeight))]];
        
    }
    _chartData = [NSArray arrayWithArray:mutableChartData];
    _monthlySymbols = [[[NSDateFormatter alloc] init] shortMonthSymbols];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

 
    
    
//    JBLineChartView *lineChartView = [[JBLineChartView alloc] init];
//    lineChartView.delegate = self;
//    lineChartView.dataSource = self;
//    [self.view addSubview:lineChartView];
//        //barChartView.frame = CGRectMake(0, 00, 300, 300);
//    //[barChartView reloadData];
//    
//    lineChartView.frame = CGRectMake(50, 200, 200, 200);
    
//    
//    CGRect resultFrame = CGRectMake(0.0f,
//                                    0.0f,
//                                    50,
//                                    50);
//    lineChartView.headerView = [[UIView alloc] initWithFrame:resultFrame];
    
//    
//    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
//    
//
//    
//    
//    
//
//
//    
//    [yourLabel setTextColor:[UIColor whiteColor]];
//    [yourLabel setBackgroundColor:[UIColor clearColor]];
//    [yourLabel setFont:[UIFont fontWithName: @"Times New Roman" size: 14.0f]];
//    yourLabel.text = [@"Breath Data Trends" uppercaseString];
//    yourLabel.textAlignment = NSTextAlignmentCenter;
//    yourLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
//    yourLabel.shadowOffset = CGSizeMake(0, 1);
//    
//    
//    yourLabel.Frame = CGRectMake(50, 200, 200, 50);
//    [self.view addSubview:yourLabel];
//    
//    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding1, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight1 * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding1 * 2), kJBLineChartViewControllerChartFooterHeight1)];    footerView.backgroundColor = [UIColor clearColor];
//    footerView.leftLabel.text = [@"8:00 AM" uppercaseString];
//    footerView.leftLabel.textColor = [UIColor whiteColor];
//    footerView.rightLabel.text = [@"9:00 PM" uppercaseString];;
//    footerView.rightLabel.textColor = [UIColor whiteColor];
//    footerView.sectionCount = 15;
//    lineChartView.footerView = footerView;
//    
//    [self.view addSubview:lineChartView];
//    
//    
////    JBChartInformationView *informationView = [[JBChartInformationView alloc] init];
////    [self.view addSubview:informationView];
//    
////    informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
//    [informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
//    [informationView setTitleTextColor:kJBColorLineChartHeader];
//    [informationView setTextShadowColor:nil];
//    [informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
//    [self.view addSubview:informationView];
//
//    lineChartView.footerView.backgroundColor = [UIColor clearColor];
//
//
//    [lineChartView reloadData];
//	// Do any additional setup after loading the view.
//    
//    //barChartView.backgroundColor = [UIColor redColor]; // UIColor
//    lineChartView.backgroundColor = [UIColor clearColor]; // UIColor
    
    
    

    
    
    
}


- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return 15; // number of bars in chart
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)index
{
    //return (index % 2 == 0) ? 3 : 7;
    //return (NSInteger)[NSNumber numberWithInt:50];
    return index;
}




- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = (index % 2 == 0) ? [UIColor greenColor] : [UIColor blueColor];
    return barView;
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1; // number of lines in chart
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return 15; // number of values for a line
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    //return horizontalIndex%2;
    return horizontalIndex;
    //return [[self.chartData objectAtIndex:lineIndex] floatValue]; // y-position (y-axis) of point at horizontalIndex (x-axis)
}


- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
//    //NSNumber *valueNumber = horizontalIndex;
//    [informationView setValueText:@"%d",horizontalIndex unitText:kJBStringLabelPpm];
//    [informationView setTitleText:lineIndex == JBLineChartLineSolid ? kJBStringLabelMetropolitanAverage : kJBStringLabelNationalAverage];
//    [informationView setHidden:NO animated:YES];
//    //[self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
//    //[self.tooltipView setText:[horizontalIdex uppercaseString]];
    
    [informationView setValueText:[NSString stringWithFormat:@"%0.1f", [[NSNumber numberWithUnsignedInteger: horizontalIndex] floatValue]] unitText:kJBStringLabelPpm];
 //   [informationView setTitleText:lineIndex == JBLineChartLineSolid ? kJBStringLabelMetropolitanAverage : kJBStringLabelNationalAverage];
    [informationView setHidden:NO animated:YES];
    //[self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    //[self.tooltipView setText:[[self.daysOfWeek objectAtIndex:horizontalIndex] uppercaseString]];
}

//- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
//{
//    [self.informationView setHidden:YES animated:YES];
//    [self setTooltipVisible:NO animated:YES];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAndContinue:(id)sender
{

    JBLineChartViewController *LCcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChartView"];
    LCcontroller.d = d;
    [self.navigationController pushViewController:LCcontroller animated:YES];
    //[self performSegueWithIdentifier:@"ChartView" sender:self];
    
}

@end

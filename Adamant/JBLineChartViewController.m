//
//  JBLineChartViewController.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBLineChartViewController.h"
#import "CPWDataManager.h"
#import "CPWCaptureViewController.h"
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
CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartViewControllerChartPadding = 10.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartViewControllerChartSolidLineWidth = 6.0f;
CGFloat const kJBLineChartViewControllerChartDashedLineWidth = 2.0f;
NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;



@interface JBLineChartViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource>


@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) JBLineChartFooterView *footerView;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSMutableArray *chartData;
//@property (nonatomic, strong) NSMutableArray *savedData;


@property (nonatomic, strong) NSMutableArray *savedHumidity;
@property (nonatomic, strong) NSMutableArray *savedPressure;
@property (nonatomic, strong) NSMutableArray *savedaTemp;
@property (nonatomic, strong) NSMutableArray *savedirTemp;

@property (nonatomic, strong) NSMutableArray *savedhumiditytimestamps;
@property (nonatomic, strong) NSMutableArray *savedpressuretimestamps;
@property (nonatomic, strong) NSMutableArray *savedaTemptimestamps;
@property (nonatomic, strong) NSMutableArray *savedirTemptimestamps;

@property (nonatomic, strong) NSMutableArray *daysOfWeek;
@property (nonatomic, strong) CPWDataManager *dataModel;




// Buttons
- (IBAction) pauseButton:(id)sender;
- (IBAction) captureandSave:(id)sender;


// Helpers
- (void)initFakeData;
//- (NSArray *)largestLineData; // largest collection of fake line data

@end

@implementation JBLineChartViewController
@synthesize d,sensorType;


- (id)init
{
    self = [super init];
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

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    [self initFakeData];
    
    }
    
    if (self) {
        if (!self.ambientTemp){
            self.ambientTemp = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Ambient temperature"];
            self.ambientTemp.temperatureIcon.image = [UIImage imageNamed:@"temperature.png"];
            self.ambientTemp.temperatureLabel.text = @"Ambient Temperature";
            self.ambientTemp.temperature.text = @"-.-°C";
        }
        if (!self.irTemp) {
            self.irTemp = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IR temperature"];
            self.irTemp.temperatureIcon.image = [UIImage imageNamed:@"objecttemperature.png"];
            self.irTemp.temperatureLabel.text = @"Object Temperature";
            self.irTemp.temperature.text = @"-.-°C";
        }
        if (!self.acc) {
            self.acc = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accelerometer"];
            self.acc.accLabel.text = @"Accelerometer";
            self.acc.accValueX.text = @"-";
            self.acc.accValueY.text = @"-";
            self.acc.accValueZ.text = @"-";
            self.acc.accCalibrateButton.hidden = YES;
        }
        if (!self.rH) {
            self.rH = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Relative humidity"];
            self.rH.temperatureIcon.image = [UIImage imageNamed:@"relativehumidity.png"];
            self.rH.temperatureLabel.text = @"Relative humidity";
            self.rH.temperature.text = @"-%rH";
        }
        if (!self.mag) {
            self.mag = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Magnetometer"];
            self.mag.accLabel.text = @"Magnetometer";
            self.mag.accIcon.image = [UIImage imageNamed:@"magnetometer.png"];
            self.mag.accValueX.text = @"-";
            self.mag.accValueY.text = @"-";
            self.mag.accValueZ.text = @"-";
            [self.mag.accCalibrateButton addTarget:self action:@selector(handleCalibrateMag) forControlEvents:UIControlEventTouchUpInside];
            self.magSensor = [[sensorMAG3110 alloc] init];
        }
        if (!self.baro) {
            self.baro = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Barometer"];
            self.baro.temperatureLabel.text = @"Barometer";
            self.baro.temperatureIcon.image = [UIImage imageNamed:@"barometer.png"];
            self.baro.temperature.text = @"1000mBar";
        }
        if (!self.gyro) {
            self.gyro = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Gyroscope"];
            self.gyro.accLabel.text = @"Gyroscope";
            self.gyro.accIcon.image = [UIImage imageNamed:@"gyroscope.png"];
            self.gyro.accValueX.text = @"-";
            self.gyro.accValueY.text = @"-";
            self.gyro.accValueZ.text = @"-";
            [self.gyro.accCalibrateButton addTarget:self action:@selector(handleCalibrateGyro) forControlEvents:UIControlEventTouchUpInside];
            self.gyroSensor = [[sensorIMU3000 alloc] init];
            
        }
        
        
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(alphaFader:) userInfo:nil repeats:YES];
    
    self.currentVal = [[sensorTagValues alloc]init];
    self.vals = [[NSMutableArray alloc]init];
    
    self.logInterval = 1.0; //1000 ms
    
    self.logTimer = [NSTimer scheduledTimerWithTimeInterval:self.logInterval target:self selector:@selector(logValues:) userInfo:nil repeats:YES];
    
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
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSMutableArray *mutableLineCharts = [NSMutableArray array];
    NSMutableArray *mutableTimeCharts = [NSMutableArray array];
    for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
    {
        NSMutableArray *mutableChartData = [NSMutableArray array];
        NSMutableArray *mutableTimeData = [NSMutableArray array];
        for (int i=0; i<kJBLineChartViewControllerMaxNumChartPoints; i++)
        {
           // [mutableChartData addObject:[NSNumber numberWithFloat:40.0]]; // random number between 0 and 1
            
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            [mutableTimeData addObject:dateString];
        }
        [mutableLineCharts addObject:mutableChartData];
        [mutableTimeCharts addObject:mutableTimeData];
    }
    _chartData = [NSMutableArray arrayWithArray:mutableLineCharts];
    _daysOfWeek = [NSMutableArray arrayWithArray:mutableTimeCharts];
    _savedHumidity = [NSMutableArray array];
    _savedhumiditytimestamps =[NSMutableArray array];
  
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.sensorsEnabled = [[NSMutableArray alloc] init];
    if (!self.d.p.isConnected) {
        self.d.manager.delegate = self;
        [self.d.manager connectPeripheral:self.d.p options:nil];
    }
    else {
        self.d.p.delegate = self;
        [self configureSensorTag];
        self.title = @"TI BLE Sensor Tag application";
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    [self deconfigureSensorTag];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    self.sensorsEnabled = nil;
    self.d.manager.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(kJBLineChartViewControllerChartPadding, kJBLineChartViewControllerChartPadding, self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = [UIColor grayColor];

    //    lineChartView.frame = CGRectMake(25, 50, 250, 250);
    //
    //
    //    CGRect resultFrame = CGRectMake(0.0f,
    //                                    0.0f,
    //                                    50,
    //                                    50);
    //    lineChartView.headerView = [[UIView alloc] initWithFrame:resultFrame];
    
    
    headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeaderHeight)];
    
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

    
    
    //headerView.titleLabel.text = [@"Today's Humidity Measurement" uppercaseString];
    headerView.titleLabel.textColor = kJBColorLineChartHeader;
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.text = dateString;
    headerView.subtitleLabel.textColor = kJBColorLineChartHeader;
    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
    self.lineChartView.headerView = headerView;

    footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = [[[self.daysOfWeek objectAtIndex:0] firstObject] uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [[[self.daysOfWeek objectAtIndex:0] lastObject] uppercaseString];;
    footerView.rightLabel.textColor = [UIColor whiteColor];
    //footerView.sectionCount = [[self largestLineData] count];
    self.lineChartView.footerView = footerView;
    
    [self.view addSubview:self.lineChartView];
    
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    [self.informationView setTitleTextColor:kJBColorLineChartHeader];
    [self.informationView setTextShadowColor:nil];
    [self.informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
    
    NSString *label = @"";
    
    
    if([self.sensorType isEqualToString:@"rH"]){
        label = @"rH";
    }else if([self.sensorType isEqualToString:@"pressure"]){
        label= @"mBar";
    }else if([self.sensorType isEqualToString:@"aTemp"]){
        label= @"°C";
    }else if([self.sensorType isEqualToString:@"irTemp"]){
        label= @"°C";
    }
    
    
    [self.informationView setValueText:@"--.-" unitText:label];
    [self.informationView setHidden:NO animated:NO];
    [self.view addSubview:self.informationView];
    
    [self.lineChartView reloadData];

    
//    informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
//    [informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
//    [informationView setTitleTextColor:kJBColorLineChartHeader];
//    [informationView setTextShadowColor:nil];
//    [informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
//    [self.view addSubview:informationView];
//    
//    [informationView setValueText:[NSString stringWithFormat:@"--.-"] unitText:kJBStringLabelrH];
//
//    [informationView setHidden:NO animated:NO];
//    
//    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    
    
    
//    [yourLabel setTextColor:[UIColor whiteColor]];
//    [yourLabel setBackgroundColor:[UIColor clearColor]];
//    [yourLabel setFont:[UIFont fontWithName: @"Times New Roman" size: 14.0f]];
//    yourLabel.text = [@"Breath Data Trends" uppercaseString];
//    yourLabel.textAlignment = NSTextAlignmentCenter;
//    yourLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
//    yourLabel.shadowOffset = CGSizeMake(0, 1);
    
    
//    yourLabel.Frame = CGRectMake(30, 50, 250, 50);
//    [self.view addSubview:yourLabel];
//    
//    _footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartFooterHeight)];    _footerView.backgroundColor = [UIColor clearColor];
//
//    _footerView.leftLabel.text = [[[self.daysOfWeek objectAtIndex:0] firstObject] uppercaseString];
//    _footerView.leftLabel.textColor = [UIColor whiteColor];
//    _footerView.rightLabel.text = [[[self.daysOfWeek objectAtIndex:0] lastObject] uppercaseString];;
//    _footerView.rightLabel.textColor = [UIColor whiteColor];
//    _footerView.sectionCount = 15;
//    lineChartView.footerView = _footerView;
//    
//    [self.view addSubview:self.lineChartView];
//        
    
//    [lineChartView reloadData];
//	// Do any additional setup after loading the view.
//    
//
//    lineChartView.backgroundColor = [UIColor clearColor]; // UIColor
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
    //self.navigationController.dataModel = _dataModel;
    //[self.navigationController popViewControllerAnimated:YES];
    //((CPWAppDelegate*)[[UIApplication sharedApplication] delegate]).dataModel = _dataModel;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)captureandSave:(id)sender
{
    
    if([self.sensorType isEqualToString:@"rH"]){
        NSLog(@"Capturing");
        [self.savedHumidity addObject:[[self.chartData objectAtIndex:0] lastObject]];
        [self.dataModel addHumidityData:self.savedHumidity];
        
        
        //[[NSUserDefaults standardUserDefaults] setObject:self.savedHumidity forKey:@"humidity"];
        
        NSLog(@"Saving array of size: %d",[[self.dataModel humidity] count]);
        [self.savedhumiditytimestamps addObject:[[self.daysOfWeek objectAtIndex:0]lastObject]];
        [self.dataModel addHumidtyTime:self.savedhumiditytimestamps];
    }
//    }else if([self.sensorType isEqualToString:@"pressure"]){
//        [self.savedPressure addObject:[self.chartData lastObject]];
//        _dataModel.pressure = self.savedPressure;
//        [self.savedpressuretimestamps addObject:[self.daysOfWeek lastObject]];
//        _dataModel.humiditytimestamps = self.savedhumiditytimestamps;
//        
//    }else if([self.sensorType isEqualToString:@"aTemp"]){
//        [self.savedaTemp addObject:[self.chartData lastObject]];
//        _dataModel.aTemp = self.savedaTemp;
//        [self.savedaTemptimestamps addObject:[self.daysOfWeek lastObject]];
//        _dataModel.humiditytimestamps = self.savedhumiditytimestamps;
//    
//    }else if([self.sensorType isEqualToString:@"irTemp"]){
//        [self.savedirTemp addObject:[self.chartData lastObject]];
//        _dataModel.irTemp = self.savedirTemp;
//        [self.savedirTemptimestamps addObject:[self.daysOfWeek lastObject]];
//        _dataModel.humiditytimestamps = self.savedhumiditytimestamps;
//        
//    }
    
//    
//    CPWCaptureViewController *vC = [[CPWCaptureViewController alloc] init];
//    vC.dataModel = _dataModel;
//    [self.navigationController pushViewController:vC animated:YES];
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
    return [[self.chartData objectAtIndex:lineIndex] count];
    //return 100; // number of values for a line
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex] floatValue];
}


- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    
    NSNumber *valueNumber = [[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex];
    [self.informationView setValueText:[NSString stringWithFormat:@"%.2f", [valueNumber floatValue]] unitText:kJBStringLabelrH];
    
    
    if([self.sensorType isEqualToString:@"rH"]){
        [self.informationView setTitleText:@"Relative Humidity"];
    }else if([self.sensorType isEqualToString:@"pressure"]){
        [self.informationView setTitleText:@"Barometer Pressure"];
    }else if([self.sensorType isEqualToString:@"aTemp"]){
        [self.informationView setTitleText:@"Ambient Temperature"];
    }else if([self.sensorType isEqualToString:@"irTemp"]){
        [self.informationView setTitleText:@"IR Temperature"];
    }
    //[self.informationView setTitleText:lineIndex == JBLineChartLineSolid ? @"Acetone Concentration" : @"Water Concentration"];
    [self.informationView setHidden:NO animated:YES];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    [self.tooltipView setText:[[[self.daysOfWeek objectAtIndex:0] objectAtIndex:horizontalIndex] uppercaseString]];

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

-(void) configureSensorTag {
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...
    
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"])) {
        // Enable Temperature sensor
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
//        CBUUID *pUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer period UUID"]];
//        NSInteger period = [[self.d.setupData valueForKey:@"Accelerometer period"] integerValue];
//        uint8_t periodData = (uint8_t)(period / 10);
//        NSLog(@"%d",periodData);
//        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        if ([self sensorEnabled:@"Ambient temperature active"]) [self.sensorsEnabled addObject:@"Ambient temperature"];
        if ([self sensorEnabled:@"IR temperature active"]) [self.sensorsEnabled addObject:@"IR temperature"];
        
    }
    
    if ([self sensorEnabled:@"Accelerometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer config UUID"]];
        CBUUID *pUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer period UUID"]];
        NSInteger period = [[self.d.setupData valueForKey:@"Accelerometer period"] integerValue];
        uint8_t periodData = (uint8_t)(period / 10);
        NSLog(@"%d",periodData);
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Accelerometer"];
    }
    
    if ([self sensorEnabled:@"Humidity active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity config UUID"]];
//        CBUUID *pUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity period UUID"]];
//        NSInteger period = [[self.d.setupData valueForKey:@"Humidity period"] integerValue];
//        uint8_t periodData = (uint8_t)(period / 10);
//        NSLog(@"%d",periodData);
//        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Humidity"];
    }
    
    if ([self sensorEnabled:@"Barometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer config UUID"]];
        //Issue calibration to the device
        uint8_t data = 0x02;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer calibration UUID"]];
        [BLEUtility readCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID];
        [self.sensorsEnabled addObject:@"Barometer"];
    }
    if ([self sensorEnabled:@"Gyroscope active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope config UUID"]];
        uint8_t data = 0x07;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Gyroscope"];
    }
    
    if ([self sensorEnabled:@"Magnetometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer config UUID"]];
        CBUUID *pUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer period UUID"]];
        NSInteger period = [[self.d.setupData valueForKey:@"Magnetometer period"] integerValue];
        uint8_t periodData = (uint8_t)(period / 10);
        NSLog(@"%d",periodData);
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Magnetometer"];
    }
    
}

-(void) deconfigureSensorTag {
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"])) {
        // Enable Temperature sensor
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        unsigned char data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Accelerometer active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Humidity active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Magnetometer active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Gyroscope active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Barometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer config UUID"]];
        //Disable sensor
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
        
    }
}

-(bool)sensorEnabled:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    if (val) {
        if ([val isEqualToString:@"1"]) return TRUE;
    }
    return FALSE;
}

-(int)sensorPeriod:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    return [val integerValue];
}

#pragma mark - CBCentralManager delegate function

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}


#pragma mark - CBperipheral delegate functions

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"..");
    if ([service.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]]]) {
        [self configureSensorTag];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@".");
    for (CBService *s in peripheral.services) [peripheral discoverCharacteristics:nil forService:s];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@, error = %@",characteristic.UUID, error);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateValueForCharacteristic = %@",characteristic.UUID);
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]]]) {
        float tAmb = [sensorTMP006 calcTAmb:characteristic.value];
        float tObj = [sensorTMP006 calcTObj:characteristic.value];
        
       
        if([self.sensorType isEqualToString:@"aTemp"]){
            [self.informationView setValueText:[NSString stringWithFormat:@"%0.1f",tAmb] unitText:@"°C"];
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
            if(!([[self.chartData objectAtIndex:0] count] < 7)){
                [[self.chartData objectAtIndex:0] removeObjectAtIndex: 0];
            }
            [[self.chartData objectAtIndex:0] addObject: [NSNumber numberWithFloat:tAmb]];
            
            if(!([[self.daysOfWeek objectAtIndex:0] count] < 7)){
                [[self.daysOfWeek objectAtIndex:0] removeObjectAtIndex: 0];
            }
            [[self.daysOfWeek objectAtIndex:0] addObject: dateString];
            
            footerView.leftLabel.text = [[[self.daysOfWeek objectAtIndex:0] firstObject] uppercaseString];
            footerView.leftLabel.textColor = [UIColor whiteColor];
            footerView.rightLabel.text = [[[self.daysOfWeek objectAtIndex:0] lastObject] uppercaseString];;
            footerView.rightLabel.textColor = [UIColor whiteColor];
            footerView.sectionCount = 15;
            self.lineChartView.footerView = footerView;
            
            //[self.view addSubview:lineChartView];
            [self.lineChartView reloadData];
        }else if([self.sensorType isEqualToString:@"irTemp"]){
            
            [self.informationView setValueText:[NSString stringWithFormat:@"%0.1f",tObj] unitText:@"°C"];
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
            if(!([[self.chartData objectAtIndex:0] count] < 7)){
                [[self.chartData objectAtIndex:0] removeObjectAtIndex: 0];
            }
            [[self.chartData objectAtIndex:0] addObject: [NSNumber numberWithFloat:tObj]];
            if(!([[self.daysOfWeek objectAtIndex:0] count] > 0)){
                [[self.daysOfWeek objectAtIndex:0] removeObjectAtIndex: 0];
            }
            [[self.daysOfWeek objectAtIndex:0] addObject: dateString];
            
            footerView.leftLabel.text = [[[self.daysOfWeek objectAtIndex:0] firstObject] uppercaseString];
            footerView.leftLabel.textColor = [UIColor whiteColor];
            footerView.rightLabel.text = [[[self.daysOfWeek objectAtIndex:0] lastObject] uppercaseString];;
            footerView.rightLabel.textColor = [UIColor whiteColor];
            footerView.sectionCount = 15;
            self.lineChartView.footerView = footerView;
            
            //[self.view addSubview:lineChartView];
            [self.lineChartView reloadData];
        }
        
        
        self.ambientTemp.temperature.text = [NSString stringWithFormat:@"%.1f°C",tAmb];
        self.ambientTemp.temperature.textColor = [UIColor blackColor];
        self.ambientTemp.temperatureGraph.progress = (tAmb / 100.0) + 0.5;
        self.irTemp.temperature.text = [NSString stringWithFormat:@"%.1f°C",tObj];
        self.irTemp.temperatureGraph.progress = (tObj / 1000.0) + 0.5;
        self.irTemp.temperature.textColor = [UIColor blackColor];
        
        self.currentVal.tAmb = tAmb;
        self.currentVal.tIR = tObj;
        
        
    }
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]]]) {
        float x = [sensorKXTJ9 calcXValue:characteristic.value];
        float y = [sensorKXTJ9 calcYValue:characteristic.value];
        float z = [sensorKXTJ9 calcZValue:characteristic.value];
        
        
        self.acc.accValueX.text = [NSString stringWithFormat:@"X: % 0.1fG",x];
        self.acc.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1fG",y];
        self.acc.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1fG",z];
        
        self.acc.accValueX.textColor = [UIColor blackColor];
        self.acc.accValueY.textColor = [UIColor blackColor];
        self.acc.accValueZ.textColor = [UIColor blackColor];
        
        self.acc.accGraphX.progress = (x / [sensorKXTJ9 getRange]) + 0.5;
        self.acc.accGraphY.progress = (y / [sensorKXTJ9 getRange]) + 0.5;
        self.acc.accGraphZ.progress = (z / [sensorKXTJ9 getRange]) + 0.5;
        
        self.currentVal.accX = x;
        self.currentVal.accY = y;
        self.currentVal.accZ = z;
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]]]) {
        
        float rHVal = [sensorSHT21 calcPress:characteristic.value];
        
       

        
        if([self.sensorType isEqualToString:@"rH"]){
            
            [self.informationView setValueText:[NSString stringWithFormat:@"%0.1f",rHVal] unitText:kJBStringLabelrH];
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
            if(!([[self.chartData objectAtIndex:0] count] < 7)){
                [[self.chartData objectAtIndex:0] removeObjectAtIndex: 0];
            }
            [[self.chartData objectAtIndex:0] addObject: [NSNumber numberWithFloat:rHVal]];
            if(!([[self.daysOfWeek objectAtIndex:0] count] > 0)){
                [[self.daysOfWeek objectAtIndex:0] removeObjectAtIndex: 0];
            }
            [[self.daysOfWeek objectAtIndex:0] addObject: dateString];
            
            footerView.leftLabel.text = [[[self.daysOfWeek objectAtIndex:0] firstObject] uppercaseString];
            footerView.leftLabel.textColor = [UIColor whiteColor];
            footerView.rightLabel.text = [[[self.daysOfWeek objectAtIndex:0] lastObject] uppercaseString];;
            footerView.rightLabel.textColor = [UIColor whiteColor];
            footerView.sectionCount = 15;
            self.lineChartView.footerView = footerView;
            
            //[self.view addSubview:lineChartView];
            [self.lineChartView reloadData];
        }
        
        
        
        self.rH.temperature.text = [NSString stringWithFormat:@"%0.1f%%rH",rHVal];
        self.rH.temperatureGraph.progress = (rHVal / 100);
        self.rH.temperature.textColor = [UIColor blackColor];
        
        self.currentVal.humidity = rHVal;
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer data UUID"]]]) {
        
        float x = [self.magSensor calcXValue:characteristic.value];
        float y = [self.magSensor calcYValue:characteristic.value];
        float z = [self.magSensor calcZValue:characteristic.value];
        
        self.mag.accValueX.text = [NSString stringWithFormat:@"X: % 0.1fuT",x];
        self.mag.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1fuT",y];
        self.mag.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1fuT",z];
        
        self.mag.accValueX.textColor = [UIColor blackColor];
        self.mag.accValueY.textColor = [UIColor blackColor];
        self.mag.accValueZ.textColor = [UIColor blackColor];
        
        self.mag.accGraphX.progress = (x / [sensorMAG3110 getRange]) + 0.5;
        self.mag.accGraphY.progress = (y / [sensorMAG3110 getRange]) + 0.5;
        self.mag.accGraphZ.progress = (z / [sensorMAG3110 getRange]) + 0.5;
        
        self.currentVal.magX = x;
        self.currentVal.magY = y;
        self.currentVal.magZ = z;
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer calibration UUID"]]]) {
        
        self.baroSensor = [[sensorC953A alloc] initWithCalibrationData:characteristic.value];
        
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer config UUID"]];
        //Issue normal operation to the device
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer data UUID"]]]) {
        int pressure = [self.baroSensor calcPressure:characteristic.value];
        
        
        
        if([self.sensorType isEqualToString:@"pressure"]){
            
            [self.informationView setValueText:[NSString stringWithFormat:@"%0.1d",pressure] unitText:@"mBar"];
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            
            if(!([[self.chartData objectAtIndex:0] count] < 7)){
                [[self.chartData objectAtIndex:0] removeObjectAtIndex: 0];
            }
            [[self.chartData objectAtIndex:0] addObject: [NSNumber numberWithFloat:pressure]];
            if(!([[self.daysOfWeek objectAtIndex:0] count] > 0)){
                [[self.daysOfWeek objectAtIndex:0] removeObjectAtIndex: 0];
            }
            [[self.daysOfWeek objectAtIndex:0] addObject: dateString];
            
            footerView.leftLabel.text = [[[self.daysOfWeek objectAtIndex:0] firstObject] uppercaseString];
            footerView.leftLabel.textColor = [UIColor whiteColor];
            footerView.rightLabel.text = [[[self.daysOfWeek objectAtIndex:0] lastObject] uppercaseString];;
            footerView.rightLabel.textColor = [UIColor whiteColor];
            footerView.sectionCount = 15;
            self.lineChartView.footerView = footerView;
            
            //[self.view addSubview:lineChartView];
            [self.lineChartView reloadData];
        }
        self.baro.temperature.text = [NSString stringWithFormat:@"%d mBar",pressure];
        self.baro.temperatureGraph.progress = ((float)((float)pressure - (float)800) / (float)400);
        self.baro.temperature.textColor = [UIColor blackColor];
        
        self.currentVal.press = pressure;
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope data UUID"]]]) {
        
        float x = [self.gyroSensor calcXValue:characteristic.value];
        float y = [self.gyroSensor calcYValue:characteristic.value];
        float z = [self.gyroSensor calcZValue:characteristic.value];
        
        self.gyro.accValueX.text = [NSString stringWithFormat:@"X: % 0.1f°/S",x];
        self.gyro.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1f°/S",y];
        self.gyro.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1f°/S",z];
        
        self.gyro.accValueX.textColor = [UIColor blackColor];
        self.gyro.accValueY.textColor = [UIColor blackColor];
        self.gyro.accValueZ.textColor = [UIColor blackColor];
        
        self.gyro.accGraphX.progress = (x / [sensorIMU3000 getRange]) + 0.5;
        self.gyro.accGraphY.progress = (y / [sensorIMU3000 getRange]) + 0.5;
        self.gyro.accGraphZ.progress = (z / [sensorIMU3000 getRange]) + 0.5;
        
        self.currentVal.gyroX = x;
        self.currentVal.gyroY = y;
        self.currentVal.gyroZ = z;
        
    }
  //  [self.tableView reloadData];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);
}



- (IBAction) handleCalibrateMag {
    NSLog(@"Calibrate magnetometer pressed !");
    [self.magSensor calibrate];
}
- (IBAction) handleCalibrateGyro {
    NSLog(@"Calibrate gyroscope pressed ! ");
    [self.gyroSensor calibrate];
}

-(void) alphaFader:(NSTimer *)timer {
    CGFloat w,a;
    if (self.ambientTemp) {
        [self.ambientTemp.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.ambientTemp.temperature.textColor = [self.ambientTemp.temperature.textColor colorWithAlphaComponent:a];
    }
    if (self.irTemp) {
        [self.irTemp.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.irTemp.temperature.textColor = [self.irTemp.temperature.textColor colorWithAlphaComponent:a];
    }
    if (self.acc) {
        [self.acc.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueX.textColor = [self.acc.accValueX.textColor colorWithAlphaComponent:a];
        
        [self.acc.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueY.textColor = [self.acc.accValueY.textColor colorWithAlphaComponent:a];
        
        [self.acc.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueZ.textColor = [self.acc.accValueZ.textColor colorWithAlphaComponent:a];
    }
    if (self.rH) {
        [self.rH.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.rH.temperature.textColor = [self.rH.temperature.textColor colorWithAlphaComponent:a];
    }
    if (self.mag) {
        [self.mag.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueX.textColor = [self.mag.accValueX.textColor colorWithAlphaComponent:a];
        
        [self.mag.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueY.textColor = [self.mag.accValueY.textColor colorWithAlphaComponent:a];
        
        [self.mag.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueZ.textColor = [self.mag.accValueZ.textColor colorWithAlphaComponent:a];
    }
    if (self.baro) {
        [self.baro.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.baro.temperature.textColor = [self.baro.temperature.textColor colorWithAlphaComponent:a];
    }
    if (self.gyro) {
        [self.gyro.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueX.textColor = [self.gyro.accValueX.textColor colorWithAlphaComponent:a];
        
        [self.gyro.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueY.textColor = [self.gyro.accValueY.textColor colorWithAlphaComponent:a];
        
        [self.gyro.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueZ.textColor = [self.gyro.accValueZ.textColor colorWithAlphaComponent:a];
    }
}


-(void) logValues:(NSTimer *)timer {
    NSString *date = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterMediumStyle];
    self.currentVal.timeStamp = date;
    sensorTagValues *newVal = [[sensorTagValues alloc]init];
    newVal.tAmb = self.currentVal.tAmb;
    newVal.tIR = self.currentVal.tIR;
    newVal.accX = self.currentVal.accX;
    newVal.accY = self.currentVal.accY;
    newVal.accZ = self.currentVal.accZ;
    newVal.gyroX = self.currentVal.gyroX;
    newVal.gyroY = self.currentVal.gyroY;
    newVal.gyroZ = self.currentVal.gyroZ;
    newVal.magX = self.currentVal.magX;
    newVal.magY = self.currentVal.magY;
    newVal.magZ = self.currentVal.magZ;
    newVal.press = self.currentVal.press;
    newVal.humidity = self.currentVal.humidity;
    newVal.timeStamp = date;
    
    [self.vals addObject:newVal];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"Finished with result : %u error : %@",result,error);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sendMail:(id)sender {
    NSLog(@"Mail button pressed");
    NSMutableString *sensorData = [[NSMutableString alloc] init];
    [sensorData appendString:@"Timestamp,Ambient Temperature,IR Temperature,Accelerometer X-Axis,Accelerometer Y-Axis,Accelerometer Z-Axis,Barometric Pressure,Relative Humidity,Gyroscope X,Gyroscope Y,Gyroscope Z,Magnetometer X, Magnetometer Y, Magnetometer Z\n"];
    for (int ii=0; ii < self.vals.count; ii++) {
        sensorTagValues *s = [self.vals objectAtIndex:ii];
        [sensorData appendFormat:@"%@,%0.1f,%0.1f,%0.2f,%0.2f,%0.2f,%0.0f,%0.1f,%0.1f,%0.1f,%0.1f,%0.1f,%0.1f,%0.1f\n",s.timeStamp,s.tAmb,s.tIR,s.accX,s.accY,s.accZ,s.press,s.humidity,s.gyroX,s.gyroY,s.gyroZ,s.magX,s.magY,s.magZ];
    }
    
    MFMailComposeViewController *mFMCVC = [[MFMailComposeViewController alloc]init];
    if (mFMCVC) {
        if ([MFMailComposeViewController canSendMail]) {
            mFMCVC.mailComposeDelegate = self;
            [mFMCVC setSubject:@"Data from BLE Sensor"];
            [mFMCVC setMessageBody:@"Data from sensor" isHTML:NO];
            [self presentViewController:mFMCVC animated:YES completion:nil];
            
            [mFMCVC addAttachmentData:[sensorData dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/csv" fileName:@"Log.csv"];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mail error" message:@"Device has not been set up to send mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}


@end

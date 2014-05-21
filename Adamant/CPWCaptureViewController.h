//
//  CPWCaptureViewController.h
//  Adamant
//
//  Created by Connie Wu on 5/12/14.
//  Copyright (c) 2014 Connie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBBaseChartViewController.h"
#import "BLEDevice.h"
#import "BLEUtility.h"
#import "deviceCellTemplate.h"
#import "Sensors.h"
#import <MessageUI/MessageUI.h>
#import "CPWDataManager.h"

#define MIN_ALPHA_FADE 0.2f
#define ALPHA_FADE_STEP 0.05f


@interface CPWCaptureViewController : JBBaseChartViewController


@property (strong,nonatomic) BLEDevice *d;
@property (strong,nonatomic) NSString *sensorType;
@property NSMutableArray *sensorsEnabled;

/// Temperature cell
@property (strong,nonatomic) temperatureCellTemplate *ambientTemp;
@property (strong,nonatomic) temperatureCellTemplate *irTemp;
@property (strong,nonatomic) accelerometerCellTemplate *acc;
@property (strong,nonatomic) temperatureCellTemplate *rH;
@property (strong,nonatomic) accelerometerCellTemplate *mag;
@property (strong,nonatomic) sensorMAG3110 *magSensor;
@property (strong,nonatomic) temperatureCellTemplate *baro;
@property (strong,nonatomic) sensorC953A *baroSensor;
@property (strong,nonatomic) accelerometerCellTemplate *gyro;
@property (strong,nonatomic) sensorIMU3000 *gyroSensor;


@property (strong,nonatomic) sensorTagValues *currentVal;
@property (strong,nonatomic) NSMutableArray *vals;
@property (strong,nonatomic) NSTimer *logTimer;

@property float logInterval;
@property (nonatomic, strong) CPWDataManager *dataModel;


-(void) configureSensorTag;
-(void) deconfigureSensorTag;




- (IBAction) handleCalibrateMag;
- (IBAction) handleCalibrateGyro;

-(void) alphaFader:(NSTimer *)timer;
-(void) logValues:(NSTimer *)timer;

-(IBAction)sendMail:(id)sender;

@end
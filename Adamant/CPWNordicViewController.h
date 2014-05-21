//
//  CPWNordicViewController.h
//  Adamant
//
//  Created by Connie Wu on 5/20/14.
//  Copyright (c) 2014 Connie Wu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ScannerDelegate.h"
#import "CorePlot-CocoaTouch.h"

@interface CPWNordicViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, ScannerDelegate>

@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *verticalLabel;
@property (weak, nonatomic) IBOutlet UIButton *battery;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *hrValue;
@property (weak, nonatomic) IBOutlet UILabel *hrLocation;

@property (weak, nonatomic) IBOutlet UIView *graphView;

- (IBAction)connectOrDisconnectClicked;

@end
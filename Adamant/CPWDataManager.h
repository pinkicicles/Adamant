//
//  CPWDataManager.h
//  Adamant
//
//  Created by Connie Wu on 5/8/14.
//  Copyright (c) 2014 Connie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPWDataManager : NSObject



//@property (nonatomic, strong) NSMutableArray *humidity;
@property (nonatomic, strong) NSArray *pressure;
@property (nonatomic, strong) NSArray *aTemp;
@property (nonatomic, strong) NSArray *irTemp;
//@property (nonatomic, strong) NSArray *humiditytimestamps;
@property (nonatomic, strong) NSArray *pressuretimestamps;
@property (nonatomic, strong) NSArray *aTemptimestamps;
@property (nonatomic, strong) NSArray *irTemptimestamps;

-(void)addHumidityData:(NSMutableArray *)humidityarray;
-(void)addHumidtyTime:(NSMutableArray *)humiditytimestamps;
- (NSMutableArray *)humidity;
- (NSMutableArray *)humiditytimestamps;
@end

//
//  CPWDataManager.m
//  Adamant
//
//  Created by Connie Wu on 5/8/14.
//  Copyright (c) 2014 Connie Wu. All rights reserved.
//

#import "CPWDataManager.h"

@implementation CPWDataManager

//creates the getter for the sentence
- (NSMutableArray *)humidity{
    //return [[NSUserDefaults standardUserDefaults] objectForKey:@"humidity"];
    
    //return [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"humidity"]];
    
    return [[[NSUserDefaults standardUserDefaults] arrayForKey:@"humidity"] mutableCopy];
}

- (NSMutableArray *)humiditytimestamps{
    //return [[NSUserDefaults standardUserDefaults] objectForKey:@"humiditytimestamps"];
    return [[[NSUserDefaults standardUserDefaults] arrayForKey:@"humiditytimestamps"] mutableCopy];
}


- (NSArray *)pressure{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pressure"];
}

- (NSArray *)pressuretimestamps{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pressuretimestamps"];
}

- (NSArray *)aTemp{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"aTemp"];
}

- (NSArray *)aTemptimestamps{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"aTemptimestamps"];
}

- (NSArray *)irTemp{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"irTemp"];
}

- (NSArray *)irTemptimestamps{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"irTemptimestamps"];
}

//this is the setter for the sentence
-(void)addHumidityData:(NSMutableArray *)humidityarray{
    
    [[NSUserDefaults standardUserDefaults] setObject:humidityarray forKey:@"humidity"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//this is the setter for the sentence
-(void)addHumidtyTime:(NSMutableArray *)humiditytimestamps{
    [[NSUserDefaults standardUserDefaults] setObject:humiditytimestamps forKey:@"humiditytimestamps"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//this is the setter for the sentence
-(void)addpressureData:(NSArray *)pressure{
    
    [[NSUserDefaults standardUserDefaults] setObject:pressure forKey:@"pressure"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//this is the setter for the sentence
-(void)addPressureTime:(NSArray *)pressuretimestamps{
    [[NSUserDefaults standardUserDefaults] setObject:pressuretimestamps forKey:@"pressuretimestamps"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//this is the setter for the sentence
-(void)addaTempData:(NSArray *)aTemp{
    
    [[NSUserDefaults standardUserDefaults] setObject:aTemp forKey:@"aTemp"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//this is the setter for the sentence
-(void)addaTempTime:(NSArray *)aTemptimestamps{
    [[NSUserDefaults standardUserDefaults] setObject:aTemptimestamps forKey:@"aTemptimestamps"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//this is the setter for the sentence
-(void)addirTempData:(NSArray *)irTemp{
    
    [[NSUserDefaults standardUserDefaults] setObject:irTemp forKey:@"irTemp"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//this is the setter for the sentence
-(void)addirTempTime:(NSArray *)irTemptimestamps{
    [[NSUserDefaults standardUserDefaults] setObject:irTemptimestamps forKey:@"irTemptimestamps"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

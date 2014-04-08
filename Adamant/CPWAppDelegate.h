//
//  CPWAppDelegate.h
//  Adamant
//
//  Created by Connie Wu on 4/8/14.
//  Copyright (c) 2014 Connie Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

//
//  TTDatabase.h
//  FexconTimeTracker
//
//  Created by Chathura Lakmal on 8/13/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Time.h"
#import "Tasks.h"


@interface TTDatabase : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (TTDatabase *)initWithManagedObjectContext:(NSManagedObjectContext*)ctx;

+ (TTDatabase *)sharedDatabaseWithManagedObjectContext:(NSManagedObjectContext*)ctx;


+ (Tasks *)getTaskByName:(NSString *)name;

+ (NSMutableArray *)getAllTasks;

+ (BOOL)insertTaskInfo:(NSString *)name totalSeconds:(NSNumber *)totalSeconds;


@end

//
//  TTDatabase.m
//  FexconTimeTracker
//
//  Created by Chathura Lakmal on 8/13/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import "TTDatabase.h"

@implementation TTDatabase

@synthesize managedObjectContext = _managedObjectContext;

+ (TTDatabase *)sharedDatabaseWithManagedObjectContext:(NSManagedObjectContext*)ctx{
    static TTDatabase *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TTDatabase alloc] initWithManagedObjectContext:ctx];
    });
    
    return _sharedClient;
}

-(TTDatabase *)initWithManagedObjectContext:(NSManagedObjectContext*)ctx{
    _managedObjectContext = ctx;
    return self;
}

+(Tasks *)getTaskByName:(NSString *)name{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:[self sharedDatabaseWithManagedObjectContext:nil].managedObjectContext];
    
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskName == %@", name];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[[self sharedDatabaseWithManagedObjectContext:nil].managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ([mutableFetchResults count] > 0) {
        return [mutableFetchResults objectAtIndex:0];
    }
    
    return nil;
}

+(BOOL)insertTaskInfo:(NSString *)name startTime:(NSString *)startTime endTime:(NSString *)endTime{
    Tasks *tasks  = [self getTaskByName:name];
    
    if(!tasks){
        tasks = [NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:[self sharedDatabaseWithManagedObjectContext:nil].managedObjectContext];
    }
    
    [tasks setTaskName:name];
    
    
    Time *time = [[Time alloc]init];
    
    [time setStartTime:startTime];
    [time setEndTime:endTime];
    
    [tasks addTimeObject:time];
    
    
    return [self commitUpdates];

}

#pragma mark - Common functions
#pragma mark -

+ (BOOL)commitUpdates{
    NSError *error = nil;
    
    if (![[self sharedDatabaseWithManagedObjectContext:nil].managedObjectContext save:&error]) {
        NSLog(@"Commit Error -- Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }else{
        NSLog(@"Commit Success");
        return YES;
    }
}

@end

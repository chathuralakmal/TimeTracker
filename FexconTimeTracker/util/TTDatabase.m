//
//  TTDatabase.m
//  FexconTimeTracker
//
//  Created by Chathura Lakmal on 8/13/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import "TTDatabase.h"
#import "AppDelegate.h"

@implementation TTDatabase
AppDelegate *appDelegate;


- (id)init
{
    self = [super init];
    if (self) {
        
        appDelegate = (AppDelegate *)[[NSApplication sharedApplication]delegate];
        managedObjectContext = [self managedObjectContext];
        managedObjectModel = appDelegate.managedObjectModel;
        persistentStoreCoordinator = appDelegate.persistentStoreCoordinator;
        
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[NSApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
-(BOOL) saveEntity
{
    NSError *error;
    if (![managedObjectContext save:&error])
    {
        return FALSE;
    }
    return TRUE;
}


-(Tasks *)getTaskByName:(NSString *)name{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:managedObjectContext];
    
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskName == %@", name];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ([mutableFetchResults count] > 0) {
        return [mutableFetchResults objectAtIndex:0];
    }
    
    return nil;
}

-(BOOL)insertTaskInfo:(NSString *)name totalSeconds:(NSNumber *)totalSeconds{
    Tasks *tasks  = [self getTaskByName:name];
    
    if(!tasks){
        tasks = [NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:managedObjectContext];//[NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:[self sharedDatabaseWithManagedObjectContext:nil].managedObjectContext];
    }
    
    [tasks setTaskName:name];
    [tasks setTotalSeconds:totalSeconds];
  
    
    NSError * error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        return false;
    }
    return true;

}

-(NSMutableArray *)getAllTasks{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"taskName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *fetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    return fetchResults;
}

-(BOOL)deleteAllTasks{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tasks"];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [managedObjectContext deleteObject:object];
    }
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        return false;
    }
    return true;
}

#pragma mark - Common functions
#pragma mark -


@end

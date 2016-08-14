//
//  Tasks+CoreDataProperties.h
//  FexconTimeTracker
//
//  Created by Chathura Lakmal on 8/14/16.
//  Copyright © 2016 Chathura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tasks.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tasks (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *taskName;
@property (nullable, nonatomic, retain) NSNumber *totalSeconds;

@end

NS_ASSUME_NONNULL_END

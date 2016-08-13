//
//  Time+CoreDataProperties.h
//  FexconTimeTracker
//
//  Created by Chathura Lakmal on 8/13/16.
//  Copyright © 2016 Chathura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Time.h"

NS_ASSUME_NONNULL_BEGIN

@interface Time (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *startTime;
@property (nullable, nonatomic, retain) NSString *endTime;
@property (nullable, nonatomic, retain) NSNumber *totalSeconds;
@property (nullable, nonatomic, retain) Tasks *tasks;

@end

NS_ASSUME_NONNULL_END

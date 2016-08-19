//
//  ReminderPopOver.h
//  FexconTimeTracker
//
//  Created by Chathura on 8/19/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ReminderPopOver : NSViewController

@property (strong) IBOutlet NSDatePicker *dateTime;
@property (strong) IBOutlet NSTextField *reminderText;

@end

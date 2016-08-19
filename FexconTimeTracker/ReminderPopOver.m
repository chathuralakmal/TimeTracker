//
//  ReminderPopOver.m
//  FexconTimeTracker
//
//  Created by Chathura on 8/19/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import "ReminderPopOver.h"

@interface ReminderPopOver ()

@end

@implementation ReminderPopOver

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.dateTime setMinDate:[NSDate date]];
    
}
- (IBAction)setReminderAction:(id)sender {
    
    
    if (!([self.reminderText.stringValue length] > 0)) {
        
        return;
    }
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
//    NSLog(@"Date %@",[dateFormatter stringFromDate:self.dateTime.dateValue]);

    NSTimeInterval secondsBetween = [self.dateTime.dateValue timeIntervalSinceDate:[NSDate date]];
    /** Set Notification **/
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Time Tracker - Reminder!";
    notification.informativeText = [NSString stringWithFormat:@"%@",self.reminderText.stringValue];
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.deliveryDate = [NSDate dateWithTimeIntervalSinceNow:secondsBetween];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
    
    /** Set Notification **/
 
    
    [[[self view] window] close];
    
}

@end

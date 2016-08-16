//
//  ViewController.m
//  FexconTimeTracker
//
//  Created by Chathura on 8/12/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "TTDatabase.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!dbmanager)dbmanager = [[TTDatabase alloc]init];

    NSLog(@"Stored Tasks.... %@",[dbmanager getAllTasks]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:NSApplicationWillBecomeActiveNotification object:nil];
    

    NSString *savedStartedDate = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"startDate"];
    
    NSString *savedCompletedSeconds = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"timerCount"];
    
    NSDate *startDateFromString = [[NSDate alloc] init];
    NSDate *currentDate = [[NSDate alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
   

    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar
    _statusItem.title = [self getFormattedString];
    
    
    // The image that will be shown in the menu bar, a 16x16 black png works best
    _statusItem.image = [NSImage imageNamed:@"clock-icon-8"];
    
    // The highlighted image, use a white version of the normal image
    _statusItem.alternateImage = [NSImage imageNamed:@"clock-icon-8"];
    
    // The image gets a blue background when the item is selected
    _statusItem.highlightMode = YES;

    if(savedStartedDate){

        isTimerActive = TRUE;
        
        startDateFromString = [dateFormatter dateFromString:savedStartedDate];
        NSString *startDate = [dateFormatter stringFromDate:[NSDate date]];
        
        currentDate = [dateFormatter dateFromString:startDate];
        
        
        NSTimeInterval secondsBetween = [currentDate timeIntervalSinceDate:startDateFromString];
        
        [self.appTimer invalidate];
        
        self.timerCount = secondsBetween+[savedCompletedSeconds intValue];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self selector:@selector(stopWatch:)
                                                        userInfo:nil repeats:YES];
        
        self.appTimer = timer;
        
        [self.stopWatchLabel setStringValue:[self getFormattedString]];
        
        [self.startButton setHidden:TRUE];
        [self.stopButton setHidden:FALSE];
        
        
        
    }else{
        /* App Starting from 00 */

        isTimerActive = FALSE;
        
        self.timerCount = 0;
        [self.stopWatchLabel setStringValue:[self getFormattedString]];
    }

    /* populatin data */
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    

    [_tableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];

    [self updateData];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}


- (void)appWillEnterForeground:(NSNotification *)notification {
    
    NSString *savedStartedDate = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"startDate"];
    
    NSString *savedCompletedSeconds = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"timerCount"];
    
    NSDate *startDateFromString = [[NSDate alloc] init];
    NSDate *currentDate = [[NSDate alloc] init];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
   
    
    if(savedStartedDate){
        
        isTimerActive = TRUE;
        
        self.textTaskName.stringValue = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:@"taskName"];
        
        
        [self.textTaskName setEditable:FALSE];
        
        startDateFromString = [dateFormatter dateFromString:savedStartedDate];
        NSString *startDate = [dateFormatter stringFromDate:[NSDate date]];
        
        currentDate = [dateFormatter dateFromString:startDate];
        
        
        NSTimeInterval secondsBetween = [currentDate timeIntervalSinceDate:startDateFromString];
        
        [self.appTimer invalidate];
        
        self.timerCount = secondsBetween+[savedCompletedSeconds intValue];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self selector:@selector(stopWatch:)
                                                        userInfo:nil repeats:YES];
        
        self.appTimer = timer;
        _statusItem.title = [self getFormattedString];

    }

    
}

-(void)updateData{
    self.dataSource = [[NSMutableArray alloc]init];
    self.dataSource = [dbmanager getAllTasks];
    
    if(self.dataSource.count >0){
        [self.clearButton setHidden:FALSE];
    }else{
        [self.clearButton setHidden:TRUE];
    }
    
    menu = [[NSMenu alloc] init];
    
    if(isTimerActive){
         [[menu addItemWithTitle:@"Stop Timer" action:@selector(stopAction:) keyEquivalent:@""] setTarget:self];
    }else{
        [menu addItemWithTitle:@"Stop Timer" action:nil keyEquivalent:@""];
    }
    
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit Time Tracker" action:@selector(terminate:) keyEquivalent:@""];
    _statusItem.menu = menu;
    
    
    [self.tableView reloadData];
}

-(void)viewWillAppear{
    NSLog(@"Testing");
}

-(NSString *)getFormattedString
{
    int t = self.timerCount;
    
        int seconds = t % 60;
        int minutes = (t / 60) % 60;
        int hours = t / 3600;
    
    
    return [NSString stringWithFormat:@" %02d:%02d:%02d ",hours, minutes, seconds];

}


- (IBAction)stopAction:(id)sender {
    
    [self.appTimer invalidate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *stopDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *savedStartedDate = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"startDate"];
    
    
    //First Taking Already Exsist Data
    Tasks *tempTasks = [dbmanager getTaskByName:self.textTaskName.stringValue];
    NSNumber * tempSeconds = tempTasks.totalSeconds;
    
    NSTimeInterval secondsBetween = [[dateFormatter dateFromString:stopDate] timeIntervalSinceDate:[dateFormatter dateFromString:savedStartedDate]];
    
    int totalSeconds = [tempSeconds intValue]+secondsBetween;
    
    [dbmanager insertTaskInfo:self.textTaskName.stringValue totalSeconds:[NSNumber numberWithInt:totalSeconds]];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startDate"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"taskName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.timerCount = 0;
    [self.stopWatchLabel setStringValue:[self getFormattedString]];
    [_statusItem setTitle:[self getFormattedString]];
    
    [self.startButton setHidden:FALSE];
    [self.stopButton setHidden:TRUE];
    
    self.textTaskName.stringValue = @"";
    
    [self.textTaskName setEditable:TRUE];
    
    isTimerActive = FALSE;
    
    [self updateData];
    
}
- (IBAction)startAction:(id)sender {
    
    
    if (!([self.textTaskName.stringValue length] > 0)) {
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Alert!" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please Enter Task Name First."];
        [alert runModal];
        
        return;
    }

    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self selector:@selector(stopWatch:)
                                                    userInfo:nil repeats:YES];
    self.appTimer = timer;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *startDate = [dateFormatter stringFromDate:[NSDate date]];

    [[NSUserDefaults standardUserDefaults] setObject:startDate forKey:@"startDate"];
    [[NSUserDefaults standardUserDefaults] setObject:self.textTaskName.stringValue forKey:@"taskName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.startButton setHidden:TRUE];
    [self.stopButton setHidden:FALSE];
    
    [self.textTaskName setEditable:FALSE];
    
    isTimerActive = TRUE;
    
    [self updateData];
    
}

- (void)stopWatch:(NSTimer*)theTimer {
    self.timerCount = self.timerCount + 1;
    [self.stopWatchLabel setStringValue:[self getFormattedString]];
    [_statusItem setTitle:[self getFormattedString]];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.dataSource.count;
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];

    Tasks *tempTask = [self.dataSource objectAtIndex:row];
    
    if ([tableColumn.identifier isEqualToString:@"number"]) {
        
        cellView.textField.stringValue = [NSString stringWithFormat:@"%ld",(long)row];
        
    } else if([tableColumn.identifier isEqualToString:@"name"]) {
        
       cellView.textField.stringValue = tempTask.taskName;

        
    } else if ([tableColumn.identifier isEqualToString:@"time"]){
        
        cellView.textField.stringValue = [self timeFormatted:[tempTask.totalSeconds intValue]];
    
    }
    [tableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
    [tableColumn setResizingMask:NSTableColumnAutoresizingMask];

    return cellView;
}


- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (IBAction)clearAction:(id)sender {
    
    [dbmanager deleteAllTasks];
    [self updateData];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    Tasks *tempTask = [self.dataSource objectAtIndex:row];
    
    
    /** if True. no current task. **/
   // if(self.textTaskName.editable){
    if(!isTimerActive){
       NSLog(@"Selected Item %@",tempTask.taskName);
        self.textTaskName.stringValue = tempTask.taskName;
        alreadyCompletedSeconds = [tempTask.totalSeconds stringValue];
        self.timerCount = [tempTask.totalSeconds intValue];
        [self.stopWatchLabel setStringValue:[self getFormattedString]];
        [self.textTaskName setEditable:FALSE];
      
        
        [self.startButton setHidden:TRUE];
        [self.stopButton setHidden:TRUE];
        [self.buttonNew setHidden:FALSE];
        [self.continueButton setHidden:FALSE];
    }
    
   // }
    
    return true;
}
- (IBAction)continueAction:(id)sender {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self selector:@selector(stopWatch:)
                                                    userInfo:nil repeats:YES];
    self.appTimer = timer;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *startDate = [dateFormatter stringFromDate:[NSDate date]];
    
    [[NSUserDefaults standardUserDefaults] setObject:startDate forKey:@"startDate"];
    [[NSUserDefaults standardUserDefaults] setObject:alreadyCompletedSeconds forKey:@"timerCount"];
    [[NSUserDefaults standardUserDefaults] setObject:self.textTaskName.stringValue forKey:@"taskName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.startButton setHidden:TRUE];
    [self.stopButton setHidden:FALSE];
    [self.continueButton setHidden:TRUE];
    [self.buttonNew setHidden:TRUE];
    
    [self.textTaskName setEditable:FALSE];
    
    isTimerActive = TRUE;
    
    [self updateData];
    
    
    
}
- (IBAction)newAction:(id)sender {
    self.textTaskName.stringValue = @"";
    [self.textTaskName setEditable:TRUE];
    [self.startButton setHidden:FALSE];
    [self.stopButton setHidden:TRUE];
    [self.buttonNew setHidden:TRUE];
    [self.continueButton setHidden:TRUE];
    
}
@end

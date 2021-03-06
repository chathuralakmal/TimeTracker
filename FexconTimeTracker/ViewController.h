//
//  ViewController.h
//  FexconTimeTracker
//
//  Created by Chathura on 8/12/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTDatabase.h"
#import "ReminderPopOver.h"

@interface ViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource,NSUserNotificationCenterDelegate,NSMenuDelegate,NSPopoverDelegate>{
    TTDatabase *dbmanager;

    BOOL loadedAppDelegate;
    
    BOOL isTimerActive;
    
    NSMenu *menu;
    
    NSString *alreadyCompletedSeconds;
}

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong) IBOutlet NSTextField *stopWatchLabel;

@property (nonatomic, retain) NSTimer *appTimer;
@property (nonatomic, assign) int timerCount;

@property (nonatomic, assign) BOOL alreadyRunning;
@property (strong) IBOutlet NSButton *startButton;
@property (strong) IBOutlet NSButton *stopButton;
@property (strong) IBOutlet NSButton *clearButton;
@property (strong) IBOutlet NSButton *continueButton;
@property (strong) IBOutlet NSButton *buttonNew;

@property (strong) IBOutlet NSTextField *textTaskName;

@property (strong, nonatomic) NSStatusItem *statusItem;

@property (nonatomic, strong) IBOutlet NSTableView *tableView;

@property (strong) NSMutableArray *dataSource;



@property (strong) NSPopover *myPopover;
@property (strong) ReminderPopOver *popoverViewController;

@property (strong) NSWindow *detachedWindow;
@property (strong) NSPanel *detachedHUDWindow;



//-(void)loadData;
@end


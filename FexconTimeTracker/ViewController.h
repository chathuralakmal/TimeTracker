//
//  ViewController.h
//  FexconTimeTracker
//
//  Created by Chathura on 8/12/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

@property (strong) IBOutlet NSTextField *stopWatchLabel;

@property (nonatomic, retain) NSTimer *appTimer;
@property (nonatomic, assign) int timerCount;

@property (nonatomic, assign) BOOL alreadyRunning;
@property (strong) IBOutlet NSButton *startButton;
@property (strong) IBOutlet NSButton *stopButton;



@property (strong, nonatomic) NSStatusItem *statusItem;


@property (nonatomic, strong) IBOutlet NSTableView *tableView;

@property (strong) NSMutableArray *dataSource;

@end


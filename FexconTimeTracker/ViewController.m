//
//  ViewController.m
//  FexconTimeTracker
//
//  Created by Chathura on 8/12/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:NSApplicationWillBecomeActiveNotification object:nil];
    

    NSString *savedStartedDate = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"startDate"];
    
    NSDate *startDateFromString = [[NSDate alloc] init];
    NSDate *currentDate = [[NSDate alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    
    if(savedStartedDate){
        startDateFromString = [dateFormatter dateFromString:savedStartedDate];
        NSString *startDate = [dateFormatter stringFromDate:[NSDate date]];
        
        currentDate = [dateFormatter dateFromString:startDate];
        
        
        NSTimeInterval secondsBetween = [currentDate timeIntervalSinceDate:startDateFromString];
        
        [self.appTimer invalidate];
        
        self.timerCount = secondsBetween;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self selector:@selector(stopWatch:)
                                                        userInfo:nil repeats:YES];
        
        self.appTimer = timer;
        
        [self.stopWatchLabel setStringValue:[self getFormattedString]];
        
        [self.startButton setHidden:TRUE];
        [self.stopButton setHidden:FALSE];
    }else{
        /* App Starting from 00 */
        self.timerCount = 0;
        [self.stopWatchLabel setStringValue:[self getFormattedString]];
    }
    
    
    
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar
    _statusItem.title = [self getFormattedString];
    
    
    //    // The image that will be shown in the menu bar, a 16x16 black png works best
//        _statusItem.image = [NSImage imageNamed:@"task_O_completed"];
    //
    //    // The highlighted image, use a white version of the normal image
    //    _statusItem.alternateImage = [NSImage imageNamed:@"feedbin-logo-alt"];
    
    // The image gets a blue background when the item is selected
    _statusItem.highlightMode = YES;

    
    NSMenu *menu = [[NSMenu alloc] init];
    [[menu addItemWithTitle:@"Stop Timer" action:@selector(stopAction:) keyEquivalent:@""] setTarget:self];;
    
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit Time Tracker" action:@selector(terminate:) keyEquivalent:@""];
    _statusItem.menu = menu;
    
    
    
    /* populatin data */
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    NSArray *myColors;
    
    myColors = [NSArray arrayWithObjects: @"Red", @"Green", @"Blue", @"Yellow", nil];
    
    self.dataSource = [[NSMutableArray alloc]init];
    
    self.dataSource = [myColors mutableCopy];
    
    
      [self.tableView reloadData];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}


- (void)appWillEnterForeground:(NSNotification *)notification {
    
    NSString *savedStartedDate = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"startDate"];
    
    NSDate *startDateFromString = [[NSDate alloc] init];
    NSDate *currentDate = [[NSDate alloc] init];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    
    if(savedStartedDate){
        startDateFromString = [dateFormatter dateFromString:savedStartedDate];
        NSString *startDate = [dateFormatter stringFromDate:[NSDate date]];
        
        currentDate = [dateFormatter dateFromString:startDate];
        
        
        NSTimeInterval secondsBetween = [currentDate timeIntervalSinceDate:startDateFromString];
        
        [self.appTimer invalidate];
        
        self.timerCount = secondsBetween;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self selector:@selector(stopWatch:)
                                                        userInfo:nil repeats:YES];
        
        self.appTimer = timer;
        _statusItem.title = [self getFormattedString];

    }
    
    
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
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startDate"];
        
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.timerCount = 0;
    [self.stopWatchLabel setStringValue:[self getFormattedString]];
    [_statusItem setTitle:[self getFormattedString]];
    
    [self.startButton setHidden:FALSE];
    [self.stopButton setHidden:TRUE];
    
}
- (IBAction)startAction:(id)sender {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self selector:@selector(stopWatch:)
                                                    userInfo:nil repeats:YES];
    self.appTimer = timer;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *startDate = [dateFormatter stringFromDate:[NSDate date]];

    [[NSUserDefaults standardUserDefaults] setObject:startDate forKey:@"startDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.startButton setHidden:TRUE];
    [self.stopButton setHidden:FALSE];
    
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
    
    cellView.textField.stringValue = @"Test";

    return cellView;
}


@end

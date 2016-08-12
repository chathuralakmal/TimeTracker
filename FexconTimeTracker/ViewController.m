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
    }else{
        /* App Starting from ) */
        self.timerCount = 0;
        [self.stopWatchLabel setStringValue:[self getFormattedString]];
    }
    
    
    
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
    
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];

}


- (IBAction)stopAction:(id)sender {
    
    [self.appTimer invalidate];
    
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
    
}

- (void)stopWatch:(NSTimer*)theTimer {
    self.timerCount = self.timerCount + 1;
    [self.stopWatchLabel setStringValue:[self getFormattedString]];
    
}

@end

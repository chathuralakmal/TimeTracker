//
//  ViewController.h
//  FexconTimeTracker
//
//  Created by Chathura on 8/12/16.
//  Copyright © 2016 Chathura. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (strong) IBOutlet NSTextField *stopWatchLabel;

@property (nonatomic, retain) NSTimer *appTimer;
@property (nonatomic, assign) int timerCount;

@property (nonatomic, assign) BOOL alreadyRunning;


@end


//
//  AppDelegate.m
//  Bitcoin Profit
//
//  Created by Jaakko Holster on 13.4.2013.
//  Copyright (c) 2013 Jaakko Holster. All rights reserved.
//

#import "AppDelegate.h"

const int UPDATE_INTERVAL = 60;
const double INVESTMENT = 2550.75;
const double BALANCE_BTC = 41.1388;
const double COMISSION_REAL = 0.0199;
const double COMISSION_BTC = 0.02;

@implementation AppDelegate

@synthesize menu;
@synthesize statusItem;
@synthesize updatedAt;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {}

- (void)awakeFromNib
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    //self.statusItem.enabled = YES;
    self.statusItem.highlightMode = YES;
    self.statusItem.menu = self.menu;

    self.updatedAt = [[NSMenuItem alloc] initWithTitle:@"Not updated" action:NULL keyEquivalent:@""];
    [self.menu insertItem:self.updatedAt atIndex:0];

	self.statusItem.title = @"Updating...";
    [self refresh];
    [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (void)refresh
{
    NSURL *url = [NSURL URLWithString:@"https://data.mtgox.com/api/2/BTCEUR/money/ticker"];
    NSError *error = nil;
    NSData *json = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    if (error) {
        self.statusItem.enabled = NO;
        return;
    }

    self.statusItem.enabled = YES;

    id ticker = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];
    
    NSString *valueStr = [ticker valueForKeyPath:@"data.sell.value"];
    NSDecimalNumber *rate = [NSDecimalNumber decimalNumberWithString:valueStr];
    NSDecimalNumber *holding = [[NSDecimalNumber alloc] initWithDouble:BALANCE_BTC];
    NSDecimalNumber *balance = [rate decimalNumberByMultiplyingBy:holding];
    NSDecimalNumber *paid = [[NSDecimalNumber alloc] initWithDouble:INVESTMENT];
    NSDecimalNumber *comissionReal = [balance decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithDouble:COMISSION_REAL]];
    NSDecimalNumber *comissionBTC = [rate decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithDouble:COMISSION_BTC]];
    NSDecimalNumber *comission = [comissionReal decimalNumberByAdding:comissionBTC];
    NSDecimalNumber *profit = [[balance decimalNumberBySubtracting:paid] decimalNumberBySubtracting:comission];
    NSDecimalNumber *profitPercentage = [[profit decimalNumberByDividingBy:paid] decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithInt:100]];
    NSString *title = [NSString stringWithFormat:@"%d€  %d€  %d%%", [rate intValue], [profit intValue], [profitPercentage intValue]];
	[self.statusItem setTitle:title];
	//[statusItem setToolTip:@"updated <date>"];
	//[self.statusItem setEnabled:NO];

    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:now
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    NSString *titleUpdatedAt = [NSString stringWithFormat:@"Updated at %@", dateString];
    self.updatedAt.title = titleUpdatedAt;
    
}

@end

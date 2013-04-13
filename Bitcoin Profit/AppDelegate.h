//
//  AppDelegate.h
//  Bitcoin Profit
//
//  Created by Jaakko Holster on 13.4.2013.
//  Copyright (c) 2013 Jaakko Holster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *menu;
@property (retain) NSMenuItem *updatedAt;

@end

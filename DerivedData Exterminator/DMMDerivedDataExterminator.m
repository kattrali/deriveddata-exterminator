//
//  DMMDerivedDataExterminator.m
//  DerivedDataExterminator
//
//  Created by Delisa Mason on 4/13/13.
//  Copyright (c) 2013 Delisa Mason.
//

#import "DMMDerivedDataExterminator.h"
#import "DMMDerivedDataHandler.h"

@interface NSObject (IDEKit)
+ (id) workspaceWindowControllers;
@end

@implementation DMMDerivedDataExterminator


+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
}

- (id)init
{
    if (self = [super init]) {
        NSMenuItem *viewMenuItem = [[NSApp mainMenu] itemWithTitle:@"View"];
        if (viewMenuItem) {
            [[viewMenuItem submenu] addItem:[NSMenuItem separatorItem]];

            NSMenuItem *clearItem = [[NSMenuItem alloc] initWithTitle:@"Clear Derived Data for Project" action:@selector(clearDerivedDataForKeyWindow) keyEquivalent:@"h"];
            [clearItem setKeyEquivalentModifierMask: NSShiftKeyMask | NSCommandKeyMask];
            [clearItem setTarget:self];
            [[viewMenuItem submenu] addItem:clearItem];

            NSMenuItem *clearAllItem = [[NSMenuItem alloc] initWithTitle:@"Clear All Derived Data" action:@selector(clearAllDerivedData) keyEquivalent:@""];
            [clearAllItem setTarget:self];
            [[viewMenuItem submenu] addItem:clearAllItem];
        }

    }
    return self;
}

#pragma mark - DerivedData Management


- (void) clearDerivedDataForKeyWindow
{
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") workspaceWindowControllers];

    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isKeyWindow]) {
            id workspace = [controller valueForKey:@"_workspace"];
            [DMMDerivedDataHandler clearDerivedDataForProject:[workspace valueForKey:@"name"]];
        }
    }
}

- (void) clearAllDerivedData
{
    [DMMDerivedDataHandler clearAllDerivedData];
}

@end
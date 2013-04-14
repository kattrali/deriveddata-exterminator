//
//  DMMDerivedDataExterminator.m
//  DerivedDataExterminator
//
//  Created by Delisa Mason on 4/13/13.
//  Copyright (c) 2013 Delisa Mason. All rights reserved.
//

#import "DMMDerivedDataExterminator.h"
#import "DMMExterminatorButtonView.h"

#define EXTERMINATOR_BUTTON_CONTAINER_TAG	932
#define EXTERMINATOR_BUTTON_TAG				    933

#define EXTERMINATOR_DEFAULT_BUTTON_WIDTH   118.f
#define EXTERMINATOR_BUTTON_OFFSET_FROM_R   62 // position of button relative to the right edge of the window

#define kDMMDerivedDataExterminatorShowButtonInTitleBar	@"DMMDerivedDataExterminatorShowButtonInTitleBar"

@interface NSObject (IDEKit)
+ (id)workspaceWindowControllers;
@end

@interface DMMDerivedDataExterminator()

- (DMMExterminatorButtonView *) exterminatorButtonContainerForWindow: (NSWindow *) window;
- (void) updateTitleBarsFromPreferences;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidEndLiveResize:) name:NSWindowDidEndLiveResizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitleBarsFromPreferences) name:NSWindowDidBecomeKeyNotification object:nil];
        
    NSMenuItem *viewMenuItem = [[NSApp mainMenu] itemWithTitle:@"View"];
    if (viewMenuItem) {
        [[viewMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *toggleButtonInTitleBarItem = [[[NSMenuItem alloc] initWithTitle:@"Derived Data Exterminator in Title Bar" action:@selector(toggleButtonInTitleBar:) keyEquivalent:@""] autorelease];
        [toggleButtonInTitleBarItem setTarget:self];
        [[viewMenuItem submenu] addItem:toggleButtonInTitleBarItem];
    }
    
  }
  return self;
}

- (void) exterminate
{
    NSLog(@"EXTERMINATE!");
}

- (NSView *)windowTitleViewForWindow:(NSWindow *)window
{
	NSView *windowFrameView = [[window contentView] superview];
	for (NSView *view in windowFrameView.subviews) {
		if ([view isKindOfClass:NSClassFromString(@"DVTDualProxyWindowTitleView")]) {
			return view;
		}
	}
	return nil;
}

- (BOOL) isButtonEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kDMMDerivedDataExterminatorShowButtonInTitleBar];
}

- (void) setButtonEnabled: (BOOL) enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kDMMDerivedDataExterminatorShowButtonInTitleBar];
}

- (void) toggleButtonInTitleBar:(id)sender
{
    [self setButtonEnabled:![self isButtonEnabled]];
	[self updateTitleBarsFromPreferences];
}

- (void) updateTitleBarsFromPreferences
{
    @try {
		NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") workspaceWindowControllers];
		for (NSWindow *window in [workspaceWindowControllers valueForKey:@"window"]) {
            DMMExterminatorButtonView *buttonView = [self exterminatorButtonContainerForWindow:window];
			if (buttonView) [buttonView setHidden:![self isButtonEnabled]];
		}
	}
	@catch (NSException *exception) { }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if ([menuItem action] == @selector(toggleButtonInTitleBar:)) {
		[menuItem setState:[self isButtonEnabled] ? NSOnState : NSOffState];
	}
	return YES;
}

- (NSButton *) exterminatorButtonForWindow: (NSWindow *) window
{
    DMMExterminatorButtonView *container = [self exterminatorButtonContainerForWindow:window];
	return container.button;
}

- (DMMExterminatorButtonView *) exterminatorButtonContainerForWindow: (NSWindow *) window {
    if ([window isKindOfClass:NSClassFromString(@"IDEWorkspaceWindow")]) {
		NSView *windowFrameView = [[window contentView] superview];
        DMMExterminatorButtonView *container = [windowFrameView viewWithTag:EXTERMINATOR_BUTTON_CONTAINER_TAG];
        
		if (!container) {
			CGFloat buttonWidth = EXTERMINATOR_DEFAULT_BUTTON_WIDTH;
			NSView *titleView = [self windowTitleViewForWindow:window];
			if (titleView) {
				buttonWidth = MIN(buttonWidth, titleView.frame.origin.x - 10 - 80);
			}
			container = [[[DMMExterminatorButtonView alloc] initWithFrame:NSMakeRect(window.frame.size.width - buttonWidth - EXTERMINATOR_BUTTON_OFFSET_FROM_R, windowFrameView.bounds.size.height - 22, buttonWidth + 10, 20)] autorelease];
			container.tag = EXTERMINATOR_BUTTON_CONTAINER_TAG;
			container.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin | NSViewWidthSizable;
            container.button.target = self;
            container.button.action = @selector(exterminate);

			[container setHidden:![self isButtonEnabled]];
			[windowFrameView addSubview:container];

		}
		return container;
	}
	return nil;
}

- (void)windowDidEndLiveResize:(NSNotification *) notification
{
	NSWindow *window = [notification object];
	NSView *button = [self exterminatorButtonForWindow:window];
	if (button) {
		double delayInSeconds   = 0.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
			[button setHidden:![self isButtonEnabled]];
		});
	}
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end

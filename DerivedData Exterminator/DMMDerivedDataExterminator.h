//
//  DMMDerivedDataExterminator.h
//  DerivedDataExterminator
//
//  Created by Delisa Mason on 4/13/13.
//  Copyright (c) 2013 Delisa Mason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface DMMDerivedDataExterminator : NSObject

- (void) exterminate;
- (void) toggleButtonInTitleBar: (id) sender;
- (NSButton *) exterminatorButtonForWindow: (NSWindow *) window;
@end

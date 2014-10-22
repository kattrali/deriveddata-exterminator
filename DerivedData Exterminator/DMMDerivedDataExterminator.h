//
//  DMMDerivedDataExterminator.h
//  DerivedDataExterminator
//
//  Created by Delisa Mason on 4/13/13.
//  Copyright (c) 2013 Delisa Mason.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface DMMDerivedDataExterminator : NSObject

- (void)clearAllDerivedData;
- (void)clearDerivedDataForKeyWindow;
@end
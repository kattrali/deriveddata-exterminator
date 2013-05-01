//
//  DMMDerivedDataHandler.h
//  DerivedData Exterminator
//
//  Created by Delisa Mason on 5/1/13.
//  Copyright (c) 2013 Delisa Mason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface DMMDerivedDataHandler : NSObject

+ (void) clearDerivedDataForProject: (NSString *) projectName;
+ (void) clearAllDerivedData;

@end
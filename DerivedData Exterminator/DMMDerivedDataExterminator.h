
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface DMMDerivedDataExterminator : NSObject

- (void)clearAllDerivedData;
- (void)clearDerivedDataForKeyWindow;
@end
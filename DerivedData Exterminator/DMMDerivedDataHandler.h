
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface DMMDerivedDataHandler : NSObject

+ (void)clearDerivedDataForProject:(NSString*)projectName;
+ (void)clearAllDerivedData;
+ (void)clearModuleCache;

@end

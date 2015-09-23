
#import "DMMDerivedDataHandler.h"

@interface NSObject (IDEKit)
+ (id)workspaceWindowControllers;
- (id)derivedDataLocation;
@end

@implementation DMMDerivedDataHandler

+ (void)clearDerivedDataForProject:(NSString*)projectName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* strippedName = [projectName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString* projectPrefix = [NSString stringWithFormat:@"%@-", strippedName];
        NSMutableArray* paths = [NSMutableArray new];
        for (NSString* subdirectory in [self derivedDataSubdirectoryPaths]) {
            if ([[[subdirectory pathComponents] lastObject] hasPrefix:projectPrefix]) {
                [paths addObject:subdirectory];
            }
        }
        [self removeDirectoriesAtPaths:paths];
    });
}

+ (void)clearAllDerivedData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self removeDirectoriesAtPaths:[self derivedDataSubdirectoryPaths]];
    });
}

+ (void) clearModuleCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* path = [[self derivedDataLocation] stringByAppendingPathComponent:@"ModuleCache"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [self removeDirectoriesAtPaths:@[path]];
        }
    });
}

+ (void)showNotificationWithMessage:(NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserNotification *notification = [NSUserNotification new];
        notification.title = @"DerivedData Exterminator";
        notification.informativeText = message;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    });
}

#pragma mark - Private

+ (NSString*)derivedDataLocation
{
    NSArray* workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") workspaceWindowControllers];
    if (workspaceWindowControllers.count < 1)
        return nil;

    id workspace = [workspaceWindowControllers[0] valueForKey:@"_workspace"];
    id workspaceArena = [workspace valueForKey:@"_workspaceArena"];
    [workspaceArena derivedDataLocation]; // Initialize custom location
    return [[workspaceArena derivedDataLocation] valueForKey:@"_pathString"];
}

+ (NSArray*)derivedDataSubdirectoryPaths
{
    NSMutableArray* workspaceDirectories = [NSMutableArray array];
    NSString* derivedDataPath = [self derivedDataLocation];
    if (derivedDataPath) {
        NSError* error = nil;
        NSArray* directories = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:derivedDataPath error:&error];
        if (error) {
            NSLog(@"DD-E: Error while fetching derived data subdirectories: %@", derivedDataPath);
        }
        else {
            for (NSString* subdirectory in directories) {
                NSString* removablePath = [derivedDataPath stringByAppendingPathComponent:subdirectory];
                [workspaceDirectories addObject:removablePath];
            }
        }
    }
    return workspaceDirectories;
}

+ (void)removeDirectoriesAtPaths:(NSArray*)paths {
    BOOL success = YES;
    for (NSString* path in paths) {
        success = success && [self removeDirectoryAtPath:path];
    }
    if (success)
        [self showNotificationWithMessage:@"Cleared derived data"];
}

+ (BOOL)removeDirectoryAtPath:(NSString*)path
{
    NSError* error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"DD-E: Failed to remove all Derived Data: %@ Path: %@", [error description], path);
        [self showErrorAlert:error forPath:path];
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        // Retry once
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    return ![[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (void)showErrorAlert:(NSError*)error forPath:(NSString*)path
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert* alert = [NSAlert new];
        alert.messageText = [NSString stringWithFormat:@"An error occurred while removing %@:\n\n %@", path, [error localizedDescription]];
        [alert runModal];
    });
}

@end
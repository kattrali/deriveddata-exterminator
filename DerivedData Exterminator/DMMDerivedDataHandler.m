
#import "DMMDerivedDataHandler.h"

@interface NSObject (IDEKit)
+ (id)workspaceWindowControllers;
- (id)derivedDataLocation;
@end

@implementation DMMDerivedDataHandler

+ (void)clearDerivedDataForProject:(NSString*)projectName
{
    NSString* projectPrefix = [projectName stringByReplacingOccurrencesOfString:@" " withString:@"_"];

    for (NSString* subdirectory in [self derivedDataSubdirectoryPaths]) {
        if ([[[subdirectory pathComponents] lastObject] hasPrefix:projectPrefix]) {
            [self removeDirectoryAtPath:subdirectory];
        }
    }
}

+ (void)clearAllDerivedData
{
    for (NSString* subdirectory in [self derivedDataSubdirectoryPaths]) {
        [self removeDirectoryAtPath:subdirectory];
    }
}

+ (void) clearModuleCache
{
    NSString* path = [[self derivedDataLocation] stringByAppendingPathComponent:@"ModuleCache"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self removeDirectoryAtPath:path];
    }
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

+ (void)removeDirectoryAtPath:(NSString*)path
{
    NSLog(@"DD-E: Clearing Derived Data at Path: %@", path);
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

    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self showErrorAlert:[NSError errorWithDomain:[NSString stringWithFormat:@"DerivedData Exterminator - removing directory failed after multiple attempts: %@", path] code:668 userInfo:nil] forPath:path];
    }
}

+ (void)showErrorAlert:(NSError*)error forPath:(NSString*)path
{
    NSAlert* alert = [NSAlert new];
    alert.messageText = [NSString stringWithFormat:@"An error occurred while removing %@:\n\n %@", path, [error localizedDescription]];
    [alert runModal];
}

@end
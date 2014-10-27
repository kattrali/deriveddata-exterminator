
#import "DMMDerivedDataExterminator.h"
#import "DMMDerivedDataHandler.h"
#import "DMMButtonViewController.h"

@interface NSObject (IDEWorkspaceWindowController)
+ (id)workspaceWindowControllers;
@end

@interface NSObject (DVTViewControllerToolbarItem)
+ (instancetype)alloc;
- (id)initWithItemIdentifier:(NSString*)identifier;
- (NSArray*)allowedItemIdentifiers;
- (NSDictionary*)toolbarItemProviders;
@end

@interface DMMDerivedDataExterminator ()
- (void)updateToolbarsFromPreferences;

@property (nonatomic, strong) NSBundle* bundle;
@end

@implementation DMMDerivedDataExterminator

static NSString* const DMMDerivedDataExterminatorButtonIdentifier = @"me.delisa.DMMDerivedDataExterminator";
static NSString* const DMMDerivedDataExterminatorShowButtonInTitleBar = @"DMMDerivedDataExterminatorShowButtonInTitleBar";

+ (void)pluginDidLoad:(NSBundle*)plugin
{
    static DMMDerivedDataExterminator* sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
        sharedPlugin.bundle = plugin;
    });
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToolbarsFromPreferences) name:NSWindowDidBecomeKeyNotification object:nil];
        [self createMenuItems];
    }
    return self;
}

- (void)createMenuItems
{
    NSMenuItem* viewMenuItem = [[NSApp mainMenu] itemWithTitle:@"View"];
    if (viewMenuItem) {
        [[viewMenuItem submenu] addItem:[NSMenuItem separatorItem]];

        NSMenuItem* clearItem = [[NSMenuItem alloc] initWithTitle:@"Clear Derived Data for Project" action:@selector(clearDerivedDataForKeyWindow) keyEquivalent:@"h"];
        [clearItem setKeyEquivalentModifierMask:NSShiftKeyMask | NSCommandKeyMask];
        [clearItem setTarget:self];
        [[viewMenuItem submenu] addItem:clearItem];

        NSMenuItem* clearAllItem = [[NSMenuItem alloc] initWithTitle:@"Clear All Derived Data" action:@selector(clearAllDerivedData) keyEquivalent:@""];
        [clearAllItem setTarget:self];
        [[viewMenuItem submenu] addItem:clearAllItem];

        NSMenuItem* clearModuleCache = [[NSMenuItem alloc] initWithTitle:@"Clear Module Cache" action:@selector(clearModuleCache) keyEquivalent:@""];
        [clearModuleCache setTarget:self];
        [[viewMenuItem submenu] addItem:clearModuleCache];

        NSMenuItem* toggleButtonInToolbarItem = [[NSMenuItem alloc] initWithTitle:@"Derived Data Exterminator in Toolbar" action:@selector(toggleButtonInToolbar:) keyEquivalent:@""];
        [toggleButtonInToolbarItem setTarget:self];
        [[viewMenuItem submenu] addItem:toggleButtonInToolbarItem];
    }
}

#pragma mark - DerivedData Management

- (void)clearDerivedDataForKeyWindow
{
    NSArray* workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") workspaceWindowControllers];

    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isKeyWindow]) {
            id workspace = [controller valueForKey:@"_workspace"];
            [DMMDerivedDataHandler clearDerivedDataForProject:[workspace valueForKey:@"name"]];
            return;
        }
    }
}

- (void)clearAllDerivedData
{
    [DMMDerivedDataHandler clearAllDerivedData];
}

- (void)clearModuleCache
{
    [DMMDerivedDataHandler clearModuleCache];
}

#pragma mark - GUI Management

- (void)toggleButtonInToolbar:(id)sender
{
    [self setButtonEnabled:![self isButtonEnabled]];
    [self updateToolbarsFromPreferences];
}

- (void)updateToolbarsFromPreferences
{
    @try {
        NSArray* workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") workspaceWindowControllers];
        BOOL shouldShowButton = [self isButtonEnabled];
        for (NSWindow* window in [workspaceWindowControllers valueForKey:@"window"]) {
            [self registerToolbarButtonAndProviderForWindow:window];
            if (shouldShowButton)
                [self insertToolbarButtonForWindow:window];
            else
                [self removeToolbarButtonForWindow:window];
        }
    }
    @catch (NSException* exception) {}
}

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem
{
    if ([menuItem action] == @selector(toggleButtonInToolbar:)) {
        [menuItem setState:[self isButtonEnabled] ? NSOnState : NSOffState];
    }
    return YES;
}

- (void)registerToolbarButtonAndProviderForWindow:(NSWindow*)window
{
    NSObject<NSToolbarDelegate>* delegate = window.toolbar.delegate;
    NSArray* allowedIdentifiers = [delegate allowedItemIdentifiers];
    NSMutableDictionary* providers = [delegate toolbarItemProviders].mutableCopy;
    if (![allowedIdentifiers containsObject:DMMDerivedDataExterminatorButtonIdentifier]) {
        allowedIdentifiers = [allowedIdentifiers arrayByAddingObject:DMMDerivedDataExterminatorButtonIdentifier];
        providers[DMMDerivedDataExterminatorButtonIdentifier] = self;
        [delegate setValue:allowedIdentifiers forKey:@"_allowedItemIdentifiers"];
        [delegate setValue:providers forKey:@"_toolbarItemProviders"];
    }
}

- (void)insertToolbarButtonForWindow:(NSWindow*)window
{
    for (NSToolbarItem* item in window.toolbar.items) {
        if ([item.itemIdentifier isEqualToString:DMMDerivedDataExterminatorButtonIdentifier])
            return;
    }
    NSInteger index = MAX(0, window.toolbar.items.count - 1);
    [window.toolbar insertItemWithItemIdentifier:DMMDerivedDataExterminatorButtonIdentifier
                                         atIndex:index];
}

- (void)removeToolbarButtonForWindow:(NSWindow*)window
{
    NSInteger index = NSNotFound;
    for (int i = 0; i < window.toolbar.items.count; i++) {
        NSToolbarItem* item = window.toolbar.items[i];
        if ([item.itemIdentifier isEqualToString:DMMDerivedDataExterminatorButtonIdentifier]) {
            index = i;
            break;
        }
    }
    if (index != NSNotFound) {
        [window.toolbar removeItemAtIndex:index];
    }
}

- (id)toolbarItemForToolbarInWindow:(id)arg1
{
    Class DVTViewControllerToolbarItem = NSClassFromString(@"DVTViewControllerToolbarItem");
    NSToolbarItem* exterminatorItem = (NSToolbarItem*)[[DVTViewControllerToolbarItem alloc] initWithItemIdentifier:DMMDerivedDataExterminatorButtonIdentifier];

    exterminatorItem.target = self;
    exterminatorItem.action = @selector(clearDerivedDataForKeyWindow);
    exterminatorItem.toolTip = @"Clear DerivedData";
    exterminatorItem.label = @"DerivedData";
    exterminatorItem.maxSize = NSMakeSize(16, 16);
    exterminatorItem.image = [[NSImage alloc] initByReferencingFile:[self.bundle pathForResource:@"icon" ofType:@"tiff"]];
    exterminatorItem.image.template = YES;
    [exterminatorItem setValue:[DMMButtonViewController new] forKey:@"viewController"];
    return exterminatorItem;
}

#pragma mark Preferences

- (BOOL)isButtonEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:DMMDerivedDataExterminatorShowButtonInTitleBar];
}

- (void)setButtonEnabled:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:DMMDerivedDataExterminatorShowButtonInTitleBar];
}

@end

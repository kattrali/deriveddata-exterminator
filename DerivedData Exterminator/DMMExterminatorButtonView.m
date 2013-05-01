//
//  DMMExterminatorButtonView.m
//  DerivedDataExterminator
//
//  Created by Delisa Mason on 4/13/13.
//  Copyright (c) 2013 Delisa Mason.
//

#import "DMMExterminatorButtonView.h"

#define EXTERMINATOR_DEFAULT_BUTTON_WIDTH 118.f
#define EXTERMINATOR_CONTAINER_MARGIN     2.f

@implementation DMMExterminatorButtonView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, [self buttonWidthRelativeToFrame], 20)];
        _button.autoresizingMask = NSViewWidthSizable;

        [_button setBezelStyle:NSTexturedRoundedBezelStyle];
        [[_button cell] setControlSize:NSSmallControlSize];
        [_button setFont:[NSFont systemFontOfSize:11.0]];
        [_button setTitle:@"Clear DerivedData"];
        [self addSubview:_button];
    }

    return self;
}

- (BOOL)isOpaque
{
    return NO;
}

- (float) buttonWidthRelativeToFrame
{
    return MAX(MIN(EXTERMINATOR_DEFAULT_BUTTON_WIDTH, self.frame.size.width - EXTERMINATOR_CONTAINER_MARGIN * 2), 0);
}

- (void) resizeSubviewsWithOldSize:(NSSize)oldSize
{
    float buttonWidth = [self buttonWidthRelativeToFrame];
    self.button.frame = CGRectMake(self.frame.size.width - buttonWidth - EXTERMINATOR_CONTAINER_MARGIN, self.button.frame.origin.y, buttonWidth, self.button.frame.size.height);
}

- (void)dealloc
{
    [_button release];
    [super dealloc];
}

@end
//
//  DMMExterminatorButtonView.m
//  DerivedDataExterminator
//
//  Created by Delisa Mason on 4/13/13.
//  Copyright (c) 2013 Delisa Mason. All rights reserved.
//

#import "DMMExterminatorButtonView.h"

@implementation DMMExterminatorButtonView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width - 20, 20)];
        self.button.autoresizingMask = NSViewWidthSizable;

        [self.button setBezelStyle:NSTexturedRoundedBezelStyle];
		[[self.button cell] setControlSize:NSSmallControlSize];
		[self.button setFont:[NSFont systemFontOfSize:11.0]];
        [self.button setTitle:@"Clear DerivedData"];
		[self addSubview:self.button];
    }
    
    return self;
}

- (BOOL)isOpaque
{
	return NO;
}
@end

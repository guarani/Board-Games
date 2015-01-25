//
//  PVSJSInterface.m
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/25/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

#import "PVSJSInterface.h"
#import "JavaScriptCore/JSContext.h"
#import "JavaScriptCore/JSExport.h"
#import "JavaScriptCore/JSValue.h"


@implementation PVSJSInterface

- (void)start {
    self.context = [[JSContext alloc] init];
    NSLog(self.context);
}

@end

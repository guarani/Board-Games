//
//  PVSJSInterface.h
//  PVSBoardGames
//
//  Created by Paul Von Schrottky on 1/25/15.
//  Copyright (c) 2015 Paul Von Schrottky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JavaScriptCore/JSContext.h"
#import "JavaScriptCore/JSExport.h"
#import "JavaScriptCore/JSValue.h"

@interface PVSJSInterface : NSObject

@property (nonatomic) JSContext* context;

@end

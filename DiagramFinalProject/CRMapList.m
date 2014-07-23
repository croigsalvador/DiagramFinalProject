//
//  CRMapList.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapList.h"

static NSString * const kPlistFileName                  = @"maps.plist";

@implementation CRMapList

- (instancetype)init {
    if (self = [super init]) {
        self.mapList = [NSArray arrayWithContentsOfFile:[self dataFilePath]];
    }
    return self;
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kPlistFileName];
    return path;
}

- (void)addMapToPlist:(NSString *)mapName {
    NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:[self dataFilePath]];
    if (plist == nil){
        plist = [[NSMutableArray alloc] init];
    }
    [plist addObject:mapName];
    [plist writeToFile:[self dataFilePath] atomically:YES];
}


@end

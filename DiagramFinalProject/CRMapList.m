//
//  CRMapList.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRMapList.h"

static NSString * const kPlistFileName                  = @"maps.plist";

@interface CRMapList ()
@property (nonatomic,copy) NSMutableArray *mapMutableList;
@end

@implementation CRMapList

- (instancetype)init {
    if (self = [super init]) {
        self.mapList = [NSArray arrayWithContentsOfFile:[self dataFilePath]];
    }
    return self;
}

#pragma mark - Custom Getter

- (NSArray *)mapList {
    return [NSArray arrayWithContentsOfFile:[self dataFilePath]];;
}

#pragma mark - Private Methods
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kPlistFileName];
    return path;
}


#pragma mark - Public methods
- (void)addMapToPlist:(NSString *)mapName {
    NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:[self dataFilePath]];
    if (plist == nil){
        plist = [[NSMutableArray alloc] init];
    }
    [plist addObject:mapName];
    [plist writeToFile:[self dataFilePath] atomically:YES];
}


@end

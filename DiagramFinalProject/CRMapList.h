//
//  CRMapList.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMapList : NSObject

@property (nonatomic,copy) NSArray *mapList;

- (void)addMapToPlist:(NSString *)mapName;

@end

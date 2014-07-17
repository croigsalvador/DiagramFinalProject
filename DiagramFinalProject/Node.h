//
//  Node.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 17/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Node;

@interface Node : NSManagedObject

@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * shapeType;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSSet *childs;
@property (nonatomic, retain) Node *parent;
@end

@interface Node (CoreDataGeneratedAccessors)

- (void)addChildsObject:(Node *)value;
- (void)removeChildsObject:(Node *)value;
- (void)addChilds:(NSSet *)values;
- (void)removeChilds:(NSSet *)values;

@end

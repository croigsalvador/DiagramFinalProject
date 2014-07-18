//
//  NodeMapTests.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 16/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//


#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import <CoreData/CoreData.h>
#import "CRNodeMap.h"
#import "Node+Model.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>


@interface NodeMapTests : XCTestCase <NSFetchedResultsControllerDelegate> {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    CRNodeMap *sut;
    Node *insertedNode;
    Node *deleteNode;
    NSFetchedResultsController  *_fetchedResultsController;
}





@end


@implementation NodeMapTests

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];
    
    [self createCoreDataStack];
    [self createFixture];
    [self createSut];
}


- (void) createCoreDataStack {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    store = [coordinator addPersistentStoreWithType: NSInMemoryStoreType
                                      configuration: nil
                                                URL: nil
                                            options: nil
                                              error: NULL];
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
    [self setupfetchedResultsController];
    
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)setupfetchedResultsController {
    if (!_fetchedResultsController) {
        
        _fetchedResultsController = [[NSFetchedResultsController  alloc] initWithFetchRequest:[Node fetchAllNodes] managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        
        if (![_fetchedResultsController performFetch:nil]){
            // hanfle error
        }
    }
    return _fetchedResultsController;
}
- (void) createFixture {
    // Test data
}


- (void) createSut {
    sut = [[CRNodeMap alloc] init];
}


- (void) tearDown {
    [self releaseSut];
    [self releaseFixture];
    //    [self releaseCoreDataStack];
    
    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


- (void) releaseFixture {
    
}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}

- (void)testMapListIsNotNil {
    // Prepare
    Node *rootNode = [Node createNodeInManagedObjectContext:context];
    // Operate
    [sut populateMapListForRootNode:rootNode];
    //Check
    XCTAssertNotNil(sut.mapList, @"The mapList Array is nil.");
}

- (void)testMapListHasCorrectLengthAfterSomeNodeInserts {
    //Prepare
    Node *rootNode = [Node createNodeInManagedObjectContext:context];
    for (int i = 0; i < 10; i++) {
        [Node createNodeInManagedObjectContext:context withParent:rootNode];
    }
    //OPERATE
    [sut populateMapListForRootNode:rootNode];
    // Check
    XCTAssert([sut.mapList count] == 11, @"Maplist array is not 11, is:%d", [sut.mapList count]);
}

- (void)testMapListAddChildNode {
    Node *rootNode = [Node createNodeInManagedObjectContext:context];
    [sut populateMapListForRootNode:rootNode];
    
    for (int i = 0; i < 10; i++) {
        Node *childNode = [Node createNodeInManagedObjectContext:context withParent:rootNode];
        [sut addChild:childNode atIndex:1];
    }
    
    
    XCTAssert([sut.mapList count] == 11, @"Maplist array is not 11, is:%d", [sut.mapList count]);
}

- (void)testMapListRemoveChildNode {
    // PREPARE
    Node *rootNode = [Node createNodeInManagedObjectContext:context];
    for (int i = 0; i < 10; i++) {
        [Node createNodeInManagedObjectContext:context withParent:rootNode];
    }
    //OPERATE
    [sut populateMapListForRootNode:rootNode];
    
    for (int i = 10; i > 0 ; i--) {
        [sut removeChildAtIndex:i];
    }
    //Check
    XCTAssert([sut.mapList count] == 1, @"Maplist array is not 11, is:%d", [sut.mapList count]);
}

- (void)testMapListIndexPathForNewNodeIsCorrect {
    // PREPARE
    Node *rootNode = [Node createNodeInManagedObjectContext:context withParent:nil];
    rootNode.title = @"root";
    [Node createNodeInManagedObjectContext:context withParent:nil];
    for (int i = 0; i < 5; i++) {
        [Node createNodeInManagedObjectContext:context withParent:rootNode];
    }
    [Node createNodeInManagedObjectContext:context withParent:nil];
    NSArray *nodes = [Node rootNodeListInContext:context];
    for (Node *node in nodes) {
        [sut populateMapListForRootNode:node];
    }
    
    NSLog(@"Node list %d", [sut.mapList count]);
    
    Node *insertedNodeNew = [Node createNodeInManagedObjectContext:context withParent:rootNode];
    //OPERATE
    NSIndexPath *indexpath = [sut indexPathNewForNode:insertedNodeNew];
    
    
    
    //Check
    XCTAssert(indexpath.row == 8, @"Maplist array is not 8, is:%d", indexpath.row);
}

- (void)testMapListIndexPathForCurrentNode {
    // PREPARE
    Node *rootNode = [Node createNodeInManagedObjectContext:context withParent:nil];
    rootNode.title = @"root";
    [Node createNodeInManagedObjectContext:context withParent:nil];
    for (int i = 0; i < 5; i++) {
        [Node createNodeInManagedObjectContext:context withParent:rootNode];
    }
    [Node createNodeInManagedObjectContext:context withParent:nil];
    
    Node *currentNode = [Node createNodeInManagedObjectContext:context withParent:nil];
   currentNode.title = @"AooZ";
    NSArray *nodes = [Node rootNodeListInContext:context];
    for (Node *node in nodes) {
        [sut populateMapListForRootNode:node];
    }
    
    //OPERATE
    NSIndexPath *indexpath = [sut indexPathForCurrentNode:currentNode];
    
    //Check
    XCTAssert(indexpath.row == 2, @"Maplist array is not 2, is:%d", indexpath.row);
}

- (void)testMapListInsertNodeWithFetchedResultsController {
    // PREPARE
    
    Node *rootNode = [Node createNodeInManagedObjectContext:context];
//    for (int i = 0; i < 10; i++) {
//        [Node createNodeInManagedObjectContext:context withParent:rootNode];
//    }
    //OPERATE
    [sut populateMapListForRootNode:rootNode];
    insertedNode = rootNode;
    
    [self controller:_fetchedResultsController didChangeObject:rootNode atIndexPath:nil forChangeType:1 newIndexPath:nil];
    
    //    [context  deleteObject:rootNode];
    
    //Check
    XCTAssert([sut.mapList count] == 2, @"Maplist array is not 1, is:%d", [sut.mapList count]);
}

- (void)testMapListRemoveNodeWithFetchedResultsController {
    // PREPARE
  
    Node *rootNode = [Node createNodeInManagedObjectContext:context];
    for (int i = 0; i < 10; i++) {
        [Node createNodeInManagedObjectContext:context withParent:rootNode];
    }
    //OPERATE
    [sut populateMapListForRootNode:rootNode];
        deleteNode = rootNode;
    

      [self controller:_fetchedResultsController didChangeObject:rootNode atIndexPath:nil forChangeType:2 newIndexPath:nil];
    
//    [context  deleteObject:rootNode];
    
    //Check
    XCTAssert([sut.mapList count] == 10, @"Maplist array is not 0, is:%d", [sut.mapList count]);
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:{
            NSIndexPath * myIndexPath = [sut indexPathNewForNode:insertedNode];
            [sut addChild:insertedNode atIndex:myIndexPath.row];
            break;
        }
        case NSFetchedResultsChangeDelete:{
            NSIndexPath *delIndexPath = [sut indexPathForCurrentNode:deleteNode];
            [sut removeChildAtIndex:delIndexPath.row];
            break;
        }
        case NSFetchedResultsChangeUpdate:
     
        case NSFetchedResultsChangeMove:
            break;
    }
}

















@end

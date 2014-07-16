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


@interface NodeMapTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    CRNodeMap *sut;
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



















@end

//
//  NodeTests.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 15/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//


#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import "Node+Model.h"


@interface NodeTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    Node *sut;
}

@end


@implementation NodeTests

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
    sut = [Node createNodeInManagedObjectContext:context withParent:nil];
}


- (void) tearDown {
    [self releaseSut];
//    [self releaseFixture];
//    [self releaseCoreDataStack];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}
#pragma mark - Basic test

- (void) testObjectIsNotNil {
    // Prepare
    
    // Operate

    // Check
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}

- (void)testChildHasAParent {
    Node *altSut = [Node createNodeInManagedObjectContext:context withParent:sut];
    
    XCTAssertEqualObjects(altSut.parent, sut, @"These objects are not equals");
}

@end

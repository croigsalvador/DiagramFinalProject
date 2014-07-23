//
//  CRAppDelegateTests.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 15/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CRAppDelegate.h"
#import "CRNodeListViewController.h"
#import "CRNodeMap.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface CRAppDelegateTests : XCTestCase

@property (strong,nonatomic) CRAppDelegate *sut;

@end

@implementation CRAppDelegateTests

- (void)setUp {
    [super setUp];
    self.sut = [[CRAppDelegate alloc] init];
}

- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

- (void)testSUTIsNotNil {
    XCTAssertNotNil(self.sut, @"SUT IS NIL");
}

- (void)testNodeListViewControllerGetsManagedDocument {
    UIWindow *windowMock = mock([UIWindow class]);
    self.sut.window = windowMock;
    
    UINavigationController *navMock = mock([UINavigationController class]);
    [given([windowMock rootViewController]) willReturn:navMock];
    
    CRNodeListViewController *mockNodeList = mock([CRNodeListViewController class]);
    [given([navMock topViewController]) willReturn:mockNodeList];
   
    [self.sut application:nil didFinishLaunchingWithOptions:nil];
    [verify(mockNodeList) setManagedDocument:notNilValue()];
}
- (void)testNodeListViewControllerGetsNodeMap {
    UIWindow *windowMock = mock([UIWindow class]);
    self.sut.window = windowMock;
    
    UINavigationController *navMock = mock([UINavigationController class]);
    [given([windowMock rootViewController]) willReturn:navMock];
    
    CRNodeListViewController *mockNodeList = mock([CRNodeListViewController class]);
    [given([navMock topViewController]) willReturn:mockNodeList];
   
    [self.sut application:nil didFinishLaunchingWithOptions:nil];
    [verify(mockNodeList) setNodeMap:notNilValue()];
}


      
      
      
      
      
      
      
      
      
      
      
      
      
      
      


@end

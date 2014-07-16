//
//  CRAppDelegate.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 14/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRAppDelegate.h"
#import "CRNodeListViewController.h"
#import "CRNodeMap.h"
#import "Node+Model.h"


@implementation CRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupDependencyInjection];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Setup ViewController Dependencies

- (void)setupDependencyInjection {
    UIManagedDocument *managedDocument = [self setupManagedDocument];
    CRNodeMap *nodeMap = [[CRNodeMap alloc] init];
    
    UINavigationController *navViewController =(UINavigationController *)self.window.rootViewController;
    CRNodeListViewController *nodeListViewController =(CRNodeListViewController *) [navViewController topViewController];
    nodeListViewController.managedDocument = managedDocument;
    nodeListViewController.nodeMap = nodeMap;
    //   nodeListViewController.rootNode = [self rootNodeInManagedContext:managedDocument.managedObjectContext];
    
}

- (Node *)rootNodeInManagedContext:(NSManagedObjectContext *)managedObjectContext {
    [managedObjectContext.undoManager beginUndoGrouping];
    Node *rootNode = [Node rootNodeInContext:managedObjectContext];
    if (!rootNode) {
        rootNode = [Node createNodeInManagedObjectContext:managedObjectContext];
        rootNode.title = @"Map name";
    }
    [managedObjectContext.undoManager setActionName:@"Bad Action"];
    [managedObjectContext.undoManager endUndoGrouping];
    return rootNode;
}

- (NSDictionary *)rootDictionaryInManagedObjectContext:(NSManagedObjectContext *)contex {
    return @{@"node": [self rootNodeInManagedContext:contex]};
}

#pragma mark - Initialize UIManagedDocument

- (UIManagedDocument *)setupManagedDocument {
    NSURL *fileURL =[self urlForUIManagedDocument];
    
    UIManagedDocument *managedDocument = [[UIManagedDocument alloc] initWithFileURL:fileURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
        [managedDocument openWithCompletionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"No se pudo abrir aq%@", managedDocument);
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"nodeNotification" object:self userInfo:[self rootDictionaryInManagedObjectContext:managedDocument.managedObjectContext ]];
            }
        }];
    } else {
        [managedDocument saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"nodeNotification" object:self userInfo:[self rootDictionaryInManagedObjectContext:managedDocument.managedObjectContext ]];
            }
            NSLog(@"No se pudo abrir %@", managedDocument);
        }];
    }
    return managedDocument;
}

#pragma mark - Document Path

- (NSURL *)urlForUIManagedDocument{
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [paths lastObject];
    NSURL *fileURL = [documentsURL URLByAppendingPathComponent:@"map.sqlite"];
    return fileURL;
}





@end

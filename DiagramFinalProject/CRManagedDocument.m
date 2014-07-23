//
//  CRManagedDocument.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 23/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRManagedDocument.h"
#import <CoreData/CoreData.h>

@implementation CRManagedDocument

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSLog(@"Auto-Saving Document");
    return [super contentsForType:typeName error:outError];
}

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted
{
    NSLog(@"UIManagedDocument error: %@", error.localizedDescription);
    NSArray* errors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if(errors != nil && errors.count > 0) {
        for (NSError *error in errors) {
            NSLog(@"  Error: %@", error.userInfo);
        }
    } else {
        NSLog(@"  %@", error.userInfo);
    }
}

@end

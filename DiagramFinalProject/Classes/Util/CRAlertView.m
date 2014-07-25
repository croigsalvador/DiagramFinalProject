//
//  CRAlertView.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "CRAlertView.h"

@implementation CRAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]){
        
    }
    return self;
}


@end

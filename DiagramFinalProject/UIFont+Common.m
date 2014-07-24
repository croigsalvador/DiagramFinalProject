//
//  UIFont+Common.m
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 18/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import "UIFont+Common.h"

@implementation UIFont (Common)


+ (UIFont *)amaticMediumBold {
    UIFont *font =[UIFont fontWithName:@"Amatic-Bold" size:15] ;
    return font;
}

+ (UIFont *)amaticMedium {
    UIFont *font =[UIFont fontWithName:@"AmaticSC-Regular" size:15] ;
    return font;
}

+ (UIFont *)montserratRegular {
    UIFont *font =[UIFont fontWithName:@"Montserrat-Regular" size:15] ;
    return font;
}

+ (UIFont *)montserratRegularBig {
    UIFont *font =[UIFont fontWithName:@"Montserrat-Regular" size:20] ;
    return font;
}

+ (UIFont *)montSerratBoldForCollectionCell {
    UIFont *font =[UIFont fontWithName:@"Montserrat-Bold" size:25] ;
    return font;
}

+ (UIFont *)montSerratBoldForCollectionTitle {
    UIFont *font =[UIFont fontWithName:@"Montserrat-Bold" size:45] ;
    return font;
}


@end

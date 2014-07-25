//
//  CRAddNodeView.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 24/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNodeDelegate;

@interface CRAddNodeView : UIView

@property (weak,nonatomic) id<AddNodeDelegate> delegate;
@property (nonatomic,copy) NSString *textFieldText;
@end

@protocol AddNodeDelegate <NSObject>

- (void)buttonPressedInView:(CRAddNodeView *)documentNameView withTag:(NSUInteger)tag andText:(NSString *)name;

@end

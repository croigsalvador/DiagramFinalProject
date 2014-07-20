//
//  CRDocumentNameView.h
//  DiagramFinalProject
//
//  Created by Carlos Roig Salvador on 20/07/14.
//  Copyright (c) 2014 CRoigSalvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DocumentNameViewDelegate;

@interface CRDocumentNameView : UIView

@property (weak,nonatomic) id<DocumentNameViewDelegate> delegate;

@end

@protocol DocumentNameViewDelegate <NSObject>

- (void)buttonPressedInDocument:(CRDocumentNameView *)documentNameView withTag:(NSUInteger)tag andText:(NSString *)name;

@end

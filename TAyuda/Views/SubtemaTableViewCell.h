//
//  SubtemaTableViewCell.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/23/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subtema.h"
#import "Tramite.h"

@interface SubtemaTableViewCell : UITableViewCell

- (void)setUpWithSubtema:(Subtema *)subtema;

- (void)setUpWithTramite:(Tramite *)tramite;

+ (CGFloat)heightOfSubtema:(Subtema *)subtema withWidth:(CGFloat)width;

+ (CGFloat)heightOfTramite:(Tramite *)tramite withWidth:(CGFloat)width;

@end

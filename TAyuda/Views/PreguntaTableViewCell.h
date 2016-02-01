//
//  PreguntaTableViewCell.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/24/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pregunta.h"
#import "NSAttributedString+MGTrim.h"

@interface PreguntaTableViewCell : UITableViewCell

@property (strong, nonatomic) UIColor *buttonColor;

- (void)setUpWithPregunta:(Pregunta *)pregunta;

+ (id)preload;

+ (CGFloat)heightOfPregunta:(Pregunta *)pregunta withWidth:(CGFloat)width;

@end

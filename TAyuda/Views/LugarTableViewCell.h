//
//  LugarTableViewCell.h
//  TAyuda
//
//  Created by Santiago Castillo on 1/31/16.
//  Copyright © 2016 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lugar.h"

@interface LugarTableViewCell : UITableViewCell

- (void)setUpWithLugar:(Lugar *)lugar;

+ (CGFloat)heightOfCell;

@end

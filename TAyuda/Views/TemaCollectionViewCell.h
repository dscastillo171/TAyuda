//
//  CollectionViewCell.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/21/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaHandler.h"
#import "Tema.h"

@interface TemaCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSInteger position;

- (void)setUpWithTema:(Tema *)tema;

@end

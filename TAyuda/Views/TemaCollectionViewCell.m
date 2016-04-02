//
//  CollectionViewCell.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/21/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "TemaCollectionViewCell.h"

@interface TemaCollectionViewCell()

@property (weak, nonatomic) UILabel *nameView;

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation TemaCollectionViewCell

- (id)init{
    self = [super init];
    if(self){
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUp];
    }
    return self;
}

- (void)setUp{
    UILabel *name = [UILabel new];
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    name.font = [UIFont fontWithName:@"FrutigerLTStd-Bold" size:[name.font pointSize]];
    name.numberOfLines = 2;
    name.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:name];
    self.nameView = name;
    
    UIImageView *image = [UIImageView new];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.backgroundColor = [UIColor clearColor];
    [self.contentView insertSubview:image belowSubview:name];
    self.imageView = image;
}

- (void)prepareForReuse{
    self.nameView.text = nil;
    self.imageView.image = nil;
}

- (void)drawRect:(CGRect)rect{
    CGFloat padding = 6.0;
    
    self.contentView.backgroundColor = [MediaHandler colorForPosition:self.position];
    
    [self.nameView sizeToFit];
    CGRect nameRect = self.nameView.frame;
    if(self.nameView.frame.size.width > rect.size.width){
        CGSize size = [self.nameView sizeThatFits:CGSizeMake(rect.size.width, rect.size.height)];
        nameRect.size = size;
    }
    CGPoint nameOrigin = CGPointMake((rect.size.width - nameRect.size.width) / 2.0, rect.size.height - nameRect.size.height - padding);
    nameRect.origin = nameOrigin;
    self.nameView.frame = nameRect;
    
    CGFloat imageSize = nameRect.origin.y - (2 * padding);
    self.imageView.frame = CGRectMake((rect.size.width - imageSize) / 2.0, padding, imageSize, imageSize);
}

- (void)setUpWithTema:(Tema *)tema{
    self.nameView.text = tema.nombre;
    if(tema.imagen){
        [MediaHandler imageFromRealtivePath:tema.imagen completion:^(UIImage *image) {
            if(image && [self.nameView.text isEqualToString:tema.nombre]){
                self.imageView.image = image;
            }
        }];
    } else{
        UIImage *image = [TemaCollectionViewCell defaultImageForTema:tema];
        self.imageView.image = image;
    }
    
}

+ (UIImage *)defaultImageForTema: (Tema *)tema{
    UIImage *image;
    if([tema.nombre isEqualToString:@"TU CONSUMIDOR"]){
        image = [UIImage imageNamed:@"IconoConsumidor.png"];
    } else if([tema.nombre isEqualToString:@"TU FAMILIA"]){
        image = [UIImage imageNamed:@"IconoFamilia.png"];
    } else if([tema.nombre isEqualToString:@"TU NEGOCIO"]){
        image = [UIImage imageNamed:@"IconoNegocio.png"];
    } else if([tema.nombre isEqualToString:@"TU SALUD"]){
        image = [UIImage imageNamed:@"IconoSalud.png"];
    } else if([tema.nombre isEqualToString:@"TU TRABAJO"]){
        image = [UIImage imageNamed:@"IconoTrabajo.png"];
    } else if([tema.nombre isEqualToString:@"TU TRAMITE"]){
        image = [UIImage imageNamed:@"IconoTramites.png"];
    } else if([tema.nombre isEqualToString:@"TU VIVIENDA"]){
        image = [UIImage imageNamed:@"IconoVivienda.png"];
    } else if([tema.nombre isEqualToString:@"TUS IMPUESTOS"]){
        image = [UIImage imageNamed:@"IconoImpuestos.png"];
    } else if([tema.nombre isEqualToString:@"TUS TEMAS DE INTERES"]){
        image = [UIImage imageNamed:@"IconoServicios.png"];
    } else if([tema.nombre isEqualToString:@"TU CONSULTA"]){
        image = [UIImage imageNamed:@"IconoConsulta.png"];
    }
    return image;
}

@end

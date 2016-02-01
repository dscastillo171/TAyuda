//
//  LugarTableViewCell.m
//  TAyuda
//
//  Created by Santiago Castillo on 1/31/16.
//  Copyright © 2016 tayuda. All rights reserved.
//

#import "LugarTableViewCell.h"

#define LINE_HEIGHT 20.0

@interface LugarTableViewCell()

@property (weak, nonatomic) UILabel *cityView;

@property (weak, nonatomic) UILabel *nameView;

@property (weak, nonatomic) UILabel *addressView;

@end

@implementation LugarTableViewCell

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
    UILabel *city = [UILabel new];
    city.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
    city.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:18.0];
    city.numberOfLines = 1;
    [self.contentView addSubview:city];
    self.cityView = city;
    
    UILabel *name = [UILabel new];
    name.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
    name.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:18.0];
    name.numberOfLines = 1;
    [self.contentView addSubview:name];
    self.nameView = name;
    
    UILabel *address = [UILabel new];
    address.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
    address.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:18.0];
    address.numberOfLines = 1;
    [self.contentView addSubview:address];
    self.addressView = address;
}

- (void)prepareForReuse{
    self.nameView.text = nil;
    self.imageView.image = nil;
}

- (void)drawRect:(CGRect)rect{
    self.cityView.frame = CGRectMake(15, 5.0, rect.size.width - 15, LINE_HEIGHT);
    self.nameView.frame = CGRectMake(15, LINE_HEIGHT + 5.0, rect.size.width - 15, LINE_HEIGHT);
    self.addressView.frame = CGRectMake(15, (LINE_HEIGHT * 2) + 5.0, rect.size.width - 15, LINE_HEIGHT);
}

- (void)setUpWithLugar:(Lugar *)lugar{
    self.cityView.text = [lugar.ciudad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.nameView.text = [lugar.nombre stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.addressView.text = [lugar.direccion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (CGFloat)heightOfCell{
    return (LINE_HEIGHT * 3) + 10;
}

@end

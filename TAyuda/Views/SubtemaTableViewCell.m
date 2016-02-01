//
//  SubtemaTableViewCell.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/23/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "SubtemaTableViewCell.h"

#define HORIZONTAL_PADDING 6.0
#define VERTICAL_PADDING 12.0

@interface SubtemaTableViewCell()

@property (weak, nonatomic) UILabel *nameView;

@property (weak, nonatomic) UIView *bottomBorder;

@end

@implementation SubtemaTableViewCell

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
    self.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    
    UILabel *name = [UILabel new];
    name.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
    name.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    name.font = [UIFont fontWithName:@"FrutigerLTStd-Light" size:[name.font pointSize]];
    name.numberOfLines = 2;
    name.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:name];
    self.nameView = name;
    
    UIView *border = [UIView new];
    border.backgroundColor = [UIColor colorWithWhite:224/255.0 alpha:1.0];
    [self.contentView addSubview:border];
    self.bottomBorder = border;
}

- (void)prepareForReuse{
    self.nameView.text = nil;
}

- (void)drawRect:(CGRect)rect{
    CGFloat textWidth = rect.size.width - (HORIZONTAL_PADDING * 2);
    CGFloat textHeight = [SubtemaTableViewCell heightOfText:self.nameView.text withWidth:textWidth];
    CGRect nameRect = CGRectMake((rect.size.width - textWidth) / 2.0, (rect.size.height - textHeight) / 2.0, textWidth, textHeight);
    self.nameView.frame = nameRect;
    
    self.bottomBorder.frame = CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5);
}

- (void)setUpWithSubtema:(Subtema *)subtema{
    self.nameView.text = subtema.nombre;
}

- (void)setUpWithTramite:(Tramite *)tramite{
    self.nameView.text = tramite.nombre;
}

+ (CGFloat)heightOfText:(NSString *)text withWidth:(CGFloat)width{
    static NSDictionary *defaultAttributes;
    if(!defaultAttributes){
        UIFont *systemFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        defaultAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FrutigerLTStd-Light" size:[systemFont pointSize]], NSFontAttributeName, nil];
    }
    
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:defaultAttributes context:nil];
    return CGRectIntegral(textRect).size.height;
}

+ (CGFloat)heightOfSubtema:(Subtema *)subtema withWidth:(CGFloat)width{
    NSString *text = subtema.nombre? [subtema.nombre stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]: @"";
    CGFloat textWidth = width - (HORIZONTAL_PADDING * 2);
    CGFloat textHeight = [SubtemaTableViewCell heightOfText:text withWidth:textWidth];
    return textHeight + (VERTICAL_PADDING * 2);
}

+ (CGFloat)heightOfTramite:(Tramite *)tramite withWidth:(CGFloat)width{
    NSString *text = tramite.nombre? [tramite.nombre stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]: @"";
    CGFloat textWidth = width - (HORIZONTAL_PADDING * 2);
    CGFloat textHeight = [SubtemaTableViewCell heightOfText:text withWidth:textWidth];
    return textHeight + (VERTICAL_PADDING * 2);
}

@end

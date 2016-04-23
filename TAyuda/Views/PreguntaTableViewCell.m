//
//  PreguntaTableViewCell.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/24/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "PreguntaTableViewCell.h"

#define EXTRA_INSET 40.0

#define HORIZONTAL_PADDING 6.0

@interface PreguntaTableViewCell()

@property (strong, nonatomic) UITextView *respuestaView;

@property (strong, nonatomic) UIView *buttonsHolder;

@property (strong, nonatomic) UIButton *linkButton;

@property (strong, nonatomic) UIButton *tramiteButton;

@property (nonatomic) BOOL showButtons;

@end

@implementation PreguntaTableViewCell

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
    UITextView *respuestaView = [[UITextView alloc] init];
    respuestaView.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
    respuestaView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    respuestaView.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[respuestaView.font pointSize]];
    respuestaView.textAlignment = NSTextAlignmentJustified;
    respuestaView.editable = NO;
    respuestaView.textContainer.lineFragmentPadding = 0;
    respuestaView.textContainerInset = UIEdgeInsetsMake(12, HORIZONTAL_PADDING, 6, HORIZONTAL_PADDING * 2);
    respuestaView.layoutManager.allowsNonContiguousLayout = NO;
    [self.contentView addSubview:respuestaView];
    self.respuestaView = respuestaView;
    
    UIView *buttonsHolder = [UIView new];
    buttonsHolder.clipsToBounds = YES;
    [self.respuestaView addSubview:buttonsHolder];
    self.buttonsHolder = buttonsHolder;
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [linkButton setTitle:@"Enlace externo" forState:UIControlStateNormal];
    linkButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    linkButton.titleLabel.font = [UIFont fontWithName:@"FrutigerLTStd-Bold" size:[linkButton.titleLabel.font pointSize]];
    [linkButton sizeToFit];
    [self.buttonsHolder addSubview:linkButton];
    self.linkButton = linkButton;
    
    UIButton *tramiteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tramiteButton setTitle:@"Trámite asociado" forState:UIControlStateNormal];
    tramiteButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    tramiteButton.titleLabel.font = [UIFont fontWithName:@"FrutigerLTStd-Bold" size:[tramiteButton.titleLabel.font pointSize]];
    [tramiteButton sizeToFit];
    [self.buttonsHolder addSubview:tramiteButton];
    self.tramiteButton = tramiteButton;
    
    self.showButtons = NO;
    self.linkButton.hidden = YES;
    self.tramiteButton.hidden = YES;
}

- (void)prepareForReuse{
    self.respuestaView.text = nil;
    self.respuestaView.frame = CGRectZero;
    self.showButtons = NO;
    self.linkButton.hidden = YES;
    self.tramiteButton.hidden = YES;
}

- (void)drawRect:(CGRect)rect{
    self.respuestaView.frame = CGRectMake(6, 0, rect.size.width - 12, rect.size.height);
    self.respuestaView.contentInset = UIEdgeInsetsMake(0, 0, self.showButtons? EXTRA_INSET: 0, 0);
    self.respuestaView.contentOffset = CGPointMake(0, 0);
    
    if(self.showButtons){
        self.buttonsHolder.frame = CGRectMake(HORIZONTAL_PADDING, self.respuestaView.contentSize.height, rect.size.width, EXTRA_INSET);
        CGRect linkButtonRect = self.linkButton.frame;
        linkButtonRect.origin = CGPointMake(0, (EXTRA_INSET - linkButtonRect.size.height) / 2.0);
        self.linkButton.frame = linkButtonRect;
        [self.linkButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
        
        CGRect tramiteButtonRect = self.tramiteButton.frame;
        tramiteButtonRect.origin = CGPointMake(self.buttonsHolder.frame.size.width - tramiteButtonRect.size.width - (3 * HORIZONTAL_PADDING), (EXTRA_INSET - tramiteButtonRect.size.height) / 2.0);
        self.tramiteButton.frame = tramiteButtonRect;
        [self.tramiteButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
    } else{
        self.buttonsHolder.frame = CGRectZero;
    }
}

- (void)setUpWithPregunta:(Pregunta *)pregunta{
    NSString *text = pregunta.respuesta? pregunta.respuesta: @"";
    NSMutableAttributedString *richText = [[[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
    [richText addAttribute:NSFontAttributeName value:self.respuestaView.font range:NSMakeRange(0, [richText length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    paragraphStyle.lineSpacing = 6;
    [richText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [richText length])];
    
    self.respuestaView.attributedText = [richText attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.respuestaView sizeToFit];
    if((pregunta.enlaceExterno && [pregunta.enlaceExterno length] > 0) || pregunta.tramite){
        self.showButtons = YES;
        if(pregunta.enlaceExterno && [pregunta.enlaceExterno length] > 0){
            self.linkButton.hidden = NO;
        }
        if(pregunta.tramite){
            self.tramiteButton.hidden = NO;
        }
    }
}

+ (CGFloat)heightOfText:(NSString *)text withWidth:(CGFloat)width{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[font pointSize]];
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableAttributedString *richText = [[[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
    [richText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [richText length])];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    paragraphStyle.lineSpacing = 6;
    [richText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [richText length])];
    CGRect textRect = [[richText attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGRectIntegral(textRect).size.height;
}

+ (CGFloat)heightOfPregunta:(Pregunta *)pregunta withWidth:(CGFloat)width{
    NSString *text = pregunta.respuesta? pregunta.respuesta: @"";
    CGFloat height = [PreguntaTableViewCell heightOfText:text withWidth:width - (HORIZONTAL_PADDING * 3)];
    height = height + 40 + ((pregunta.enlaceExterno  && [pregunta.enlaceExterno length] > 0) || pregunta.tramite? EXTRA_INSET: 0);
    return height > 300? 300: height;
}

+ (id)preload{
    [PreguntaTableViewCell heightOfText:@"<p>Preload the<br /><b>HTML</b><br />parser</p>" withWidth:300];
    UITextView *respuestaView = [[UITextView alloc] init];
    return respuestaView;
}

@end

//
//  TramiteViewController.m
//  TAyuda
//
//  Created by Santiago Castillo on 12/15/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "TramiteViewController.h"

#define HORIZONTAL_PADDING 6.0
#define VERTICAL_PADDING 12.0

@interface TramiteViewController ()

@property (weak, nonatomic) TAyuda *tAyuda;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation TramiteViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        revealController.rightViewRevealWidth = 240;
        [self.menuButton setTarget:revealController];
        [self.menuButton setAction:@selector(rightRevealToggle:)];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setHeader];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        [self.tableView addGestureRecognizer:revealController.panGestureRecognizer];
        [self.tableView addGestureRecognizer:revealController.tapGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        [self.tableView removeGestureRecognizer:revealController.panGestureRecognizer];
        [self.tableView removeGestureRecognizer:revealController.tapGestureRecognizer];
    }
}

- (TAyuda *)tAyuda{
    if(!_tAyuda){
        _tAyuda = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tAyuda];
    }
    return _tAyuda;
}

- (void)setTramite:(Tramite *)tramite{
    _tramite = tramite;
    [self.tAyuda updateTramiteInfo:self.tramite completionBlock:^(BOOL completed) {
        if(completed){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[_tramite managedObjectContext] refreshObject:_tramite mergeChanges:NO];
                [self setHeader];
            });
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"LugaresSegue"]){
        LugaresTableViewController *controller = [segue destinationViewController];
        controller.tramite = self.tramite;
        controller.color = self.color;
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
    }
}

- (IBAction)openSearch:(id)sender {
    UINavigationController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    [searchController setNavigationBarHidden:YES];
    [self presentViewController:searchController animated:YES completion:nil];
}

- (void)setHeader{
    CGFloat viewWidth = self.view.bounds.size.width;
    UIView *headerView = [[UIView alloc] init];
    
    UILabel *tittleLabel = [[UILabel alloc] init];
    tittleLabel.numberOfLines = 0;
    tittleLabel.text = self.tramite.nombre;
    tittleLabel.textColor = [UIColor whiteColor];
    tittleLabel.backgroundColor = self.color;
    tittleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    tittleLabel.font = [UIFont fontWithName:@"FrutigerLTStd-Bold" size:[tittleLabel.font pointSize]];
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize tittleSize = [tittleLabel sizeThatFits:CGSizeMake(viewWidth - 30.0, CGFLOAT_MAX)];
    tittleLabel.frame = CGRectMake(0, 0, viewWidth, tittleSize.height + 30);
    [headerView addSubview:tittleLabel];
    
    UIView *lastView = tittleLabel;
    if([self.tramite.texto length] > 0){
        UILabel *descriptionTittle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, lastView.frame.origin.y + lastView.frame.size.height + 10.0, viewWidth - 30.0, 20)];
        descriptionTittle.numberOfLines = 1;
        descriptionTittle.text = @"Descripción";
        descriptionTittle.textColor = self.color;
        descriptionTittle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        descriptionTittle.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[descriptionTittle.font pointSize]];
        
        UITextView *descripction = [[UITextView alloc] init];
        descripction.scrollEnabled = NO;
        descripction.editable = NO;
        descripction.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
        descripction.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        descripction.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[descripction.font pointSize]];
        NSMutableAttributedString *richText = [[[NSAttributedString alloc] initWithData:[self.tramite.texto dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
        [richText addAttribute:NSFontAttributeName value:descripction.font range:NSMakeRange(0, [richText length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        [richText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [richText length])];
        descripction.attributedText = [richText attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        descripction.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
        CGSize descriptionSize = [descripction sizeThatFits:CGSizeMake(viewWidth - 30.0, CGFLOAT_MAX)];
        descripction.frame = CGRectMake(20.0, descriptionTittle.frame.origin.y + descriptionTittle.frame.size.height + 5.0, viewWidth - 35.0, descriptionSize.height);
        
        [headerView addSubview:descriptionTittle];
        [headerView addSubview:descripction];
        
        lastView = descripction;
    }
    
    if([self.tramite.linea length] > 0){
        UILabel *lineaTittle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, lastView.frame.origin.y + lastView.frame.size.height + 10.0, viewWidth - 30.0, 20)];
        lineaTittle.numberOfLines = 1;
        lineaTittle.text = @"¿Es en linea?";
        lineaTittle.textColor = self.color;
        lineaTittle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        lineaTittle.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[lineaTittle.font pointSize]];
        
        UITextView *linea = [[UITextView alloc] init];
        linea.scrollEnabled = NO;
        linea.editable = NO;
        linea.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
        linea.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        linea.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[linea.font pointSize]];
        NSMutableAttributedString *richText = [[[NSAttributedString alloc] initWithData:[self.tramite.linea dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
        [richText addAttribute:NSFontAttributeName value:linea.font range:NSMakeRange(0, [richText length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        [richText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [richText length])];
        linea.attributedText = [richText attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        linea.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
        CGSize lineaSize = [linea sizeThatFits:CGSizeMake(viewWidth - 30.0, CGFLOAT_MAX)];
        linea.frame = CGRectMake(20.0, lineaTittle.frame.origin.y + lineaTittle.frame.size.height + 5.0, viewWidth - 35.0, lineaSize.height);
        
        [headerView addSubview:lineaTittle];
        [headerView addSubview:linea];
        
        lastView = linea;
    }
    
    if([self.tramite.gratuito length] > 0){
        UILabel *gratuitoTittle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, lastView.frame.origin.y + lastView.frame.size.height + 10.0, viewWidth - 30.0, 20)];
        gratuitoTittle.numberOfLines = 1;
        gratuitoTittle.text = @"¿Es gratuito?";
        gratuitoTittle.textColor = self.color;
        gratuitoTittle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        gratuitoTittle.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[gratuitoTittle.font pointSize]];
        
        UITextView *gratuito = [[UITextView alloc] init];
        gratuito.scrollEnabled = NO;
        gratuito.editable = NO;
        gratuito.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
        gratuito.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        gratuito.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[gratuito.font pointSize]];
        NSMutableAttributedString *richText = [[[NSAttributedString alloc] initWithData:[self.tramite.gratuito dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
        [richText addAttribute:NSFontAttributeName value:gratuito.font range:NSMakeRange(0, [richText length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        [richText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [richText length])];
        gratuito.attributedText = [richText attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        gratuito.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
        CGSize gratuitoSize = [gratuito sizeThatFits:CGSizeMake(viewWidth - 30.0, CGFLOAT_MAX)];
        gratuito.frame = CGRectMake(20.0, gratuitoTittle.frame.origin.y + gratuitoTittle.frame.size.height + 5.0, viewWidth - 35.0, gratuitoSize.height);
        
        [headerView addSubview:gratuitoTittle];
        [headerView addSubview:gratuito];
        
        lastView = gratuito;
    }
    
    if([self.tramite.documentos length] > 0){
        UILabel *documentosTittle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, lastView.frame.origin.y + lastView.frame.size.height + 10.0, viewWidth - 30.0, 20)];
        documentosTittle.numberOfLines = 1;
        documentosTittle.text = @"Documentos y requisitos";
        documentosTittle.textColor = self.color;
        documentosTittle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        documentosTittle.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[documentosTittle.font pointSize]];
        
        UITextView *documentos = [[UITextView alloc] init];
        documentos.scrollEnabled = NO;
        documentos.editable = NO;
        documentos.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
        documentos.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        documentos.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[documentos.font pointSize]];
        NSMutableAttributedString *richText = [[[NSAttributedString alloc] initWithData:[self.tramite.documentos dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
        [richText addAttribute:NSFontAttributeName value:documentos.font range:NSMakeRange(0, [richText length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        [richText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [richText length])];
        documentos.attributedText = [richText attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        documentos.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
        CGSize documentosSize = [documentos sizeThatFits:CGSizeMake(viewWidth - 30.0, CGFLOAT_MAX)];
        documentos.frame = CGRectMake(20.0, documentosTittle.frame.origin.y + documentosTittle.frame.size.height + 5.0, viewWidth - 35.0, documentosSize.height);
        
        [headerView addSubview:documentosTittle];
        [headerView addSubview:documentos];
        
        lastView = documentos;
    }
    
    if([self.tramite.direccion length] > 0){
        UILabel *direccionTittle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, lastView.frame.origin.y + lastView.frame.size.height + 10.0, viewWidth - 30.0, 20)];
        direccionTittle.numberOfLines = 1;
        direccionTittle.text = @"¿A donde ir?";
        direccionTittle.textColor = self.color;
        direccionTittle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        direccionTittle.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[direccionTittle.font pointSize]];
        
        UITextView *direccion = [[UITextView alloc] init];
        direccion.scrollEnabled = NO;
        direccion.editable = NO;
        direccion.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
        direccion.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        direccion.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[direccion.font pointSize]];
        NSMutableAttributedString *richText = [[[NSAttributedString alloc] initWithData:[self.tramite.direccion dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil] mutableCopy];
        [richText addAttribute:NSFontAttributeName value:direccion.font range:NSMakeRange(0, [richText length])];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        [richText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [richText length])];
        direccion.attributedText = [richText attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        direccion.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
        CGSize direccionSize = [direccion sizeThatFits:CGSizeMake(viewWidth - 30.0, CGFLOAT_MAX)];
        direccion.frame = CGRectMake(20.0, direccionTittle.frame.origin.y + direccionTittle.frame.size.height + 5.0, viewWidth - 35.0, direccionSize.height);
        
        // Check if the message has links.
        NSError *error = nil;
        NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        NSUInteger matches = [dataDetector numberOfMatchesInString:self.tramite.direccion options:0 range:NSMakeRange(0, [self.tramite.direccion length])];
        if(matches > 0){
            [headerView addSubview:direccionTittle];
            [headerView addSubview:direccion];
            
            lastView = direccion;
        } else{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:@"¿A donde ir?" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = self.color;
            [button sizeToFit];
            button.frame = CGRectMake((viewWidth - button.frame.size.width - 50.0) / 2.0, direccion.frame.origin.y + direccion.frame.size.height + 10.0, button.frame.size.width + 50.0, button.frame.size.height);
            [button addTarget:self action:@selector(openLugares) forControlEvents:UIControlEventTouchUpInside];
            
            [headerView addSubview:direccionTittle];
            [headerView addSubview:direccion];
            [headerView addSubview: button];
            
            lastView = button;
        }
    }
    
    if(lastView == tittleLabel){
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect loadingFrame = loading.frame;
        loadingFrame.origin = CGPointMake((viewWidth - loadingFrame.size.width) / 2.0, (self.view.bounds.size.height - (lastView.frame.origin.y + lastView.frame.size.height) - loadingFrame.size.height) / 2.0);
        loading.frame = loadingFrame;
        [loading startAnimating];
        
        [headerView addSubview:loading];
        
        lastView = loading;
    }
    
    headerView.frame = CGRectMake(0, 0, viewWidth, lastView.frame.origin.y + lastView.frame.size.height + 25.0);
    
    if([self.tramite.texto length] > 0){
        UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3.0, headerView.frame.size.height)];
        leftBorder.backgroundColor = self.color;
        [headerView addSubview:leftBorder];
        
        UIView *rightBorder = [[UIView alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 3.0, 0, 3.0, headerView.frame.size.height)];
        rightBorder.backgroundColor = self.color;
        [headerView addSubview:rightBorder];
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 3.0, headerView.frame.size.width, 3.0)];
        bottomBorder.backgroundColor = self.color;
        [headerView addSubview:bottomBorder];
    }
    
    self.tableView.tableHeaderView = headerView;
}

- (void)openLugares{
    [self performSegueWithIdentifier:@"LugaresSegue" sender:nil];
}

@end

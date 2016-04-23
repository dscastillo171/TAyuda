//
//  ConsultaViewController.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/25/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "ConsultaViewController.h"

#define HORIZONTAL_PADDING 6.0
#define VERTICAL_PADDING 12.0

@interface ConsultaViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (weak, nonatomic) UITextView *consulta;

@property (weak, nonatomic) UITextField *email;

@end

@implementation ConsultaViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        revealController.rightViewRevealWidth = 240;
        [self.menuButton setTarget:revealController];
        [self.menuButton setAction:@selector(rightRevealToggle:)];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
        [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        [self.view removeGestureRecognizer:revealController.panGestureRecognizer];
        [self.view removeGestureRecognizer:revealController.tapGestureRecognizer];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    [self.view addSubview: scrollView];
    self.scrollView = scrollView;
    
    CGSize viewSize = CGSizeMake(self.view.bounds.size.width, 60.0);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    headerView.backgroundColor = [MediaHandler colorForPosition:99];
    [scrollView addSubview:headerView];
    
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"TU CONSULTA";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    textLabel.font = [UIFont fontWithName:@"FrutigerLTStd-Bold" size:[textLabel.font pointSize]];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [textLabel sizeToFit];
    [headerView addSubview:textLabel];
    
    CGFloat imageSize = 48.0;
    CGFloat spacing = 12.0;
    CGRect textRect = textLabel.frame;
    CGFloat width = textRect.size.width + imageSize + spacing;
    textRect.origin = CGPointMake(((viewSize.width - width) / 2.0) + imageSize + spacing, (viewSize.height - textRect.size.height) / 2.0);
    textLabel.frame = textRect;
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [MediaHandler processSingleImage:[UIImage imageNamed:@"IconoConsulta.png"] maxSize:50.0];
    imageView.frame = CGRectMake((viewSize.width - width) / 2.0, (viewSize.height - imageSize) / 2.0, imageSize, imageSize);
    [headerView addSubview:imageView];
    
    CGFloat viewPadding = 15.0;
    UIColor *lightColor = [headerView.backgroundColor colorWithAlphaComponent:0.50];
    
    UILabel *tittleLabel = [UILabel new];
    tittleLabel.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[[UIFont preferredFontForTextStyle:UIFontTextStyleBody] pointSize]];
    tittleLabel.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];;
    tittleLabel.backgroundColor = lightColor;
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    tittleLabel.text = @"Ingresa tu consulta";
    CGSize tittleSize = [tittleLabel sizeThatFits:CGSizeMake(viewSize.width - (viewPadding * 2.0), CGFLOAT_MAX)];
    tittleLabel.frame = CGRectMake(viewPadding, imageView.frame.size.height + imageView.frame.origin.y + 40.0, viewSize.width - (viewPadding * 2.0), tittleSize.height + 14.0);
    [scrollView addSubview:tittleLabel];
    
    UITextView *textView = [UITextView new];
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.editable = YES;
    textView.backgroundColor = scrollView.backgroundColor;
    textView.font = tittleLabel.font;
    textView.layer.borderWidth = 2.0;
    textView.layer.borderColor = [tittleLabel.backgroundColor CGColor];
    textView.tintColor = headerView.backgroundColor;
    textView.frame = CGRectMake(viewPadding, tittleLabel.frame.origin.y + tittleLabel.frame.size.height + 10.0, viewSize.width - (viewPadding * 2.0), 200.0);
    [scrollView addSubview:textView];
    self.consulta = textView;
    
    UITextField *emailView = [UITextField new];
    emailView.keyboardType = UIKeyboardTypeEmailAddress;
    emailView.autocorrectionType = UITextAutocorrectionTypeNo;
    emailView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailView.font = tittleLabel.font;
    emailView.layer.borderWidth = 2.0;
    emailView.layer.borderColor = [tittleLabel.backgroundColor CGColor];
    emailView.tintColor = headerView.backgroundColor;
    emailView.placeholder = @" Ingresa aquí tu correo electronico";
    emailView.frame = CGRectMake(viewPadding, textView.frame.origin.y + textView.frame.size.height + 10.0, viewSize.width - (viewPadding * 2.0), tittleLabel.frame.size.height);
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6.0, emailView.frame.size.height)];
    emailView.leftView = leftPaddingView;
    emailView.leftViewMode = UITextFieldViewModeAlways;
    UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, emailView.frame.size.width - 6.0, 6.0, emailView.frame.size.height)];
    emailView.rightView = rightPaddingView;
    emailView.rightViewMode = UITextFieldViewModeAlways;
    emailView.delegate = self;
    [scrollView addSubview:emailView];
    self.email = emailView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Enviar" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = headerView.backgroundColor;
    [button sizeToFit];
    [button addTarget:self action:@selector(enviarConsulta) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake((viewSize.width - button.frame.size.width - 50.0) / 2.0, emailView.frame.origin.y + emailView.frame.size.height + 20.0, button.frame.size.width + 50.0, button.frame.size.height);
    [scrollView addSubview:button];
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, button.frame.size.height + button.frame.origin.y + 25.0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)openSearch:(UIBarButtonItem *)sender {
    UINavigationController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    [searchController setNavigationBarHidden:YES];
    [self presentViewController:searchController animated:YES completion:nil];
}

// Scroll's view top inset.
- (CGFloat)topInset{
    return [self.topLayoutGuide length];
}

// Offset to scroll when the keyboard appears.
- (CGFloat)onKeyboardShowOffset:(CGFloat) keyboardHeight{
    // Subclass.
    return 20.0;
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)enviarConsulta{
    [self dismissKeyboard];
    NSString *consulta = self.consulta.text;
    NSString *email = self.email.text;
    
    if([consulta length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Por favor ingresa tu consulta."
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else if([email length] == 0 || ![self NSStringIsValidEmail:email]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Por favor ingresa tu correo electronico."
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enviando consulta..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] tAyuda] sendConsulta:consulta correo:email completionBlock:^(BOOL completed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                if(completed){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tu consulta se envió con éxito."
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                    self.consulta.text = nil;
                    self.email.text = nil;
                } else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Se produjo un error, por favor intente de nuevo más tarde."
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            });
        }];
    }
}

@end

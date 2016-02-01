//
//  KeyboardBasicViewController.m
//  Twnel
//
//  Created by Santiago Castillo on 7/29/14.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "KeyboardBasicViewController.h"

@interface KeyboardBasicViewController ()
// Used to prevent graphic glitch where the keyboard would mess the UI upon device rotation.
@property (nonatomic) BOOL rotationFlag;
// Used to prevent scrolling on push transition.
@property (nonatomic) BOOL transitionFlag;
// Used to prevent scroll glitch on view appear event.
@property (nonatomic) BOOL appearingFlag;
// Reference to the tap gesture recognizer.
@property (weak, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation KeyboardBasicViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    // Add tap gesture recogniser.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    // On tap hide the keyboard.
    [self.view addGestureRecognizer:tap];
    self.tapGestureRecognizer = tap;
    
    // Receive notifications from keyboard.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc{
    // Remove the gesture recognizer.
    if(self.tapGestureRecognizer){
        [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    }
}

// Subscribe to reachability changes.
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Reset the flags.
    self.transitionFlag = NO;
    self.appearingFlag = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.transitionFlag = YES;
    [self dismissKeyboard];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    // Resize scroll view's visible content area.
    self.scrollView.contentInset = UIEdgeInsetsMake([self topInset], 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake([self topInset], 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.appearingFlag = NO;
}

// Rotation complete, turn rotation flag of.
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.rotationFlag = NO;
}

// Rotation begins, turn rotation flag on.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.rotationFlag = YES;
}

// Hides the keyboard when the view is tapped.
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

// Scroll's view top inset.
- (CGFloat)topInset{
    return 0.0;
}

// Offset to scroll when the keyboard appears.
- (CGFloat)onKeyboardShowOffset:(CGFloat) keyboardHeight{
    // Subclass.
    return 0.0;
}

// Called when the UIKeyboardDidShowNotification is sent.
// Resize scrollbar's visible content and center the textfield.
- (void)keyboardWillShow:(NSNotification*)aNotification{
    // Get keyboard height.
    NSDictionary* info = [aNotification userInfo];
    
    // Check the orientation of the device.
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // Define the viewable space.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake([self topInset], 0.0, kbHeight, 0.0);
    
    // If the view is appearing the scrolling is instantaneous.
    NSTimeInterval animationDuration = 0.5;
    if(self.appearingFlag){
        animationDuration = 0.0;
    }
    
    __weak KeyboardBasicViewController *this = self;
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:500.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if(this && !this.transitionFlag){
            CGFloat scrollPoint = [this onKeyboardShowOffset:kbHeight];
            scrollPoint = scrollPoint < 0? 0: scrollPoint;
            this.scrollView.contentOffset = CGPointMake(0, scrollPoint);
        }
    } completion:^(BOOL finished) {
        this.scrollView.contentInset = contentInsets;
        this.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

// Called when the UIKeyboardWillHideNotification is sent.
// Resize scrollbar's visible content and scroll to the top.
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    if(!self.rotationFlag){
        if(self.transitionFlag){
            __weak KeyboardBasicViewController *this = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                // Resize scroll view's visible content area.
                this.scrollView.contentInset = UIEdgeInsetsMake([this topInset], 0, 0, 0);
                this.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake([this topInset], 0, 0, 0);
            });
        } else{
            // Scroll up.
            __weak KeyboardBasicViewController *this = self;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:500.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                CGPoint scrollPoint = CGPointMake(0.0, -[this topInset]);
                this.scrollView.contentOffset = scrollPoint;
            } completion:^(BOOL finished) {
                this.scrollView.contentInset = UIEdgeInsetsMake([this topInset], 0, 0, 0);
                this.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake([this topInset], 0, 0, 0);
            }];
        }
    }
}

@end

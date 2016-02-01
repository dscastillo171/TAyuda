//
//  KeyboardBasicViewController.h
//  Twnel
//
//  Created by Santiago Castillo on 7/29/14.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardBasicViewController : UIViewController <UIScrollViewDelegate>
// Base scroll view.
@property (weak, nonatomic) UIScrollView *scrollView;
// Hides the keyboard.
- (void)dismissKeyboard;
// Scroll's view top inset.
- (CGFloat)topInset;
// Offset to scroll when the keyboard appears.
- (CGFloat)onKeyboardShowOffset:(CGFloat) keyboardHeight;
@end

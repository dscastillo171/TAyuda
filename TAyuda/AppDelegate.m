//
//  AppDelegate.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/16/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak, nonatomic) UIView *bannerView;
@property (strong, nonatomic) NSString *bannerLink;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor colorWithWhite:158/255.0 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"FrutigerLTStd-Bold" size:20.0]}];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:117/255.0 alpha:1.0]];
    
    // Preload HTML parser & Textview.
    [PreguntaTableViewCell preload];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.tAyuda deleteUnrelevantObjects];
    [self.tAyuda updateTemas];
    [self.tAyuda updateTramites];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (TAyuda *)tAyuda{
    if(!_tAyuda){
        _tAyuda = [TAyuda new];
    }
    return _tAyuda;
}

- (void)displayBanner{
    CGFloat bannerHeight = 50.0;
    CGFloat imageHeight = 42.0;
    CGFloat textFontSize = 16.0;
    CGFloat buttonSize = 30.0;
    CGFloat scrollSpeed = 0.30;
    
    [self.tAyuda getBannerContent:^(NSDictionary *bannerContent) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *link = [bannerContent objectForKey:@"enlace"];
            NSString *imagePath = [bannerContent objectForKey:@"imagen"];
            NSString *message = [bannerContent objectForKey:@"mensaje"];
            
            UIImage *image;
            if(imagePath && ![imagePath isEqualToString:@"null"]){
                NSURL *url = [NSURL URLWithString:imagePath];
                NSData *data = [NSData dataWithContentsOfURL:url];
                image = [[UIImage alloc] initWithData:data];
            }
            
            if(message){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0, self.window.frame.size.height - bannerHeight, self.window.frame.size.width, bannerHeight)];
                    banner.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
                    
                    if(image){
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((bannerHeight - imageHeight) / 2.0, (bannerHeight - imageHeight) / 2.0, imageHeight, imageHeight)];
                        imageView.image = image;
                        [banner addSubview: imageView];
                    }
                    
                    UIImageView *closeButton = [[UIImageView alloc] initWithFrame:CGRectMake(self.window.frame.size.width - buttonSize - ((bannerHeight - imageHeight) / 2.0), (bannerHeight - buttonSize) / 2.0, buttonSize, buttonSize)];
                    closeButton.image = [MediaHandler image:[UIImage imageNamed:@"close.png"] tintedWithColor:[MediaHandler colorForPosition: 4]] ;
                    closeButton.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBanner)];
                    [closeButton addGestureRecognizer:tap];
                    [banner addSubview:closeButton];
                    
                    UILabel *textView = [UILabel new];
                    textView.font = [UIFont systemFontOfSize:textFontSize];
                    textView.textColor = [UIColor whiteColor];
                    textView.text = message;
                    
                    [textView sizeToFit];
                    CGRect textFrame = textView.frame;
                    textFrame.origin = CGPointMake(0, (bannerHeight - textFrame.size.height) / 2.0);
                    textView.frame = textFrame;
                    
                    UIScrollView *textBox = [[UIScrollView alloc] initWithFrame:CGRectMake((image? imageHeight: 0) + ((bannerHeight - imageHeight) * 1.5), 0, self.window.frame.size.width - ((image? imageHeight: 0) + buttonSize + ((bannerHeight - imageHeight) * 2.5)), bannerHeight)];
                    
                    UILabel *textViewCopy = [UILabel new];
                    if(textView.frame.size.width > textBox.frame.size.width){
                        textViewCopy.font = textView.font;
                        textViewCopy.textColor = textView.textColor;
                        textViewCopy.text = textView.text;
                        [textViewCopy sizeToFit];
                        CGRect textCopyFrame = textViewCopy.frame;
                        textCopyFrame.origin = CGPointMake(textFrame.origin.x + textFrame.size.width + (bannerHeight - imageHeight), (bannerHeight - textFrame.size.height) / 2.0);
                        textViewCopy.frame = textCopyFrame;
                    }
                    
                    textBox.contentSize = CGSizeMake((textView.frame.size.width * 2) + (bannerHeight - imageHeight), bannerHeight);
                    [textBox addSubview:textView];
                    [textBox addSubview:textViewCopy];
                    textBox.userInteractionEnabled = YES;
                    if(link){
                        self.bannerLink = link;
                        UITapGestureRecognizer *linkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLink)];
                        [textBox addGestureRecognizer:linkTap];
                    }
                    
                    [banner addSubview:textBox];
                    
                    UINavigationController *controller = (UINavigationController *)[self.window rootViewController];
                    [controller.view addSubview:banner];
                    self.bannerView = banner;
                    
                    if(textView.frame.size.width > textBox.frame.size.width){
                        __block void (^animationBlock)(void);
                        animationBlock = ^{
                            [UIView animateWithDuration:(scrollSpeed * [textView.text length]) delay:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
                                textBox.contentOffset = CGPointMake(textViewCopy.frame.origin.x, 0);
                            } completion:^(BOOL finished) {
                                [textBox setContentOffset:CGPointZero animated:NO];
                                animationBlock();
                            }];
                        };
                        animationBlock();
                    }
                });
            }
        });
    }];
}

- (void)removeBanner{
    [self.bannerView removeFromSuperview];
}

- (void)openLink{
    NSURL *url = [NSURL URLWithString:self.bannerLink];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end

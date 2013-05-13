//
//  IMDBViewController.h
//  bihoskop
//
//  Created by Mihailo Gazda on 8/14/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>

@interface IMDBViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *web;
    IBOutlet UILabel *title;
    IBOutlet UIActivityIndicatorView* progress;
    
    NSString* pastURL;
}

@property (nonatomic, retain) IBOutlet UIWebView *web;
@property (nonatomic, retain) IBOutlet UILabel *titl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* progress;

- (IBAction)close:(id)sender;
- (void) navigate: (NSString*) url withTitle: (NSString*)tit;
- (void) navigateWithYoutube: (NSString*) url;


@end

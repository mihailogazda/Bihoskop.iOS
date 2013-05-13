//
//  IMDBViewController.m
//  bihoskop
//
//  Created by Mihailo Gazda on 8/14/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "IMDBViewController.h"

@interface IMDBViewController ()

@end

@implementation IMDBViewController

@synthesize web;
@synthesize titl;
@synthesize progress;

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [progress startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [progress stopAnimating];
}

- (void) navigate:(NSString *)url withTitle:(NSString *)tit
{
    NSLog(@"Navigating to : %@", url);
    
    if ([web isLoading] )
        [web stopLoading];
    
    [titl setText:tit];
    
    NSURL *ur = [NSURL URLWithString:url];
    NSURLRequest *req = [NSURLRequest requestWithURL:ur];
    [web loadRequest:req];
}

- (void) navigateWithYoutube:(NSString *)url
{
    //NSURL *uri = [NSURL URLWithString:url];
    //[web loadRequest:[NSURLRequest requestWithURL:uri]];
    
   
    
}

- (IBAction)close:(id)sender
{
    NSLog(@"Zatvaram IMDB");
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

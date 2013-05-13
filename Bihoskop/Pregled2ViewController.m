//
//  Pregled2ViewController.m
//  bihoskop
//
//  Created by Mihailo Gazda on 8/4/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "Pregled2ViewController.h"

@interface Pregled2ViewController ()

@end

@implementation Pregled2ViewController

- (bool) pogledDva
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

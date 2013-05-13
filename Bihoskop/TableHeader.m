//
//  TableHeader.m
//  bihoskop
//
//  Created by Mihailo Gazda on 8/6/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "TableHeader.h"

@interface TableHeader ()

@end

@implementation TableHeader

@synthesize labela;
@synthesize labela2;

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

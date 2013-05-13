//
//  DatePickerViewController.m
//  bihoskop
//
//  Created by Mihailo Gazda on 7/25/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize m_datePicker;
@synthesize m_ponistiDugme;
@synthesize m_prihvatiDugme;

- (IBAction)proslaSedmica:(id)sender
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:60*60*24*7*-1];
    [m_datePicker setDate:date];
}

- (IBAction)danasnjiDan:(id)sender
{
    [m_datePicker setDate:[NSDate date]];
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

- (IBAction)ponistiClick:(id)sender
{
    NSLog(@"Ponisti dugme");
}

@end

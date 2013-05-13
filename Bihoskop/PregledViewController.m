//
//  PregledViewController.m
//  bihoskop
//
//  Created by Mihailo Gazda on 7/24/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "PregledViewController.h"

@interface PregledViewController ()

@end

@implementation PregledViewController

@synthesize naziv;
@synthesize zanr;
@synthesize slika;
@synthesize reziser;
@synthesize trajanje;
@synthesize zvjezdice;
@synthesize zvjezdiceBack;
@synthesize scrollView;
@synthesize opis2;
@synthesize glumci;
@synthesize imdbDugme;
@synthesize termini;
@synthesize crvenoDugme;


- (bool) pogledDva
{
    return NO;
}

- (void) setSuperview:(UIViewController *)superview
{
    superview2 = superview;
}

- (void) setupFromDataFilm:(DataFilm *)data withImage:(UIImage *)img
{
    film = data;
    [naziv setText:data->naslovSrp];
    [zanr setText:data->zanr];
    [reziser setText:data->reziser];
    [slika setImage:img];
    
    NSString *tra = [NSString stringWithFormat:@"Trajanje: %@ minuta", data->trajanje];
    [trajanje setText:tra];

    [opis2 setText:data->sadrzaj];
    [opis2 sizeToFit];
    
    [glumci setText:data->glumci];
    
    float rating = [data->imdbOcijena floatValue] * 10;
    CGRect r = zvjezdiceOriginal;
    NSLog(@"Rate: %@ Value: %f", data->imdbOcijena, rating);
    
    UIImage *image = [UIImage imageNamed:@"RatingStarsForeground.png"];
    r.size = image.size;

    r.size.width = r.size.width * [image scale] * rating / 100;
    r.size.height *= [image scale]; // wont hurt on (1x) older platforms
    
    CGImageRef ref = image.CGImage;
    CGImageRef image2 = CGImageCreateWithImageInRect(ref, r);
    UIImage *im = [UIImage imageWithCGImage:image2 scale:[image scale] orientation: [image imageOrientation]];
    [zvjezdice setImage:im];
    
    int height = opis2.center.y - opis2.bounds.size.height / 2 + opis2.bounds.size.height;

    //  Callculate scrollview height
    height += imdbDugme.bounds.size.height + 10;
    [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, height)];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
    [self podesiTermine];
}

- (void) podesiTermine
{
    NSArray *vremena = film->vremenaPrikaza;
    
    if (![self pogledDva]){
        [termini removeAllSegments];
        for (int i = 0; i < vremena.count; i++)
        {
            [termini insertSegmentWithTitle:[vremena objectAtIndex:i] atIndex:i animated:NO];
        }
    }
}

- (IBAction)doClickIMDB:(id)sender
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: film->imdbLink]];
    if (!imdb)
        imdb = [[IMDBViewController alloc] initWithNibName:@"IMDBViewController" bundle:NULL];
    
    if (self->superview2){
        imdb.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self->superview2 presentModalViewController:imdb animated:YES];
        [imdb navigate:film->imdbLink withTitle:film->naslovSrp];
    }
}

- (IBAction)doClickTwitter:(id)sender
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    NSString* titl = [NSString stringWithFormat:@"%@. Definitivno gledam. #bihoskop", film->naslovSrp];
    [twitter setInitialText:titl];
    [twitter removeAllImages];

    [twitter addImage:slika.image];
    [twitter addURL:[NSURL URLWithString:film->imdbLink]];

    [self presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res)
    {
        if(res == TWTweetComposeViewControllerResultDone)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Bihoskop" message:@"Tweet je uspješno objavljen!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
        }

        [self dismissModalViewControllerAnimated:YES];        
    };
    
}

- (IBAction)doPlayTrailer:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:film->trailerLink]];    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //Code for OK button
        NSLog(@"OK dugme - Facebook");
        
        //  Prikazi facebook
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [[NSUserDefaults standardUserDefaults] setObject:film->posterLink forKey:@"fb_poster"];
        [[NSUserDefaults standardUserDefaults] setObject:film->naslovSrp forKey:@"fb_naziv"];
        [[NSUserDefaults standardUserDefaults] setObject:film->trailerLink forKey:@"fb_trejler"];
        [[NSUserDefaults standardUserDefaults] setObject:film->imdbLink forKey:@"fb_imdb"];
        [[NSUserDefaults standardUserDefaults] setObject:film->zanr forKey:@"fb_zanr"];
        [[NSUserDefaults standardUserDefaults] setObject:film->sadrzaj forKey:@"fb_sadrzaj"];
        
        [FBSession setDefaultAppID:@"193979514066336"];
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
            [delegate openSessionWithAllowLoginUI:NO];
        else
            [delegate openSessionWithAllowLoginUI:YES];
        
    }
    if (buttonIndex == 0)
    {
        //Code for download button
        NSLog(@"Ne dugme - Facebook");
    }
}

- (IBAction)doClickFacebook:(id)sender
{
    // Create a new alert object and set initial values.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Objavi na Facebook"
                                                    message:@"Da li ste sigurni da želite objaviti ovaj film na Facebook?"
                                                   delegate:self
                                          cancelButtonTitle:@"Ne želim"
                                          otherButtonTitles:@"Objavi", nil];
    
    // Display the alert to the user
    [alert show];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    bool prihvaceno = action == EKEventEditViewActionSaved;
    NSLog(@"Kalendar je zavrsio svoje %d", prihvaceno);
    
    //  vrati UI nazad
    [termini setSelectedSegmentIndex:UISegmentedControlNoSegment];    

    //  izadji
    [eventViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)doClickCalendar:(id)sender
{
    int index = termini.selectedSegmentIndex;
    NSLog(@"Calendar pressed %d", index);

    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //  min sat ipo ili koliko vec traje + 10m
    int t = MAX([film->trajanje integerValue], 90) + 10/*m*/;
 
    //  nadji u koliko je sati film
    NSString* sati = [termini titleForSegmentAtIndex:termini.selectedSegmentIndex];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate* datumIzSati = [formatter dateFromString:sati];
    NSLog(@"Datum iz sati: %@", sati);
    
    NSDateComponents *comps = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    NSDateComponents *comps2 = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:datumIzSati];
    
    [comps setHour:comps2.hour];
    [comps setMinute:comps2.minute];
    [comps setSecond:0];
    
    //  Podesi event
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *ev = [EKEvent eventWithEventStore:eventStore];
    
    NSDate* startDate = [cal dateFromComponents:comps];
    if ([startDate compare:[NSDate date]] == NSOrderedAscending)
        startDate = [startDate dateByAddingTimeInterval:60*60*24];// add another day if its too late
    
    ev.startDate = startDate;
    ev.endDate = [ev.startDate dateByAddingTimeInterval:t * 60];
    
    [ev setAllDay:NO];
    [ev setAvailability:EKEventAvailabilityUnavailable];
    [ev setTitle:film->naslovSrp];
    [ev setNotes:film->glumci];
    [ev setCalendar:[eventStore defaultCalendarForNewEvents]];
    [ev setURL:[NSURL URLWithString:film->imdbLink]];
    [ev setAlarms:[NSArray arrayWithObject:[EKAlarm alarmWithRelativeOffset:-15*60]]];
    
    NSString* nazivKina = [[NSUserDefaults standardUserDefaults] objectForKey:@"nazivKina"];
    NSString* nazivGrada = [[NSUserDefaults standardUserDefaults] objectForKey:@"nazivGrada"];
    
    [ev setLocation: [NSString stringWithFormat:@"%@ - %@", nazivKina, nazivGrada]];

    //  POdesi Calendar pickr
    eventViewController = [[EKEventEditViewController alloc] init];
    [eventViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top.png"] forBarMetrics:UIBarMetricsDefault];

    UIColor *cl = [crvenoDugme onTintColor];
    [eventViewController.navigationBar setTintColor:cl];

    eventViewController.event = ev;
    eventViewController.eventStore = eventStore;
    eventViewController.editing = NO;
    eventViewController.editViewDelegate = self;
    [eventViewController.topViewController setTitle:@"Kreiraj podsjetnik"];

    //  Prikazi ga
    [self->superview2 presentModalViewController:eventViewController animated:YES];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        zvjezdiceOriginal = zvjezdice.bounds;
        
        //view.layer.cornerRadius = 5;
        //view.layer.masksToBounds = YES;
        
        //facebook = [[Facebook alloc] initWithAppId:@"193979514066336" andDelegate:self];
        eventViewController = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end

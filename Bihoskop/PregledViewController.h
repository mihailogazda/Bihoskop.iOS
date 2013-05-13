//
//  PregledViewController.h
//  bihoskop
//
//  Created by Mihailo Gazda on 7/24/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
//#import "facebook-ios-sdk/src/FBConnect.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DataProxy.h"
#import "IMDBViewController.h"
#import "AppDelegate.h"
#import <Twitter/Twitter.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface PregledViewController : UIViewController <EKEventEditViewDelegate>
{
    IBOutlet UILabel *naziv;
    IBOutlet UILabel *zanr;
    IBOutlet UILabel *reziser;
    IBOutlet UILabel *glumci;
    IBOutlet UILabel *trajanje;
    IBOutlet UIImageView *slika;
    IBOutlet UIImageView *zvjezdice;
    IBOutlet UIImageView *zvjezdiceBack;
    IBOutlet UILabel *opis2;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *imdbDugme;
    IBOutlet UISwitch *crvenoDugme;
    IBOutlet UISegmentedControl *termini;
    CGRect zvjezdiceOriginal;
    
    DataFilm *film;
    IMDBViewController *imdb;
    UIViewController *superview2;
    EKEventEditViewController *eventViewController;
}

@property (retain, nonatomic) IBOutlet UILabel *naziv;
@property (retain, nonatomic) IBOutlet UILabel *zanr;
@property (retain, nonatomic) IBOutlet UILabel *reziser;
@property (retain, nonatomic) IBOutlet UILabel *glumci;
@property (retain, nonatomic) IBOutlet UILabel *trajanje;
@property (retain, nonatomic) IBOutlet UIImageView *slika;
@property (retain, nonatomic) IBOutlet UIImageView *zvjezdice;
@property (retain, nonatomic) IBOutlet UIImageView *zvjezdiceBack;
@property (retain, nonatomic) IBOutlet UILabel *opis2;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *imdbDugme;
@property (retain, nonatomic) IBOutlet UISwitch *crvenoDugme;
@property (retain, nonatomic) IBOutlet UISegmentedControl *termini;

- (void) podesiTermine;
- (void) setupFromDataFilm: (DataFilm *)data withImage: (UIImage*) img;
- (void) setSuperview: (UIViewController*) superview;

- (IBAction)doClickIMDB:(id)sender;
- (IBAction)doPlayTrailer:(id)sender;
- (IBAction)doClickFacebook:(id)sender;
- (IBAction)doClickTwitter:(id)sender;
- (IBAction)doClickCalendar:(id)sender;

- (bool) pogledDva;

@end

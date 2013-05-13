//
//  FirstViewController.h
//  bihoskop2
//
//  Created by Mihailo Gazda on 7/22/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmViewController.h"
#import "Pregled2ViewController.h"
#import "PregledViewController.h"
#import "DatePickerViewController.h"
#import "FTUtils/FTAnimation.h"
#import "DataProxy.h"
#import "ASIDownloadCache.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@class SecondViewController;

@interface FirstViewController : UIViewController
 <UIScrollViewDelegate, UIPageViewControllerDelegate, ASIHTTPRequestDelegate>
{
    IBOutlet UIScrollView *m_scrollView;
    IBOutlet UIPageControl *m_pageControl;
    IBOutlet UIButton *m_tabDugme;
    IBOutlet UIButton *m_refreshDugme;
    IBOutlet UILabel *m_hiddenNoDataLabel;
    IBOutlet UILabel *m_title;
    IBOutlet UIActivityIndicatorView *m_activity;
    
    NSArray *m_threads;
    BOOL pageControlBeingUsed;
    BOOL pickerBeingUsed;
    BOOL previewBeingUsed;
    
    NSDate* m_prosliDatum;
    NSDate* m_datum;
    DataProxy *m_dataProxy;
    NSArray *m_filmovi;
    NSArray *m_uskoro;
    
    bool isMovieSelected;
    
    ASINetworkQueue *queue;
    
    bool downloadUToku;
    bool forceDownload;
    
    PregledViewController *m_ptrPregled;
    DatePickerViewController *m_ptrDatePicker;
}

@property (nonatomic, retain) IBOutlet UIScrollView *m_scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *m_pageControl;
@property (nonatomic, retain) IBOutlet UIButton *m_tabDugme;
@property (nonatomic, retain) IBOutlet UIButton *m_refreshDugme;
@property (nonatomic, retain) IBOutlet UILabel *m_hiddenNoDataLabel;
@property (nonatomic, retain) IBOutlet UILabel *m_title;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *m_activity;

- (void) setupViewFromData: (bool) downloadImages;
- (void) osvjeziPodatke;
- (IBAction)refreshData:(id)sender;

- (void)requestFinished:(ASIHTTPRequest *)request;

- (IBAction)changePage;

- (IBAction)selectMovie:(id)sender;
- (IBAction)closeDugme:(id)sender;
- (IBAction)sakrijPicker:(id)sender;

- (void) hidePicker:(BOOL) save;

- (void) resetPreviewBeingUsed;

- (bool) pogledDva;
- (void) podaciOsvjezeni;


@end
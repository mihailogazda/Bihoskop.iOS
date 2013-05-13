//
//  FirstViewController.m
//  bihoskop2
//
//  Created by Mihailo Gazda on 7/22/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize m_scrollView;
@synthesize m_pageControl;
@synthesize m_tabDugme;
@synthesize m_hiddenNoDataLabel;
@synthesize m_refreshDugme;
@synthesize m_activity;
@synthesize m_title;

- (bool) pogledDva
{
    return NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear pogled2");
    
    extern bool globalShouldRefresh;
    
    if ([self pogledDva] && globalShouldRefresh){
        [self osvjeziPodatke];
        globalShouldRefresh = NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Repertoar", @"Repertoar");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
        //  Inicijalizuj pregled
        m_ptrPregled = [self pogledDva] ?
            [[Pregled2ViewController alloc] initWithNibName:@"Pregled2_iPhone" bundle:nil]
        :
            [[PregledViewController alloc] initWithNibName:@"Pregled_iPhone" bundle:nil];
        
        m_ptrDatePicker = [[DatePickerViewController alloc] initWithNibName:@"DatePicker_iPhone" bundle:nil];
        //  Spusti malo ispod
        m_ptrPregled.view.center = CGPointMake(m_ptrPregled.view.center.x, m_ptrPregled.view.center.y + 47);
        m_ptrDatePicker.view.center = CGPointMake(m_ptrDatePicker.view.center.x, m_ptrDatePicker.view.center.y);
        
        //  Danasnji datum
        m_datum = m_ptrDatePicker.m_datePicker.date;//[NSDate date];
        m_prosliDatum = m_datum;
        
        
        
        m_dataProxy = [[DataProxy alloc] init];
        
        pickerBeingUsed = NO;
        previewBeingUsed = NO;
        m_filmovi = nil;
        m_uskoro = nil;
        
        isMovieSelected = NO;
        
        queue = [[ASINetworkQueue alloc] init];
        
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = YES;
        
    }
    return self;
}
						
- (void)viewDidLoad
{
    [super viewDidLoad];    
    pageControlBeingUsed = NO;
    [self osvjeziPodatke];
    
    NSString* naziv = [[NSUserDefaults standardUserDefaults] objectForKey:@"nazivKina"];
    if (naziv)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.M."];
        naziv = [NSString stringWithFormat:@"%@ %@", naziv, [formatter stringFromDate:m_ptrDatePicker.m_datePicker.date]];
        [m_title setText:naziv];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    UIImage *image = [UIImage imageWithData:responseData];
    NSLog(@"Request recieved of size: %d", [responseData length]);
    
    if ([responseData length] == 0){
        NSLog(@"Size 0 - looking for cached version");
        image = [UIImage imageWithContentsOfFile:[request downloadDestinationPath]];
    }
    
    for (UIView *subview in self.m_scrollView.subviews)
    {
        if (subview.tag == request.tag)
        {
            NSLog(@"Nasao subview");
            for (UIButton* butt in subview.subviews){
                if ([butt isKindOfClass:[UIButton class]]){
                    NSLog(@"Nasao dugme");
                    
                    [UIView transitionWithView:self.view
                                      duration:0.50f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        [butt setBackgroundImage:image forState:UIControlStateNormal];
                                    } completion:NULL];
                    //[UIView commitAnimations];
                }
            }
        }
    }
    
    NSLog(@"Slika ucitana [tag: %d]", [request tag]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Download slike pao %@", [error userInfo]);
}

- (void) setupViewFromData: (bool) downloadImages
{
    //  Clear past queue
    [queue cancelAllOperations];
    queue.maxConcurrentOperationCount = 3;
    
    // With some valid UIView *view:
    for(UIView *subview in [m_scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    //  Coordinate view
    FilmViewController *film = [[FilmViewController alloc] initWithNibName:@"Film" bundle:nil];
    UIView *sview2 = film.view;
    
    int yconst = sview2.center.y + 10;
    int ycopy = yconst;
    int x = sview2.center.x + 3;
    int margin = 0;
    int count = [self pogledDva] ? m_uskoro.count : m_filmovi.count;
    int rows = 2;
    int columns = 3;
    int totalsize = sview2.bounds.size.height;

    
    //if (![self queue]) {
    //    [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    //}
    
    //  Check if no data
    bool prikazi =  [self pogledDva] ? m_uskoro != nil : m_filmovi != nil;
    if (count == 0 && prikazi)
        [m_hiddenNoDataLabel setHidden:NO];
    else
    {
        [m_hiddenNoDataLabel setHidden:YES];
        [m_pageControl setCurrentPage:0];
    }
    
    NSLog(@"Total size %d", totalsize);
    
    int base = 0;
    int iPageCount = 0;
    
    int i = 0;
    int iElemCount = 0;
    for (i = 0; i < count; i++)
    {
        //  Kreiraj pogled
        FilmViewController *film2 = [[FilmViewController alloc] initWithNibName:@"Film" bundle:nil];
        UIView *sview = film2.view;
        film2.dugme.tag = i;

        //  Podesi promjenjive
        DataFilm *data = nil;
        if (![self pogledDva])
            data = [[DataFilm alloc] initFromArray:m_filmovi atIndex:i];
        else
            data =  [[DataFilm alloc] initFromArray:m_uskoro atIndex:i];
        
        sview.tag = [data->idx intValue];
        [film2.naslov setText:data->naslovSrp];
        
        NSURL *url = [NSURL URLWithString:data->posterLink];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.tag = [data->idx intValue];
        
        //  Enable caching for images - load only if not cached
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        
        if (forceDownload)
            [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
            else
            [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        
        //  Kreiraj path
        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filename = [NSString stringWithFormat:@"%@.png", data->idx];
        NSString *path = [documentDirectory stringByAppendingPathComponent:filename];
        [request setDownloadDestinationPath:path];
        
        NSLog(@"Adding url %@ to file %@", [url absoluteString], path);
        
        //  Events
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestFinished:)];
        [request setDidFailSelector:@selector(requestFailed:)];
                
        //[request startAsynchronous];
        [queue addOperation:request];
        
        //  Setup Event za klik
        [film2.dugme addTarget:self action:@selector(selectMovie:) forControlEvents:UIControlEventTouchUpInside];
        
        //  Pozicija
        sview.center = CGPointMake(x, yconst);
        
        //  size of element
        int wsize = sview.bounds.size.width + margin;
        
        //  prekoracen broj elemenata po stranici
        if ((i)%(rows*columns)==0)
        {
            //  Broj elemenata po stranici cijeli broj == new Page
            NSLog(@"New page");
            iPageCount++;
            iElemCount = 0;
            
            base = sview2.center.x + 4 + ((iPageCount-1) * m_scrollView.frame.size.width);
        }
        
        iElemCount++;
        NSLog(@"Page element %d", iElemCount);
        
        int row = iElemCount > columns ? 1 : 0;
        int col = iElemCount - (row * columns);
        NSLog(@"Coordinates: %dx%d", row, col);
        
        //  calculate positions
        int x = base + (col - 1) * wsize;
        int y = row ? ycopy + sview2.bounds.size.height + margin : ycopy;
        
        //  Position and add
        sview.center = CGPointMake(x, y);
        [m_scrollView addSubview:sview]; // increase total height of scroll
    }
    
    //  Start download
    [queue go];
    
    //  Set number of pages
    m_pageControl.numberOfPages = iPageCount;
    
    //  Set scrool size
    totalsize = 200;//m_scrollView.bounds.size.height;//disable scrooll
    int totalsizew = iPageCount * m_scrollView.frame.size.width;//(columns * sview2.bounds.size.width + margin);
    [m_scrollView setContentSize:CGSizeMake(totalsizew, totalsize)];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    if (!pageControlBeingUsed)
    {
        CGFloat pageWidth = m_scrollView.frame.size.width;
        int page = floor((m_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        m_pageControl.currentPage = page;
    }
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = m_scrollView.frame.size.width * self.m_pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.m_scrollView.frame.size;
    [self.m_scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)selectMovie:(id)sender
{
    NSLog(@"Movie select2");
    if (pickerBeingUsed || previewBeingUsed)
        return;
    
    previewBeingUsed = YES;
    [m_refreshDugme setHidden:YES];
    
    //  Ucitaj podatke
    UIButton *butt = sender;
    int idx = butt.tag;
    NSArray *podatak  = [self pogledDva] ? m_uskoro : m_filmovi;
    DataFilm *film = [[DataFilm alloc] initFromArray:podatak atIndex:idx];
    [m_ptrPregled setupFromDataFilm:film withImage:[butt backgroundImageForState:UIControlStateNormal]];
    [m_ptrPregled setSuperview:self];
    
    UIView* toOpenView = m_ptrPregled.view;   
    [[self view] addSubview:toOpenView];
    
    [toOpenView fallIn:0.5 delegate:self];
    //[m_tabDugme setTitle:@"Zatvori" forState:UIControlStateNormal];
    [m_tabDugme setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    isMovieSelected = YES;
    [m_tabDugme setHidden:NO];
    
    //  Reset preview being used
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(resetPreviewBeingUsed)
                                   userInfo:nil
                                    repeats:NO];
    
    [[self view] bringSubviewToFront:m_ptrPregled.view];
}

- (IBAction)closeDugme:(id)sender
{
    if (isMovieSelected)
    {
        NSLog(@"Dugme zatvori");
        
        if (!downloadUToku)
            [m_refreshDugme setHidden:NO];
        
        //  Ugasi pogled        
        UIView *toCloseView = m_ptrPregled.view;
        [toCloseView fallOut:0.3 delegate:self];
        //[toCloseView removeFromSuperview];
        
        //  Vrati title
        if ([self pogledDva]){
            [m_tabDugme setHidden:YES];
        }
        //else
            [m_tabDugme setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        //    [m_tabDugme setTitle:@"Datum" forState:UIControlStateNormal];
        
        isMovieSelected = NO;
    }
    else
    {
        pickerBeingUsed = YES;
        [m_scrollView setScrollEnabled:NO];
        
        m_ptrDatePicker.modalTransitionStyle = UIModalPresentationPageSheet;
        [self presentModalViewController:m_ptrDatePicker animated:YES];
        
        //  Zakaci hide event
        [m_ptrDatePicker.m_ponistiDugme addTarget:self action:@selector(sakrijPicker:) forControlEvents:UIControlEventTouchUpInside];
        [m_ptrDatePicker.m_prihvatiDugme addTarget:self action:@selector(prihvatiIzmjeneDatuma:) forControlEvents:UIControlEventTouchUpInside];
    }    
}

- (void) hidePicker:(BOOL)save
{
    NSLog(@"Hide picker - %@", save ? @"SAVE" : @"CANCEL");
    [self dismissModalViewControllerAnimated:YES];
    [m_scrollView setScrollEnabled:YES];
    //[m_ptrDatePicker.view removeFromSuperview];
    
    if (!save)
    {
        m_ptrDatePicker.m_datePicker.date = m_prosliDatum;
    }
    else
    {
        if (![m_ptrDatePicker.m_datePicker.date isEqual:m_datum])
        {
            //  Remove all subviews
            NSArray *viewsToRemove = [m_scrollView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }

            m_datum = m_ptrDatePicker.m_datePicker.date;
            m_prosliDatum = m_datum;
            
            [self osvjeziPodatke];
        }
    }
    
    //[m_ptrDatePicker.view slideOutTo:kFTAnimationBottom duration:0.5 delegate:self];
    //[m_tabDugme setTitle:@"Datum" forState:UIControlStateNormal];
    pickerBeingUsed = NO;
}

- (void) podaciOsvjezeni
{
    NSLog(@"Podaci osvjezeni fwc");
    m_filmovi = [m_dataProxy getFilmovi];
    m_uskoro = [m_dataProxy getUskoro];
    
    [m_refreshDugme setHidden:NO];
    [m_activity stopAnimating];
    
    downloadUToku = NO;
    
    [self setupViewFromData: forceDownload];
    
    //if (m_pageControl.currentPage != 0)
    {
        CGRect frame = m_scrollView.frame;
        frame.origin.x = 0;
        [m_scrollView scrollRectToVisible:frame animated:NO];
        
        m_pageControl.currentPage = 0;
    }
    
}

- (void) osvjeziPodatke
{
    downloadUToku = YES;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"izabranoKino"])
        return;
    
    if ([self pogledDva])
        [m_dataProxy skiniUskoroListu: @selector(podaciOsvjezeni) withObject:self];
    else
        [m_dataProxy skiniDanasnjePodatke:@selector(podaciOsvjezeni) withObject: self];
    
    m_filmovi = [m_dataProxy getFilmovi];
    m_uskoro = [m_dataProxy getUskoro];
    [m_refreshDugme setHidden:YES];
    [m_activity startAnimating];
    
    //  Reset after click
    [m_dataProxy disableCache:NO];
    forceDownload = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.M."];
    //[self setupViewFromData];
    
    NSString* naziv = [[NSUserDefaults standardUserDefaults] objectForKey:@"nazivKina"];
    if (naziv)
    {
        NSDate *date = m_ptrDatePicker.m_datePicker.date;
        
        NSString* titl = [NSString stringWithFormat:@"%@ %@", naziv, [formatter stringFromDate:date ]];
        [m_title setText:titl];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"user pressed OK");
        [m_dataProxy disableCache:YES];
        forceDownload = YES;
        [self osvjeziPodatke];
	}
}

- (IBAction)refreshData:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Osvježiti podatke?"
                          message: @"Da li ste sigurni da želite osvježiti podatke? Dodatan internet saobraćaj će biti iskorišten."
                          delegate: self
                          cancelButtonTitle:@"Ne"
                          otherButtonTitles:@"Da",nil];
    
    [alert show];
}

- (IBAction)sakrijPicker:(id)sender
{
    NSLog(@"Sakrij picker - ponisti dugme");
    [self hidePicker:NO];
}

- (IBAction)prihvatiIzmjeneDatuma:(id)sender
{
    NSLog(@"Sakrij picker - prihvati dugme");
    [self hidePicker:YES];
    extern bool globalShouldRefresh;
    globalShouldRefresh = NO;
}

- (void) resetPreviewBeingUsed
{
    previewBeingUsed = NO;
}

@end

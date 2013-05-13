//
//  BioskopiViewController.m
//  bihoskop2
//
//  Created by Mihailo Gazda on 7/24/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "BioskopiViewController.h"

@interface BioskopiViewController ()

@end

@implementation BioskopiViewController
@synthesize table;
@synthesize scrollView;
@synthesize tvCell;
@synthesize labela;
@synthesize refreshDugme;

- (IBAction)refresh:(id)sender
{
    if (!dataProxy)
        dataProxy = [[DataProxy alloc] init];
    
    [dataProxy ucitajListuBioskopa];
    
    bioskopi = NULL;
    bioskopi = [dataProxy getBioskopi];
    
    if (!bioskopi)
    {
        [self.refreshDugme setHidden:NO];
        [self.labela setHidden:NO];
        [self.table setHidden:YES];
    }
    else
    {
        [self.refreshDugme setHidden:YES];
        [self.labela setHidden:YES];
        [self.table setHidden:NO];
        [table setClipsToBounds:YES];
        
        [table reloadData];
    }
        
    NSLog(@"Ucitao podatke");
}

- (void) setFirstView:(FirstViewController *)first
{
    firstView = first;
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"Appeared BIoskopi.view");
    if (!bioskopi)
    {
        [self refresh:nil];
    }
    
    extern bool globalFirstStart;
    if (globalFirstStart){

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Dobrodošli" message:@"Dobrodošli u Bihoskop, nadamo se da će vam se svidjeti.\r\n\r\nDa počnete koristiti Bihoskop prvo morate izabrati jedno od ponuđenih bioskopa.\r\n" delegate:nil cancelButtonTitle:@"Dalje" otherButtonTitles: nil];
        [alert show];
        
        globalFirstStart = false;
    }
}

- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags");
               return 0;
    }
               
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
               
    return (isReachable && !needsConnection) ? YES : NO;
}
               
- (IBAction)izaberiBanjaluku:(id)sender
{
    // Fetch a default
    //BOOL deleteBackup = [[NSUserDefaults standardUserDefaults] boolForKey:@"izabranoKino"];
    
    // Save a default
    [[NSUserDefaults standardUserDefaults] setObject:@"3001" forKey:@"izabranoKino"];
    
    //  Skoci na prvi pogled
    //[self.tabBarController setSelectedIndex:1];
    
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate* app2 = (AppDelegate*) app;
    [app2.tabBarController setSelectedIndex:0];
}
- (IBAction)izaberiSarajevo:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"5001" forKey:@"izabranoKino"];
}
-(IBAction)izaberiZenicu:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"4001" forKey:@"izabranoKino"];    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Bioskopi", @"Bioskopi");
        self.tabBarItem.image = [UIImage imageNamed:@"third"];

        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = YES;
        
        [self refresh:nil];
        NSLog(@"Ucitao Bioskope");                     
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    CGRect s = [scrollView bounds];
    [scrollView setContentSize:CGSizeMake(s.size.width, s.size.height + 3)];
    
    [self.labela setText:@"Ups...\r\nProvjerite vašu internet konekciju pa pokušajte ponovo."];
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

/** TABELA **/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableHeader *head = [[TableHeader alloc] initWithNibName:@"TableHeader" bundle:nil];
    // head.labela.text = @"Nesto";
    NSString* titl = [self tableView:tableView titleForHeaderInSection:section];
    
    [[head labela ] setText:titl];
    
    NSArray *kljucevi = [bioskopi allKeys];
    NSArray* kina = [bioskopi valueForKey:[kljucevi objectAtIndex:  section]];
    [[head labela2 ] setText:[NSString stringWithFormat:@"Broj bioskopa: %d", [kina count]]];
    
    
    return head.view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 2;
    //return [self.countries count];
    NSLog(@"Broj gradova %d", bioskopi.count);
    return bioskopi.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sve = [bioskopi allKeys];
    NSString* titl = [sve objectAtIndex:section];
    return titl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // NSString *continent = [self tableView:tableView titleForHeaderInSection:section];
    //return [[self.countries valueForKey:continent] count];
    NSArray *kljucevi = [bioskopi allKeys];
    NSArray* kina = [bioskopi valueForKey:[kljucevi objectAtIndex: section]];
    return kina.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSArray *kljucevi = [bioskopi allKeys];
    NSArray* kina = [bioskopi valueForKey:[kljucevi objectAtIndex: [indexPath section]]];
    NSLog(@"Kina size: %d", kina.count);
    
    NSArray *dat = [kina objectAtIndex:indexPath.row];
    NSString* naziv = [dat valueForKey:@"naziv"];
    NSString* adresa = [dat valueForKey:@"adresa"];
    NSLog(@"Naziv %@, Adresa: %@", naziv, adresa);
    
    
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = (TableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSLog(@"Pravim i pravim");
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = (TableCell*)[views objectAtIndex:0];
        
        //  hack for table selection
        cell.tabela = table;
    }
    
    [[cell naslov ] setText:naziv];
    [[cell podNaslov ] setText:adresa];
    
    NSString* defNaziv = [[NSUserDefaults standardUserDefaults] objectForKey:@"nazivKina"];
    BOOL sakrij = ![defNaziv isEqualToString:naziv];
    [cell.slika setHidden:sakrij];
    //if ([indexPath row] == [[NSUserDefaults standardUserDefaults] objectForKey:@"izabranoKino"])
    
    return cell;
}

- (void) switchPage : (id) sender
{
    [self.tabBarController setSelectedIndex:0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"Mjenjam kino u : %@", index);
        [[NSUserDefaults standardUserDefaults] setObject:index forKey:@"izabranoKino"];
        [[NSUserDefaults standardUserDefaults] setObject:nazivKina forKey:@"nazivKina"];
        [[NSUserDefaults standardUserDefaults] setObject:nazivGrada forKey:@"nazivGrada"];
        
        extern bool globalShouldRefresh;
        globalShouldRefresh = YES;
        
        [table reloadData];
        
        [self.tabBarController setSelectedIndex:0];
        [firstView osvjeziPodatke];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *continent = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    //NSString *country = [[self.countries valueForKey:continent] objectAtIndex:indexPath.row];
    NSArray *kljucevi = [bioskopi allKeys];
    NSString *grad = [kljucevi objectAtIndex:[indexPath section]];
    NSArray* kina = [bioskopi valueForKey:grad];
    //NSLog(@"Kina size: %d", kina.count);
    
    NSArray *dat = [kina objectAtIndex:indexPath.row];
    NSString* naziv = [dat valueForKey:@"naziv"];
    NSString *kino = naziv;
    NSString *idx = [dat valueForKey:@"idx"];
    NSLog(@"Kina size: %d, idx: %d, naziv:%@", kina.count, [idx integerValue], naziv);
    
    index = idx;
    nazivKina = kino;
    nazivGrada = grad;
    [dat valueForKey:@""];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Postaviti \"%@\" kao izabrano kino?", kino] delegate:nil cancelButtonTitle:@"Ne" otherButtonTitles:@"Prihvati", nil];
    [alert setDelegate:self];
    [alert show];
    //[alert release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

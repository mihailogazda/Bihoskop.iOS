//
//  BioskopiViewController.h
//  bihoskop2
//
//  Created by Mihailo Gazda on 7/24/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <CFNetwork/CFNetwork.h>
#import "Reachability/Reachability.h"
#import "DataProxy.h"
#import "FirstViewController.h"
#import "AppDelegate.h"
#import "TableHeader.h"
#import "TableCell.h"

@interface BioskopiViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *table;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *labela;
    IBOutlet UIButton *refreshDugme;
    NSDictionary *bioskopi;
    DataProxy *dataProxy;
    NSString *index;
    FirstViewController *firstView;
    
    NSString *nazivKina;
    NSString *nazivGrada;
}

@property (nonatomic, retain) IBOutlet UILabel *labela;
@property (nonatomic, retain) IBOutlet UIButton *refreshDugme;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) TableCell *tvCell;

- (IBAction)izaberiBanjaluku:(id)sender;
- (IBAction)izaberiZenicu:(id)sender;
- (IBAction)izaberiSarajevo:(id)sender;
- (void) setFirstView: (FirstViewController*) first;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (BOOL) connectedToNetwork;
- (IBAction)refresh:(id)sender;

@end

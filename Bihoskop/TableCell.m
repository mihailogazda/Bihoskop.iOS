//
//  TableCell.m
//  bihoskop
//
//  Created by Mihailo Gazda on 8/6/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

@synthesize naslov;
@synthesize podNaslov;
@synthesize slika;
@synthesize tabela;

- (IBAction)click:(id)sender
{
    NSLog(@"oooooo");    
	NSIndexPath *path=[tabela indexPathForCell:self];
    
    NSLog(@"been pressed %d:%d",path.section, path.row);
    //[tabela selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tabela.delegate tableView:self.tabela didSelectRowAtIndexPath:path];
}


@end


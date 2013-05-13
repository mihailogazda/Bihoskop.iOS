//
//  TableCell.h
//  bihoskop
//
//  Created by Mihailo Gazda on 8/6/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell
{
    IBOutlet UILabel* naslov;
    IBOutlet UILabel* podNaslov;
    IBOutlet UIImageView* slika;
    UITableView* tabela;
}

@property (nonatomic, retain) IBOutlet UILabel* naslov;
@property (nonatomic, retain) IBOutlet UILabel* podNaslov;
@property (nonatomic, retain) IBOutlet UIImageView* slika;
@property (nonatomic, retain)    UITableView* tabela;

- (IBAction)click:(id)sender;

@end

//
//  FilmViewController.h
//  bihoskop
//
//  Created by Mihailo Gazda on 7/24/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MojeDugme : UIButton
{
    NSInteger tag2;
}

@property (nonatomic) NSInteger tag2;

@end

@interface FilmViewController : UIViewController
{
    int sifra;
    int filenameIndex;
    IBOutlet UILabel *naslov;
    IBOutlet MojeDugme *dugme;
}

@property (nonatomic, retain) IBOutlet UILabel *naslov;
@property (nonatomic, retain) IBOutlet MojeDugme *dugme;

- (IBAction)doClickMovie:(id)sender;

@end

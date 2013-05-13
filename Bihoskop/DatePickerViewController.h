//
//  DatePickerViewController.h
//  bihoskop
//
//  Created by Mihailo Gazda on 7/25/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DatePickerViewController : UIViewController
{
    IBOutlet UIDatePicker *m_datePicker;
    IBOutlet UIButton *m_ponistiDugme;
    IBOutlet UIButton *m_prihvatiDugme;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *m_datePicker;
@property (nonatomic, retain) IBOutlet UIButton *m_ponistiDugme;
@property (nonatomic, retain) IBOutlet UIButton *m_prihvatiDugme;

- (IBAction)ponistiClick:(id)sender;
- (IBAction)danasnjiDan:(id)sender;
- (IBAction)proslaSedmica:(id)sender;

@end

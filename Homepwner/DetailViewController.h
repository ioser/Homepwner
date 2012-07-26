//
//  DetailViewController.h
//  Homepwner
//
//  Created by Richard Millet on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REMItem;

@interface DetailViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIToolbar *bottonToolbar;
    
    __weak IBOutlet UIBarButtonItem *trashButtonItem;
}

@property (nonatomic, strong) REMItem *item;

- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)deleteImage:(id)sender;

@end

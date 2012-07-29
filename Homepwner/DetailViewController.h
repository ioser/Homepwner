//
//  DetailViewController.h
//  Homepwner
//
//  Created by Richard Millet on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REMItem;

@interface DetailViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIToolbar *bottonToolbar;
    // A bar button item to delete/clear the item's image
    __weak IBOutlet UIBarButtonItem *trashButtonItem;
    
    UIPopoverController *imagePickerPopover;
}

- (id)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) REMItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)deleteImage:(id)sender;

@end

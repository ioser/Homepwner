//
//  DetailViewController.m
//  Homepwner
//
//  Created by Richard Millet on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRImageStore.h"
#import "REMItem.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // We're not going to allow this call.
//        @throw [NSException exceptionWithName:@"Wrong initializer called." 
//                                       reason:@"Use initForNewItem instead." 
//                                     userInfo:nil];
    }
    return self;
}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        if (isNew == YES) {
            // Create "done" and "cancel" bar button items
            UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone 
                                                                                            target:self 
                                                                                            action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneButtonItem];
            
            UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                              target:self 
                                                                                              action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelButtonItem];
        }
    }
    
    return self;
}

//- (id)initWithItem:(REMItem *)remItem

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover controller.");
    imagePickerPopover = nil; // Essentially destroy the pop over picker controller by setting to nil
}

- (IBAction)takePicture:(id)sender
{
    if ([imagePickerPopover isPopoverVisible] == NO) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        UIImagePickerControllerSourceType sourceType;
        
        // Allow the user to edit the image
        [imagePickerController setAllowsEditing:YES];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [imagePickerController setSourceType:sourceType];
        [imagePickerController setDelegate:self];
        
        // Now place the image picker view on the screen modally
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            // Create a new popover controller to display the image picker
            imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
            [imagePickerPopover setDelegate:self];
            
            // Finally present the view controller
            [imagePickerPopover presentPopoverFromBarButtonItem:sender 
                                       permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                       animated:YES];
            
        } else {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else {
        NSLog(@"Pop over controller's picker is already visible");
    }
}

- (IBAction)deleteImage:(id)sender
{
    NSString *currentImageKey = [item imageKey];
    if (currentImageKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:currentImageKey];
        [imageView setImage:nil];
        [trashButtonItem setEnabled:NO];
    }
}


// A tap should dismiss the keyboard
- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}

// Create a UUID string to use as a key for the image key store
- (NSString *)createImageKey
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    result = [NSString stringWithString:(__bridge NSString *)stringRef]; // Use "toll free bridge" casting mechanism and a copy
    
    // Now release the CF objects
    CFRelease(stringRef);
    CFRelease(uuid);

    return result;
}

/*
 * This method is a UIImagePickerControllerDelegate method
 *
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get this picked image
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (editedImage) {
        pickedImage = editedImage;
    }

    // If the user picked a new image and there is currently an existing image, delete the current one from the image store.
    NSString *currentImageKey = [item imageKey];
    if (currentImageKey && pickedImage) { // Delete the current image for the item if one exists
        UIImage *currentImage = [[BNRImageStore sharedStore] imageForKey:currentImageKey];
        if (currentImage) {
            [[BNRImageStore sharedStore] deleteImageForKey:currentImageKey];
        }
    }

    // If there is a new image, save it using a generated UUID string as the key
    if (pickedImage) {
        NSString *imageKey = [self createImageKey];
        [[self item] setImageKey:imageKey];
        [[BNRImageStore sharedStore] setImage:pickedImage forKey:imageKey];
        [imageView setImage:pickedImage]; // set the image in the view
        
        // Enable the delete image bar button item since we have an picture/image now
        [trashButtonItem setEnabled:YES];
    }
    
    // Dismiss the image picker controller if it is an iPhone/iPod
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // otherwise, dismiss the pop over controller
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}

- (void)setItem:(REMItem *)theItem
{
    if (theItem) {
        UINavigationItem *navigationItem = [self navigationItem];
        [navigationItem setTitle:[theItem itemName]];
        item = theItem;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:item.itemName];
    [serialField setText:item.serialNumber];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    
    // Get the item's image if one exists and set it to the item's image view member instance
    NSString *imageKey = [item imageKey];
    if (imageKey) {
        UIImage *image = [[BNRImageStore sharedStore] imageForKey:imageKey];
        [imageView setImage:image];
		[trashButtonItem setEnabled:YES];
    } else {
        [imageView setImage:nil];
    }
}

/*
 * Check to see if any of the fields in the view have changed from the values we loaded
 * from the original item.  If they've changed, we need to update the item.
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Clear the first responder
    [[self view] endEditing:YES];
    
    item.itemName = [nameField text];
    item.serialNumber = [serialField text];
    item.valueInDollars = [[valueField text] intValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *backgroundColor = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        backgroundColor = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    // Do any additional setup after loading the view from its nib.
    [[self view] setBackgroundColor:backgroundColor];
}

- (void)viewDidUnload
{
    nameField = nil;
    serialField = nil;
    valueField = nil;
    dateLabel = nil;
    imageView = nil;
    bottonToolbar = nil;
    trashButtonItem = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL result = (interfaceOrientation == UIInterfaceOrientationPortrait); // Keep in portrait by default
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        result = YES;
    }
    
    return result;
}

//
// UITextFieldDelegate
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

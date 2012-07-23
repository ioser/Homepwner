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
    }
    return self;
}

//- (id)initWithItem:(REMItem *)remItem

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePickerController setSourceType:sourceType];
    [imagePickerController setDelegate:self];
    
    // Now place the image picker view on the screen modally
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (NSString *)createImageKey
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    result = (__bridge NSString *)stringRef;

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
    
    // Save the image using the serial number for as the key
    NSString *imageKey = [self createImageKey];
    [[self item] setImageKey:imageKey];
    [[BNRImageStore sharedStore] setImage:pickedImage forKey:imageKey];
    
    // Dismiss the image picker controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    // Get the item's image if one exists
    NSString *imageKey = [serialField text];
    UIImage *image = [[BNRImageStore sharedStore] imageForKey:imageKey];
    [imageView setImage:image];
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
    // Do any additional setup after loading the view from its nib.
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidUnload
{
    nameField = nil;
    serialField = nil;
    valueField = nil;
    dateLabel = nil;
    imageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

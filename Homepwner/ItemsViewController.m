//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Richard Millet on 6/27/12.
//  Copyright (c) 2012 Millet Designs. All rights reserved.
//
// 

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "REMItem.h"

#define NUM_OF_SECTIONS 1
#define STR_DELETE_CONFIRMATION_LABEL @"Remove"
#define STR_NO_MORE_ITEMS @"No more items"

@implementation ItemsViewController

- (void)loadView
{
    [super loadView];
}

- (id)init
{
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
        UINavigationItem *navigationItem = [self navigationItem];
        [navigationItem setTitle:@"Homepwner"];
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                       target:self action:@selector(addNewItem:)];
        // Now set this bar button item to be the rightmost item in the navigation item
        [[self navigationItem] setRightBarButtonItem:barButtonItem];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
        
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	return [self init];
}

//- (UIView *)headerView
//{
//    // headerView will be initialized to nil at startup time
//    
//    if (!headerView) {
//        NSBundle *nsBundle = [NSBundle mainBundle];
//        [nsBundle loadNibNamed:@"HeaderView" owner:self options:nil];
//        // sets "headerView" member on nib load
//    }
//        
//    return headerView;
//}

//- (IBAction)toggleEditingMode:(id)sender
//{
//    if ([self isEditing]) {
//        // Change the text of the button to inform the user of editing mode
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [self setEditing:NO animated:YES];
//    } else {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        [self setEditing:YES animated:YES];
//    }
//}

/*
 * The UITableView's row count and the datasource's row count must be equal.  Also, it
 * seems that they must also be in synch?
 */
- (IBAction)addNewItem:(id)sender
{
    // Create a new item
    REMItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    /*
    // Determine its location in the store -it should be at the end
    int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    int testLastRow = [[[BNRItemStore sharedStore] allItems] count] - 1;
    if (testLastRow != lastRow) {
        NSLog(@"New item was not inserted at the end. Insert at %d and end is %d",
              lastRow, testLastRow);
    }
    
    // Make a new index path for inserting a new row
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0]; // Hardcode 0 as the section since we only have one section
    
    // Insert the new row into the table at the end
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
     */
    
    // Create a detail view controller so we can edit the new item
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setItem:newItem];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    // Now create a navigation controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
//    [navigationController setModalPresentationStyle:UIModalPresentationCurrentContext]; // Use the form sheet style
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet]; // Use the form sheet style
//    [self setDefinesPresentationContext:YES];
//    [navigationController setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentViewController:navigationController animated:YES completion:nil];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Load our custom cell view xib/nib
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    //Register this nib/xib with the table view
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL result = (interfaceOrientation == UIInterfaceOrientationPortrait); // Keep in portrait by default
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        result = YES;
    }
    
    return result;
}

- (BOOL)isLastRow:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    BOOL result = NO;
    
    int row = [indexPath row];
    int section = [indexPath section];

    if (row >= [tableView numberOfRowsInSection:section] - 1) {
        result = YES;
    }
    
    return result;
}

//
// Methods for the UITableViewDelegate
//

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If it is the last row, just gray out the message and make it so it can't be selected.
    if ([self isLastRow:tableView atIndexPath:indexPath] == YES) {
        [[cell textLabel] setTextColor:[UIColor grayColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
        [[cell textLabel] setTextColor:[UIColor blackColor]];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *result = indexPath;
    if ([self isLastRow:tableView atIndexPath:indexPath] == YES) {
        result = nil;
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([self isLastRow:tableView atIndexPath:indexPath] == NO) {
        // Set the item to be viewed
        NSInteger row = [indexPath row];
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        REMItem *itemToDisplay = [items objectAtIndex:row];
        DetailViewController *detailViewControler = [[DetailViewController alloc] initForNewItem:NO];
        [detailViewControler setItem:itemToDisplay];
        [[self navigationController] pushViewController:detailViewControler animated:YES];
    }
}

- (NSIndexPath *)               tableView:(UITableView *)tableView
 targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                      toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *result = proposedDestinationIndexPath;
    
    if ([self isLastRow:tableView atIndexPath:sourceIndexPath] ||
        [self isLastRow:tableView atIndexPath:proposedDestinationIndexPath]) {
        result = sourceIndexPath;
    }
    
    return result;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleDelete;
    
    if ([self isLastRow:tableView atIndexPath:indexPath]) {
        result = UITableViewCellEditingStyleNone;
    }
    
    return result;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [self headerView];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return [[self headerView] bounds].size.height;
//}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Do nothing.
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return STR_DELETE_CONFIRMATION_LABEL;
}

//
// Methods for UITableViewDataSource
//

- (void)    tableView:(UITableView *)tableView 
   moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
          toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}

- (void)    tableView:(UITableView *)tableView
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    REMItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove the item from the data store
        [[BNRItemStore sharedStore] removeItem:item];
        
        // Remove the row from the table view
        NSArray *rowsToDelete = [NSArray arrayWithObject:indexPath];
        [tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger result = -1;
    
    result = [[[BNRItemStore sharedStore] allItems] count] + 1;
	
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Before creating a new cell instance, check for a reusable one
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
//    if (!cell) {
//        // Create an instance of UITableViewCell with default appearance
//        cell = [[HomepwnerItemCell alloc] initWithStyle:UITableViewCellStyleDefault  
//                                      reuseIdentifier:@"HomepwnerItemCell"];
//    }
	
    int row = [indexPath row];
    NSInteger section = [indexPath section];
    NSString *description = STR_NO_MORE_ITEMS;
    
    if ([self isLastRow:tableView atIndexPath:indexPath] == NO) {
        // Set the text on the cell with the description of the item
        // that is at the nth index of the items, where n = row this cell
        // will appear in on the table view
        REMItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
        [cell.thumbnailView setImage:[[BNRImageStore sharedStore] imageForKey:item.imageKey]];
        [cell.nameLabel setText:item.itemName];
        [cell.serialNumberLabel setText:item.serialNumber];
        [cell.valueLabel setText: [NSString stringWithFormat:@"$%d", [item valueInDollars]]];
    } else {
        [cell.textLabel setText:description]; // The contents of the cell.
    }
    
    NSLog(@"Setting cell value for row %d and section %d",
          row, section);
	
	return cell;
}

@end

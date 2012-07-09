//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Richard Millet on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// 

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "REMItem.h"

#define NUM_OF_SECTIONS 1

@implementation ItemsViewController

- (void)loadView
{
    [super loadView];
}

- (id)init
{
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		for (int i = 0; i < 5; i++) {
			[[BNRItemStore sharedStore] createItem];
		}
	}
        
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	return [self init];
}

- (UIView *)headerView
{
    // headerView will be initialized to nil at startup time
    
    if (!headerView) {
        NSBundle *nsBundle = [NSBundle mainBundle];
        [nsBundle loadNibNamed:@"HeaderView" owner:self options:nil];
        // sets "headerView" member on nib load
    }
        
    return headerView;
}

- (IBAction)toggleEditingMode:(id)sender
{
    if ([self isEditing]) {
        // Change the text of the button to inform the user of editing mode
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

//
// Methods for the UITableViewDelegate
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [[self headerView] bounds].size.height;
}

//
// Methods for UITableViewDataSource
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger result = -1;
    
    result = [[[BNRItemStore sharedStore] allItems] count];
	
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Before creating a new cell instance, check for a reusable one
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        // Create an instance of UITableViewCell with default appearance
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  
                                      reuseIdentifier:@"UITableViewCell"];
    }
	
	// Set the text on the cell with the description of the item
	// that is at the nth index of the items, where n = row this cell
	// will appear in on the table view
	REMItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
	
	[cell.textLabel setText:[p description]];
    
    NSLog(@"Setting cell value for row %d and section %d",
          [indexPath row], [indexPath section]);
	
	return cell;
}

@end

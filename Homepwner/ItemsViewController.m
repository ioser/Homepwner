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

@implementation ItemsViewController

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

//
// Methods for UITableViewDataSource
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger result = -1;
	
	result = [[[BNRItemStore sharedStore] allItems] count];
	
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Create an instance of UITableViewCell with default appearance
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	
	// Set the text on the cell with the description of the item
	// that is at the nth index of the items, where n = row this cell
	// will appear in on the table view
	REMItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
	
	[cell.textLabel setText:[p description]];
	
	return cell;
}

@end

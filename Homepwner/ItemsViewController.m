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

#define NUM_OF_ITEMS 1
#define NUM_OF_SECTIONS 2
#define NUM_OF_COMMENT_ROWS 1
#define STR_NO_MORE_ITEMS @"No more items."

#define MAX_DOLLAR_VALUE 50

@implementation ItemsViewController

- (id)init
{
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		for (int i = 0; i < NUM_OF_ITEMS; i++) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger result = -1;
    int total = [[[BNRItemStore sharedStore] allItems] count];
    int totalLessThanMaxDollarValue = [[BNRItemStore sharedStore] numOfItemsWithValueGreaterThan:MAX_DOLLAR_VALUE];
    
    if (section == 0) {
        result = totalLessThanMaxDollarValue;
    } else if (section == 1) {
        result = total - totalLessThanMaxDollarValue;
    }
	
	return result + NUM_OF_COMMENT_ROWS;
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
    REMItem *item = nil;
    int row = [indexPath row];
    NSInteger section = [indexPath section];
    NSString *description = STR_NO_MORE_ITEMS;
    
    if (row < [tableView numberOfRowsInSection:section] - NUM_OF_COMMENT_ROWS) {
        if (section == 0) {
            item = [[BNRItemStore sharedStore] itemWithValueGreaterThan:MAX_DOLLAR_VALUE atIndex:row];
        } else if (section == 1) {
            item = [[BNRItemStore sharedStore] itemWithValueLessThanOrEqual:MAX_DOLLAR_VALUE atIndex:row];
        } else {
            NSLog(@"Unknown section %d ", section);
        }
        description = [item description];
    }
        
    [cell.textLabel setText:description];
    
    NSLog(@"Setting cell value for row %d and section %d",
          [indexPath row], [indexPath section]);
	
	return cell;
}

@end

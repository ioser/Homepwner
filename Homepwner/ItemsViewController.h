//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Sara Duckler on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"

@interface ItemsViewController : UITableViewController<UITableViewDataSource>
{
//    IBOutlet UIView *headerView;
}

//- (UIView *)headerView;
- (IBAction)addNewItem:(id)sender;
//- (IBAction)toggleEditingMode:(id)sender;

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)indexPath;

@end

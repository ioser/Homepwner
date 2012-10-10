//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Richard Millet on 8/10/12.
//
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell
@synthesize thumbnailView;
@synthesize nameLabel;
@synthesize serialNumberLabel;
@synthesize valueLabel;

@synthesize itemsViewController;
@synthesize tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 What the heck is this method doing and why?
 */
- (IBAction)showImage:(id)sender {
    // Get the name of this method "showImage"
    NSString *selector = NSStringFromSelector(_cmd); // "_cmd" means the current method
    // Update the selector to include "atIndexPath"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a selector from this NSString instance
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if (indexPath) {
        if ([[self itemsViewController] respondsToSelector:newSelector]) {
            // Ignore the warning that may appear -doesn't matter
            [[self itemsViewController] performSelector:newSelector withObject:sender withObject:indexPath];            
        } else {
            NSLog(@"Selector '%@' is unknown.", selector);
        }
    }

}
@end

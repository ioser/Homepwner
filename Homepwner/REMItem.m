//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Richard Millet on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "REMItem.h"

#define THUMB_WIDTH 40
#define THUMB_HEIGHT 40

@implementation REMItem

// Used as the key to the item's image in the shared image store
@synthesize imageKey;
@synthesize thumbnailImageData;

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",
                                     @"Rusty",
                                     @"Shinny",
                                     nil];
    // Create an array of three nounds
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                               @"Spork",
                               @"Mac",
                               nil];
    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, call the modulo operator, gives
    // you the remainder.  So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    REMItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

- (id)init
{
    self = [super init];
    if (self) {
		dateCreated = [[NSDate alloc] init];
    }
    return self;
}

//
// The designated initializer
//
- (id)initWithItemName:(NSString *)theItemName
        valueInDollars:(int)theValue
          serialNumber:(NSString *)theSerialNumber
{
    self = [self init];
    
	if (self) {
		self.itemName = theItemName;
		self.valueInDollars = theValue;
		self.serialNumber = theSerialNumber;
    }
	
    return self;
}

- (void)dealloc{
	NSLog(@"Destroying a REMItem %@", self);
}

- (id)initWithItemName:(NSString *)theItemName
		  serialNumber:(NSString *)theSerialNumber
{
	self = [self initWithItemName:theItemName valueInDollars:0 serialNumber:theSerialNumber];
	
	return self;
}

@synthesize thumbnailImage;
- (UIImage *)thumbnailImage {
    // If there is no thumbnail data, then we have nothing to return
    if (!thumbnailImageData) {
        return nil;
    }
    
    //
    if (!thumbnailImage) {
        thumbnailImage = [UIImage imageWithData:thumbnailImageData];
    }
    
    return thumbnailImage;
}

@synthesize containedItem;
- (void)setContainedItem:(REMItem *)item;
{
	containedItem = item;
	[item setContainer:self];
}

- (void)setThumbnailImageDataFromImage:(UIImage *)originalImage
{
//    self.thumbnailImage = theThumbnailImage;
    CGSize originalImageSize = [originalImage size];
    
    CGRect thumbRect = CGRectMake(0, 0, THUMB_WIDTH, THUMB_HEIGHT);
    
    // Figure out a scaling ratio to ensure the same aspect ratio
    float ratio = MAX(thumbRect.size.width / originalImageSize.width,
                       thumbRect.size.height / originalImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(thumbRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:thumbRect cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the thumbnail image to the thumbnail size rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * originalImageSize.width;
    projectRect.size.height = ratio * originalImageSize.height;
    projectRect.origin.x = (thumbRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (thumbRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the thumnail image onto the project rectangle
    [originalImage drawInRect:projectRect];
    
    // Extract the image from the image context and keep it as our thumbnail image
    UIImage *theThumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnailImage:theThumbnailImage];
    
    // Now get the PNG representation of the image and set it as our archivable data
    NSData *thumbnailImageData = UIImagePNGRepresentation(theThumbnailImage);
    [self setThumbnailImageData:thumbnailImageData];
    
    // Cleanup/close the image context resources
    UIGraphicsEndImageContext();
}

//
//- (BNRItem *)containedItem
//{
//	return containedItem;
//}

@synthesize container;
//- (void)setContainer:(BNRItem *)item
//{
//	container = item;
//}
//
//- (BNRItem *)container
//{
//	return container;
//}

@synthesize itemName;
//- (void) setItemName:(NSString *)str
//{
//    itemName = str;
//}
//
//- (NSString *) itemName
//{
//    return itemName;
//}

@synthesize serialNumber;
//- (void) setSerialNumber:(NSString *)str
//{
//    serialNumber = str;
//}
//- (NSString *) serialNumber
//{
//    return serialNumber;
//}

@synthesize valueInDollars;
//- (void) setValueInDollars:(int)i
//{
//    valueInDollars = i;
//}
//- (int) valueInDollars
//{
//    return valueInDollars;
//}

@synthesize dateCreated;
//- (NSDate *) dateCreated
//{
//    return dateCreated;
//}

//@Override
- (NSString *) description
{
    return [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", [self itemName], [self serialNumber], [self valueInDollars], [self dateCreated]];
}

- (void)doSomethingWeird
{
	//Intentionally left blank.
}

// NSCoding protocol methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dataCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    [aCoder encodeObject:thumbnailImageData forKey:@"thumbnailImageData"];
    // encode an integer
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setThumbnailImageData:[aDecoder decodeObjectForKey:@"thumbnailImageData"]];
        // decode an integer
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        dateCreated = [aDecoder decodeObjectForKey:@"dataCreated"];
    }
    
    return self;
}
@end

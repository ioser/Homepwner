//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Richard Millet on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REMItem : NSObject<NSCoding>
{
//    NSString *itemName;
//    NSString *serialNumber;
//    int valueInDollars;
//    NSDate *dateCreated;
//	// pg 68
//	BNRItem *containedItem;
//	__weak BNRItem *container;
}

+ (id)randomItem;

@property (nonatomic, strong) REMItem *containedItem;
//- (void)setContainedItem:(BNRItem *)item;
//- (BNRItem *)containedItem;

@property (nonatomic, weak) REMItem *container; // Why is this a weak connection?
//- (void)setContainer:(BNRItem *)item;
//- (BNRItem *)getContainer;

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) NSData *thumbnailImageData;

- (void)setThumbnailImageDataFromImage:(UIImage *)thumbnailImage;

- (void)doSomethingWeird;

//
//The designated initializer
//
- (id)initWithItemName:(NSString *)itemName
        valueInDollars:(int)value
          serialNumber:(NSString *)serialNumber;

- (id)initWithItemName:(NSString *)itemName
		  serialNumber:(NSString *)serialNumber;

//
// Setters and getters for member fields (aka, instance variables)
//

@property (nonatomic, copy) NSString *itemName;
//- (void) setItemName:(NSString *)str;
//- (NSString *) itemName;

@property (nonatomic, strong) NSString *serialNumber;
//- (void) setSerialNumber:(NSString *)str;
//- (NSString *) serialNumber;

@property (nonatomic) int valueInDollars;
//- (void) setValueInDollars:(int)i;
//- (int) valueInDollars;

@property (nonatomic, readonly, strong) NSDate *dateCreated;
//- (NSDate *) dateCreated;

// Property used to keep track of an item's image in the shared image store
@property (nonatomic, copy) NSString *imageKey;

@end

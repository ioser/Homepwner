//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Sara Duckler on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
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

@property (nonatomic, strong) BNRItem *containedItem;
//- (void)setContainedItem:(BNRItem *)item;
//- (BNRItem *)containedItem;

@property (nonatomic, weak) BNRItem *container;
//- (void)setContainer:(BNRItem *)item;
//- (BNRItem *)getContainer;

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
@end

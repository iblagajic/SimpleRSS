// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RSSFeed.m instead.

#import "_RSSFeed.h"

const struct RSSFeedAttributes RSSFeedAttributes = {
	.isInMyFeeds = @"isInMyFeeds",
	.ordinal = @"ordinal",
	.snippet = @"snippet",
	.title = @"title",
	.url = @"url",
};

const struct RSSFeedRelationships RSSFeedRelationships = {
	.items = @"items",
};

const struct RSSFeedFetchedProperties RSSFeedFetchedProperties = {
};

@implementation RSSFeedID
@end

@implementation _RSSFeed

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RSSFeed" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RSSFeed";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RSSFeed" inManagedObjectContext:moc_];
}

- (RSSFeedID*)objectID {
	return (RSSFeedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isInMyFeedsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isInMyFeeds"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"ordinalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ordinal"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic isInMyFeeds;



- (BOOL)isInMyFeedsValue {
	NSNumber *result = [self isInMyFeeds];
	return [result boolValue];
}

- (void)setIsInMyFeedsValue:(BOOL)value_ {
	[self setIsInMyFeeds:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsInMyFeedsValue {
	NSNumber *result = [self primitiveIsInMyFeeds];
	return [result boolValue];
}

- (void)setPrimitiveIsInMyFeedsValue:(BOOL)value_ {
	[self setPrimitiveIsInMyFeeds:[NSNumber numberWithBool:value_]];
}





@dynamic ordinal;



- (int64_t)ordinalValue {
	NSNumber *result = [self ordinal];
	return [result longLongValue];
}

- (void)setOrdinalValue:(int64_t)value_ {
	[self setOrdinal:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveOrdinalValue {
	NSNumber *result = [self primitiveOrdinal];
	return [result longLongValue];
}

- (void)setPrimitiveOrdinalValue:(int64_t)value_ {
	[self setPrimitiveOrdinal:[NSNumber numberWithLongLong:value_]];
}





@dynamic snippet;






@dynamic title;






@dynamic url;






@dynamic items;

	
- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];
  
	[self didAccessValueForKey:@"items"];
	return result;
}
	






@end

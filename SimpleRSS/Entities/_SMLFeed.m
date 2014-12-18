// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMLFeed.m instead.

#import "_SMLFeed.h"

const struct SMLFeedAttributes SMLFeedAttributes = {
	.snippet = @"snippet",
	.title = @"title",
	.url = @"url",
};

const struct SMLFeedRelationships SMLFeedRelationships = {
	.channels = @"channels",
	.items = @"items",
};

const struct SMLFeedFetchedProperties SMLFeedFetchedProperties = {
};

@implementation SMLFeedID
@end

@implementation _SMLFeed

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SMLFeed" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SMLFeed";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SMLFeed" inManagedObjectContext:moc_];
}

- (SMLFeedID*)objectID {
	return (SMLFeedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic snippet;






@dynamic title;






@dynamic url;






@dynamic channels;

	
- (NSMutableSet*)channelsSet {
	[self willAccessValueForKey:@"channels"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"channels"];
  
	[self didAccessValueForKey:@"channels"];
	return result;
}
	

@dynamic items;

	
- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];
  
	[self didAccessValueForKey:@"items"];
	return result;
}
	






@end

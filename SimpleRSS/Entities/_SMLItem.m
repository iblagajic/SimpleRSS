// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMLItem.m instead.

#import "_SMLItem.h"

const struct SMLItemAttributes SMLItemAttributes = {
	.link = @"link",
	.pubDate = @"pubDate",
	.text = @"text",
	.title = @"title",
};

const struct SMLItemRelationships SMLItemRelationships = {
	.feed = @"feed",
};

const struct SMLItemFetchedProperties SMLItemFetchedProperties = {
};

@implementation SMLItemID
@end

@implementation _SMLItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SMLItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SMLItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SMLItem" inManagedObjectContext:moc_];
}

- (SMLItemID*)objectID {
	return (SMLItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic link;






@dynamic pubDate;






@dynamic text;






@dynamic title;






@dynamic feed;

	






@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RSSItem.h instead.

#import <CoreData/CoreData.h>


extern const struct RSSItemAttributes {
	__unsafe_unretained NSString *link;
	__unsafe_unretained NSString *pubDate;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *title;
} RSSItemAttributes;

extern const struct RSSItemRelationships {
	__unsafe_unretained NSString *feed;
} RSSItemRelationships;

extern const struct RSSItemFetchedProperties {
} RSSItemFetchedProperties;

@class RSSFeed;






@interface RSSItemID : NSManagedObjectID {}
@end

@interface _RSSItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RSSItemID*)objectID;





@property (nonatomic, strong) NSString* link;



//- (BOOL)validateLink:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* pubDate;



//- (BOOL)validatePubDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) RSSFeed *feed;

//- (BOOL)validateFeed:(id*)value_ error:(NSError**)error_;





@end

@interface _RSSItem (CoreDataGeneratedAccessors)

@end

@interface _RSSItem (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;




- (NSDate*)primitivePubDate;
- (void)setPrimitivePubDate:(NSDate*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (RSSFeed*)primitiveFeed;
- (void)setPrimitiveFeed:(RSSFeed*)value;


@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMLItem.h instead.

#import <CoreData/CoreData.h>


extern const struct SMLItemAttributes {
	__unsafe_unretained NSString *link;
	__unsafe_unretained NSString *pubDate;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *title;
} SMLItemAttributes;

extern const struct SMLItemRelationships {
	__unsafe_unretained NSString *feed;
} SMLItemRelationships;

extern const struct SMLItemFetchedProperties {
} SMLItemFetchedProperties;

@class SMLFeed;






@interface SMLItemID : NSManagedObjectID {}
@end

@interface _SMLItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SMLItemID*)objectID;





@property (nonatomic, strong) NSString* link;



//- (BOOL)validateLink:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* pubDate;



//- (BOOL)validatePubDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SMLFeed *feed;

//- (BOOL)validateFeed:(id*)value_ error:(NSError**)error_;





@end

@interface _SMLItem (CoreDataGeneratedAccessors)

@end

@interface _SMLItem (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;




- (NSDate*)primitivePubDate;
- (void)setPrimitivePubDate:(NSDate*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (SMLFeed*)primitiveFeed;
- (void)setPrimitiveFeed:(SMLFeed*)value;


@end

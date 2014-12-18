// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMLFeed.h instead.

#import <CoreData/CoreData.h>


extern const struct SMLFeedAttributes {
	__unsafe_unretained NSString *ordinal;
	__unsafe_unretained NSString *snippet;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} SMLFeedAttributes;

extern const struct SMLFeedRelationships {
	__unsafe_unretained NSString *belongsTo;
	__unsafe_unretained NSString *items;
} SMLFeedRelationships;

extern const struct SMLFeedFetchedProperties {
} SMLFeedFetchedProperties;

@class SMLChannel;
@class SMLItem;






@interface SMLFeedID : NSManagedObjectID {}
@end

@interface _SMLFeed : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SMLFeedID*)objectID;





@property (nonatomic, strong) NSNumber* ordinal;



@property int64_t ordinalValue;
- (int64_t)ordinalValue;
- (void)setOrdinalValue:(int64_t)value_;

//- (BOOL)validateOrdinal:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* snippet;



//- (BOOL)validateSnippet:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *belongsTo;

- (NSMutableSet*)belongsToSet;




@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;





@end

@interface _SMLFeed (CoreDataGeneratedAccessors)

- (void)addBelongsTo:(NSSet*)value_;
- (void)removeBelongsTo:(NSSet*)value_;
- (void)addBelongsToObject:(SMLChannel*)value_;
- (void)removeBelongsToObject:(SMLChannel*)value_;

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(SMLItem*)value_;
- (void)removeItemsObject:(SMLItem*)value_;

@end

@interface _SMLFeed (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveOrdinal;
- (void)setPrimitiveOrdinal:(NSNumber*)value;

- (int64_t)primitiveOrdinalValue;
- (void)setPrimitiveOrdinalValue:(int64_t)value_;




- (NSString*)primitiveSnippet;
- (void)setPrimitiveSnippet:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveBelongsTo;
- (void)setPrimitiveBelongsTo:(NSMutableSet*)value;



- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end

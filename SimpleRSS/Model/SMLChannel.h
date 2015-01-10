#import "_SMLChannel.h"

@interface SMLChannel : _SMLChannel {}

+ (SMLChannel*)addChannelWithName:(NSString*)name ordinal:(NSNumber*)ordinal inContext:(NSManagedObjectContext*)context;
+ (NSArray*)channelsInContext:(NSManagedObjectContext*)context;

@end

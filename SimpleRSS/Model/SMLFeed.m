#import "SMLFeed.h"


@interface SMLFeed ()

// Private interface goes here.

@end


@implementation SMLFeed

+ (void)insertFeedWithDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context {
    
    SMLFeed *feed = [SMLFeed insertInManagedObjectContext:context];
    feed.title = [[dictionary objectForKey:@"title"] stringByConvertingHTMLToPlainText];
    feed.url = [dictionary objectForKey:@"url"];
    feed.snippet = [[dictionary objectForKey:@"contentSnippet"] stringByConvertingHTMLToPlainText];
    feed.ordinal = @-1;
}

+ (NSArray*)arrayOfExistingFeedsForTitles:(NSArray*)titles inContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(title IN %@)", titles]];
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    NSError *error;
    NSArray *uniqueTitles = [context executeFetchRequest:fetchRequest error:&error];
    return uniqueTitles;
}

@end

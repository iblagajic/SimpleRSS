#import "RSSFeed.h"

@interface RSSFeed ()

// Private interface goes here.

@end


@implementation RSSFeed

+ (id)feedWithDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context {
    
    RSSFeed *feed = [RSSFeed insertInManagedObjectContext:context];
    feed.title = [[dictionary objectForKey:@"title"] stringByConvertingHTMLToPlainText];
    feed.url = [dictionary objectForKey:@"url"];
    feed.snippet = [[dictionary objectForKey:@"contentSnippet"] stringByConvertingHTMLToPlainText];
    return feed;
}

@end

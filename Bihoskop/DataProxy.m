//
//  DataProxy.m
//  Bihoskop
//
//  Created by Mihailo Gazda on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DataProxy.h"

@implementation DataFilm

- (DataFilm*) initFromArray:(NSArray *)filmovi atIndex:(int)index
{
    NSDictionary *dict = [filmovi objectAtIndex:index];
    return [self initFromDictionary:dict];
}

-(DataFilm*) initFromDictionary:(NSDictionary *)dict
{
    idx = [dict objectForKey:@"idx"];
    naslovSrp = [dict objectForKey:@"naslovSrp"];
    naslovEng = [dict objectForKey:@"naslovEng"];
    zanr = [dict objectForKey:@"zanr"];
    sadrzaj = [dict objectForKey:@"sadrzaj"];
    imdbLink = [dict objectForKey:@"imdbLink"];
    trailerLink = [dict objectForKey:@"trejler"];
    posterLink = [dict objectForKey:@"poster"];
    trajanje = [dict objectForKey:@"trajanje"];
    reziser = [dict objectForKey:@"reziser"];
    imdbOcijena = [dict objectForKey:@"imdbOcjena"];
    glumci = [dict objectForKey:@"glumci"];
    vremenaPrikaza = [dict objectForKey:@"vremenaPrikaza"];
    return self;
}

@end

@implementation DataProxy

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        filmovi = nil;
        rawdata = nil;
        uskoro = nil;
        bioskopi = nil;
    }
    
    return self;
}

- (NSArray*) getFilmovi
{
    return filmovi;
}
-(NSArray*) getUskoro
{
    return uskoro;
}
-(NSDictionary*) getBioskopi
{
    return bioskopi;
}
-(void) disableCache:(bool)value
{
    noCache = value;
}

- (void) filmoviSkinuti:(ASIHTTPRequest *)request
{
    NSLog(@"FIlmovi skinuti");
    NSString *data = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];

    if ([request responseData].length == 0){
        data = [NSString stringWithContentsOfFile:[request downloadDestinationPath] encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Ucitavam cache %@ size :%d", [request downloadDestinationPath], [data length]);
    }
    
    rawdata = [data objectFromJSONString];
    filmovi = [[rawdata objectForKey:@"filmovi"] copy];
    [objekatFilmovi performSelector:selektorFilmovi];
}

- (void) uskoroSkinuto:(ASIHTTPRequest *)request
{
    NSString *data = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    if ([request responseData].length == 0){
        data = [NSString stringWithContentsOfFile:request.downloadDestinationPath encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Ucitavam uskoro cache iz patha %@, size :%d", request.downloadDestinationPath, [data length]);
    }
    
    //  Sad ucitaj data
    rawdata = [data objectFromJSONString];
    
    uskoro = [[rawdata objectForKey:@"filmovi"] copy];
    
    [objekatUskoro performSelector:selektorUskoro];
    NSLog(@"Uskoro skinuto");
}

- (bool) skiniFilmoveZaDatum:(NSDate *)datum
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:datum];
    
    int idxKina = [[NSUserDefaults standardUserDefaults] integerForKey:@"izabranoKino"];
    
    NSString* date = [NSString stringWithFormat:@"%04d-%02d-%02d", components.year, components.month, components.day];
    NSString* formated = [NSString stringWithFormat:REP_URL_FORMAT, idxKina, date];
    NSString* fullUrl = [BASE_URL stringByAppendingString:formated];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSLog(@"Config URL: %@", fullUrl);
    
    //  Ucitaj podatke sa neta ili iz cache-a
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    if (noCache)
        [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    else
        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    NSString* filename = [NSString stringWithFormat:@"%@-%d.dat", date, idxKina];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:filename];
    [request setDownloadDestinationPath:path];
  
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(filmoviSkinuti:)];
    
    //  Sad ucitaj data
    [request startAsynchronous];
    
    return YES;
}

- (bool) skiniDanasnjePodatke: (SEL) selektor withObject:(id) obj
{
    objekatFilmovi = obj;
    selektorFilmovi = selektor;
    
    bool ok = [self skiniFilmoveZaDatum:[NSDate date]];
    //[obj performSelector:selektor];
    return ok;
}

- (bool) ucitajListuBioskopa
{
    NSString* uri = [BASE_URL stringByAppendingString:BIOSKOPI_URL];
    NSURL *url = [NSURL URLWithString: uri];
    //NSString* str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Skidam bioskope sa: %@", uri);
    //NSLog(@"Response: %@", str);
    
    //  Ucitaj podatke sa neta ili iz cache-a
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];

    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"bioskopi.dat"];
    [request setDownloadDestinationPath:path];
    [request startSynchronous];
    
    NSLog(@"Response data: %@", [request responseData]);
    NSLog(@"REsponse: %d", [request responseStatusCode]);

    NSString *data = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    if ([request responseData].length == 0){
        data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Ucitavam bioskop cache iz patha %@, size :%d", path, [data length]);
    }
    
    //  Sad ucitaj data
    //bioskopi = [str objectFromJSONString];
    bioskopi = [data objectFromJSONString];

    //bioskopi = [[rawdata objectForKey:@"bioskopi"] copy];
    return YES;
}

- (bool) skiniUskoroListu: (SEL) selektor withObject:(id) obj
{
    objekatUskoro = obj;
    selektorUskoro = selektor;
    
    int idx = [[[NSUserDefaults standardUserDefaults] objectForKey:@"izabranoKino"] integerValue];
    
    NSString* fullUrl = [BASE_URL stringByAppendingFormat:USKORO_URL_FORMAT, idx];
    NSURL *url = [NSURL URLWithString:fullUrl];
    NSLog(@"Skidam uskoro: %@", url);
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSString* date = [NSString stringWithFormat:@"%04d-%02d-%02d", components.year, components.month, components.day];
    
    int idxKina = [[NSUserDefaults standardUserDefaults] integerForKey:@"izabranoKino"];
    NSString* filename = [NSString stringWithFormat:@"uskoro-%@-%d.dat", date, idxKina];
    
    //  Ucitaj podatke sa neta ili iz cache-a
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:filename];
    [request setDownloadDestinationPath:path];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uskoroSkinuto:)];
    [request startAsynchronous];
    
    return YES;
    
}

@end

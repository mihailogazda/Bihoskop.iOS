//
//  DataProxy.h
//  Bihoskop
//
//  Created by Mihailo Gazda on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONKit/JSONKit.h"
#import "ASIDownloadCache.h"
#import "ASIHTTPRequest.h"

#define BASE_URL            @"http://www.bihoskop.com/data/proxy.php"
#define BIOSKOPI_URL        @"?tip=bioskopi"
#define REP_URL_FORMAT      @"?tip=rep&idx=%d&d=%@"
#define USKORO_URL_FORMAT   @"?idx=%d&tip=uskoro"

@interface DataFilm : NSObject
{
    @public
    NSString *idx;                    //idx
    NSString *naslovSrp;        //naslovSrp
    NSString *naslovEng;        //naslovEng
    NSString *zanr;             //zanr
    NSString *sadrzaj;          //sadrzaj
    NSString *imdbLink;         //imdbLink
    NSString *trailerLink;      //trejler
    NSString *posterLink;       //poster
    NSString *trajanje;         //trajanje
    NSString *reziser;          //reziser
    NSString *imdbOcijena;      //imdbOcjena
    NSString *glumci;           //glumci
    NSArray  *vremenaPrikaza;   //vremenaPrikaza
}

- (DataFilm*) initFromDictionary: (NSDictionary*) dict;
- (DataFilm*) initFromArray: (NSArray*) filmovi atIndex: (int) index;

@end

@interface DataProxy : NSObject
{
    NSDictionary *rawdata;
    
    NSArray *filmovi;
    NSDictionary *bioskopi;
    NSArray *uskoro;
    bool noCache;
    
    id objekatFilmovi;
    id objekatUskoro;
    SEL selektorFilmovi;
    SEL selektorUskoro;
}

- (NSDictionary*) getBioskopi;
- (NSArray*) getFilmovi;
- (NSArray*) getUskoro;
- (void) disableCache:(bool) value;


- (bool) skiniFilmoveZaDatum: (NSDate*) datum ;

- (bool) skiniDanasnjePodatke: (SEL) selektor withObject:(id) obj;
- (bool) skiniUskoroListu: (SEL) selektor withObject:(id) obj;
- (bool) ucitajListuBioskopa;

@end

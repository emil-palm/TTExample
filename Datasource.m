//
//  Example.h
//  
//
//  Created by Science on 31/05/2010.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface Datasource : TTSectionedDataSource {
  Model *m_overviewModel;
}
@property(nonatomic,retain) Model *overviewModel;
@end


@implementation Datasource
@synthesize overviewModel = m_overviewModel;
//----- Datasource init -------
- (id) init {
  if( self = [super init] ) {
		m_overviewModel = [[Model alloc] init];
	}
	return self;
}
//----- Datasource dealloc -------
- (void) dealloc {
	TT_RELEASE_SAFELY(m_overviewModel);
	[super dealloc];
}
//----- Datasource initWithCoder -------
- (id) initWithCoder:(NSCoder *)aCoder {
	self = [[Model alloc] init];
  if( self != nil ) {
		m_overviewModel = [[aCoder decodeObjectForKey:@"m_overviewModel"] retain];
	}
	return self;
}
//----- Datasource encodeWithCoder -------
- (void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:m_overviewModel forKey:@"m_overviewModel"];
}

#pragma mark -
#pragma mark TTModel

- (id<TTModel>) model {
  return m_overviewModel;
}

- (void) tableViewDidLoadModel:(UITableView *)tableView {
  NSMutableArray *sections = [[NSMutableArray alloc] init];
  NSMutableArray *items = [[NSMutableArray alloc] init];
  
  if([m_overviewModel.properties objectForKey:@"monitoring"] != nil) {
    [sections addObject:@"Monitoring"];
    
    NSInteger alerts = [[[m_overviewModel.properties objectForKey:@"monitoring"] objectForKey:@"Alerts"] integerValue];
    NSInteger nodes = [[[m_overviewModel.properties objectForKey:@"monitoring"] objectForKey:@"Nodes"] integerValue];
    
    NSString *text = @"";
    NSString *img = @"";
    NSString *url = nil;
    if(alerts > 0) {
      text = [text stringByAppendingFormat:@"Total %d alerts on %d nodes", alerts, nodes];
      img = @"bundle://bad.png";
      url = @"dcc://monitoring/";
    } else {
      text = @"No alerts reported";
      img = @"bundle://good.png";
    }
    [items addObject:[NSArray arrayWithObject:[TTTableImageItem itemWithText:text imageURL:img URL:url]]];
  }
  
  if([m_overviewModel.properties objectForKey:@"traffic"] != nil) {
    [sections addObject:@"Traffic"];
    NSMutableArray *trafficRows = [[NSMutableArray alloc] initWithCapacity:[[m_overviewModel.properties objectForKey:@"traffic"] count]];
    for(NSString *locationKey in [m_overviewModel.properties objectForKey:@"traffic"]) {
      NSDictionary *locationObject = [[m_overviewModel.properties objectForKey:@"traffic"] objectForKey:locationKey];
      [trafficRows addObject:[TTTableSubtextItem itemWithText:[locationKey capitalizedString]
                                                      caption:[NSString stringWithFormat:@"In: %.1f mbit\nOut: %.1f mbit",[[locationObject objectForKey:@"in"] floatValue],[[locationObject objectForKey:@"out"] floatValue]]
                                                          URL:@"dcc://traffic"]];
    }
    [items addObject:trafficRows];
    
    TT_RELEASE_SAFELY(trafficRows);
  }
  
  
  if([m_overviewModel.properties objectForKey:@"sync"] != nil) {
    [sections addObject:@"Website Sync"];
    NSMutableArray *trafficRows = [[NSMutableArray alloc] initWithCapacity:[[m_overviewModel.properties objectForKey:@"sync"] count]];
    
    NSDictionary *objects = [m_overviewModel.properties objectForKey:@"sync"];
    
    // Timestamp
    
    [trafficRows addObject:[TTTableCaptionItem itemWithText:[objects objectForKey:@"timestamp"] 
                                                    caption:@"Last sync" 
                                                        URL:@"dcc://websitesync"]];
    
    // Complete - Running
    
    if([[objects objectForKey:@"status"] isEqualToString:@"Complete"]) 
      [trafficRows addObject:[TTTableCaptionItem itemWithText:@"Completed"
                                                      caption:@"Status"
                                                          URL:@"dcc://websitesync/info"]];
    else
      [trafficRows addObject:[TTTableCaptionItem itemWithText: [NSString stringWithFormat:@"Running at %d%%",[[objects objectForKey:@"procentageFinished"] integerValue]]
                                                      caption:@"Status"
                                                          URL:@"dcc://websitesync/running"]];
    
    // Failed 
    if([[objects objectForKey:@"failed"] integerValue] > 0) 
      [trafficRows addObject:[TTTableCaptionItem itemWithText: [NSString stringWithFormat:@"%d", [[objects objectForKey:@"failed"] integerValue]]
                                                      caption: @"Failed"
                                                          URL: @"dcc://websitesync/failed"]];
    
    [trafficRows addObject:[TTTableCaptionItem itemWithText:[NSString stringWithFormat:@"%d",[[objects objectForKey:@"completeCount"] integerValue]]
                                                    caption: @"Completed"
                                                        URL:@"dcc://websitesync/completed"]];
    
    
    [items addObject:trafficRows];
    
    TT_RELEASE_SAFELY(trafficRows);
  }
  
  
  
  // CDN Traffic.
  
  
  self.sections = sections;
  self.items = items;
  
  TT_RELEASE_SAFELY(sections);
  TT_RELEASE_SAFELY(items);
}
@end
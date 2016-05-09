//
//  PMODownloadNotifier.h
//  Parallels-test
//
//  Created by Peter Molnar on 09/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

@protocol PMODownloadNotifier <NSObject>

-(void)notifyObserversWithDownloadedData:(NSData *)data;

@end

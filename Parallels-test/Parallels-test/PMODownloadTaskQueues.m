//
//  PMODownloadTaskQueueManager.m
//  PMODownloadManager
//
//  Created by Peter Molnar on 10/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMODownloadTaskQueues.h"

@interface PMODownloadTaskQueues()

@property (strong, nonatomic) NSMutableArray *normalPriorityQueue;
@property (strong, nonatomic) NSMutableArray *highPriorityQueue;


@end

@implementation PMODownloadTaskQueues

#pragma mark - Accessors

- (NSMutableArray *)normalPriorityQueue
{
    if (!_normalPriorityQueue) {
        _normalPriorityQueue = [[NSMutableArray alloc] init];
    }
    
    return _normalPriorityQueue;
}

- (NSMutableArray *)highPriorityQueue
{
    if (!_highPriorityQueue) {
        _highPriorityQueue = [[NSMutableArray alloc] init];
    }
    
    return _highPriorityQueue;
}


#pragma mark - Public interface implementation

- (void)addDownloadTaskToNormalPriorityQueue:(NSURLSessionTask *)task
{
    [self addTask:task toQueue:self.normalPriorityQueue];
}


- (void)removeDownloadTask:(NSURLSessionTask *)task
{
    [self cancelTask:task];
    [self.highPriorityQueue removeObject:task];
    [self.normalPriorityQueue removeObject:task];
    [self resumeQueue:self.normalPriorityQueue];
    
}


- (void)addDownloadTaskToHighPriorityQueue:(NSURLSessionTask *)task
{
    // Look for same task
    task = [self findTask:task inQueue:self.normalPriorityQueue];
    task = [self findTask:task inQueue:self.highPriorityQueue];
    [self removeDownloadTask:task];
    [self.highPriorityQueue addObject:task];
    task.priority = NSURLSessionTaskPriorityHigh;
    [self startTask:task];
    [self suspendQueue:self.normalPriorityQueue];
}

- (void)removeAllTasksFromHighPriorityQueue
{
    [self suspendQueue:self.highPriorityQueue];
    [self resetPrioritiesInQueue:self.highPriorityQueue];
    [self moveAllTasksFromQueue:self.highPriorityQueue toQueue:self.normalPriorityQueue];
    [self resumeQueue:self.normalPriorityQueue];
    
}


- (void)cleanQueues {
    
    [self cleanQueue:self.normalPriorityQueue];
    [self cleanQueue:self.highPriorityQueue];
    
}

#pragma mark - Private functions

- (BOOL)isHighPriorityQueueEmpty
{
    [self cleanQueues];
    if (self.highPriorityQueue.count == 0) {
        return true;
    } else {
        return false;
    }
    
}

- (NSURLSessionTask *) addTask: (NSURLSessionTask *)task toQueue: (NSMutableArray *)queue
{
    [queue addObject:task];
    [self resumeQueue:queue];
    return task;
}

- (NSURLSessionTask *)findTask:(NSURLSessionTask *)task inQueue:(NSMutableArray *)queue
{
    NSURLSessionTask *resultTask = task;
    for (NSURLSessionTask *currentTask in queue) {
        if ([currentTask.currentRequest.URL isEqual:task.currentRequest.URL]) {
            // Previous task has been found, cancel it and return with the original task
            [task cancel];
            resultTask = currentTask;
            break;
        }
    }
    
    return resultTask;
}


#pragma mark - Queue operations

-(BOOL)isQueueCanBeStarted: (NSMutableArray *)queue {
    if (([queue isEqual:self.normalPriorityQueue] && [self isHighPriorityQueueEmpty]) || [queue isEqual:self.highPriorityQueue]) {
        return true;
    } else {
        return false;
    }
}

- (void)suspendQueue: (NSMutableArray *)queue
{
    [self cleanQueues];
    for (NSURLSessionTask *currentTask in queue) {
        [self suspendTask:currentTask];
    }
}

- (void)resumeQueue: (NSMutableArray *)queue
{
    [self cleanQueues];
    if ([self isQueueCanBeStarted:queue]) {
        for (NSURLSessionTask *currentTask in queue) {
            [self startTask:currentTask];
        }
    }
    
}

- (void)cancelQueue: (NSMutableArray *)queue
{
    for (NSURLSessionTask *currentTask in queue) {
        [self cancelTask:currentTask];
    }
    [self cleanQueues];

}

-(void)cleanQueue: (NSMutableArray *)queue {
    
    for (NSURLSessionTask *task in queue) {
        if (task.state == NSURLSessionTaskStateCompleted || task.state == NSURLSessionTaskStateCanceling) {
            [self removeDownloadTask:task];
        }
    }
}

- (void)resetPrioritiesInQueue: (NSMutableArray *)queue
{
    for (NSURLSessionTask *task in queue) {
        [self changeTaskPriorityToNormal:task];
        
    }
    
}

-(void)moveAllTasksFromQueue: (NSMutableArray *)sourceQueue toQueue: (NSMutableArray *)destinationQueue
{
    for (NSURLSessionTask *task in sourceQueue) {
        [self changeTaskPriorityToNormal:task];
        
    }
}



#pragma mark - Task state manipulation

- (void)startTask:(NSURLSessionTask *)task
{
    if (self.isDebug) {
        NSLog(@"Task started: %@",task.currentRequest.URL);
    }
    [task resume];
    
}

- (void)suspendTask: (NSURLSessionTask *)task
{
    if (self.isDebug) {
        NSLog(@"Task suspended: %@",task.currentRequest.URL);
    }
    [task suspend];
}

- (void)cancelTask: (NSURLSessionTask *)task
{
    if (self.isDebug) {
        NSLog(@"Task cancelled: %@",task.currentRequest.URL);
    }
    [task cancel];
}


-(void)changeTaskPriorityToNormal: (NSURLSessionTask *)task {
    task.priority = NSURLSessionTaskPriorityDefault;
}

@end

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

- (NSMutableArray *)highPriorityQueue {
    
    if (!_highPriorityQueue) {
        _highPriorityQueue = [[NSMutableArray alloc] init];
    }
    
    return _highPriorityQueue;
}

- (NSUInteger)normalQueueTaskCount {
    
    return [self.normalPriorityQueue count];
}

- (NSUInteger)priorityQueueTaskCount {
    
    return [self.highPriorityQueue count];
}

#pragma mark - Public interface implementation

- (void)addDownloadTaskToNormalPriorityQueue:(NSURLSessionTask *)task {
    
    NSURLSessionTask *exisitingTask = [self findTaskInAllQueues:task];
    if (exisitingTask) {
        task = exisitingTask;
        [self moveTask:task fromQueue:self.highPriorityQueue
               toQueue:self.normalPriorityQueue
          withPRiority:NSURLSessionTaskPriorityDefault];
    } else {
        [self addTask:task toQueue:self.normalPriorityQueue];
    }

    if ([self isQueueCanBeStarted:self.normalPriorityQueue]) {
        [self resumeQueue:self.normalPriorityQueue];
    }
}

- (void)addDownloadTaskToHighPriorityQueue:(NSURLSessionTask *)task {
    
    NSURLSessionTask *exisitingTask = [self findTaskInAllQueues:task];
    if (exisitingTask) {
        task = exisitingTask;
        [self moveTask:task fromQueue:self.normalPriorityQueue
               toQueue:self.highPriorityQueue
          withPRiority:NSURLSessionTaskPriorityHigh];
    } else {
        [self addTask:task toQueue:self.highPriorityQueue];
        task.priority = NSURLSessionTaskPriorityHigh;
    }

    [self suspendQueue:self.normalPriorityQueue];
    [self resumeQueue:self.highPriorityQueue];

}


- (void)removeDownloadTask:(NSURLSessionTask *)task fromQueue:(NSMutableArray *)queue {
    
    [queue removeObject:task];
    
}

- (void)removeDownloadTaskFromAllQueues:(NSURLSessionTask *)task {
    
    NSURLSessionTask *exisitingtask = [self findTaskInAllQueues:task];
    if (exisitingtask) {
        [self removeDownloadTask:task fromQueue:self.normalPriorityQueue];
        [self removeDownloadTask:task fromQueue:self.highPriorityQueue];
    }
    
}


- (void)changeDownloadTaskToHighPriorityQueueFromURL:(NSURL *)downloadURL {
    
    NSURLSessionTask *foundTask = [self findTaskByURL:downloadURL inQueue:self.normalPriorityQueue];
    if (foundTask) {
        [self addDownloadTaskToHighPriorityQueue:foundTask];
    }
}

- (void)changeDownloadTaskToNormalPriorityQueueFromURL:(NSURL *)downloadURL {

    NSURLSessionTask *foundTask = [self findTaskByURL:downloadURL inQueue:self.highPriorityQueue];
    if (foundTask) {
        [self addDownloadTaskToNormalPriorityQueue:foundTask];
    }

}

- (void)removeAllTasksFromHighPriorityQueue {
    
    [self suspendQueue:self.highPriorityQueue];
    [self resetPrioritiesInQueue:self.highPriorityQueue];
    [self moveAllTasksFromQueue:self.highPriorityQueue toQueue:self.normalPriorityQueue withPriority:NSURLSessionTaskPriorityDefault];
    [self resumeQueue:self.normalPriorityQueue];
    
}


- (void)cleanQueues {
    
    [self cleanupTheQueue:self.normalPriorityQueue];
    [self cleanupTheQueue:self.highPriorityQueue];
    
}

#pragma mark - Private functions

- (BOOL)isHighPriorityQueueEmpty {
    [self cleanQueues];
    if (self.highPriorityQueue.count == 0) {
        return true;
    } else {
        return false;
    }
    
}

- (BOOL)isQueueCanBeStarted:(NSMutableArray *)queue {
    if (([queue isEqual:self.normalPriorityQueue] && [self isHighPriorityQueueEmpty]) || [queue isEqual:self.highPriorityQueue]) {
        return true;
    } else {
        return false;
    }
}

- (NSURLSessionTask *)addTask:(NSURLSessionTask *)task toQueue: (NSMutableArray *)queue {
    [queue addObject:task];
    return task;
}

// Search for a task by URL in a given queue
- (NSURLSessionTask *)findTaskByURL:(NSURL *)url inQueue:(NSMutableArray *)queue {
    for (NSURLSessionTask *currentTask in queue) {
        if ([currentTask.currentRequest.URL isEqual:url]) {
            return currentTask;
            break;
        }
    }
    return nil;
}

// Search for a task in a given queue
- (NSURLSessionTask *)findTask:(NSURLSessionTask *)task inQueue:(NSMutableArray *)queue {
    
    NSURLSessionTask *foundTaskByURL = [self findTaskByURL:task.currentRequest.URL inQueue:queue];
    if (foundTaskByURL) {
        return foundTaskByURL;
    } else {
        return nil;
    }
}

// Search for a task in all queues
- (NSURLSessionTask *)findTaskInAllQueues:(NSURLSessionTask *)task {
    return [self findTask:task inQueue:self.normalPriorityQueue] ? [self findTask:task inQueue:self.normalPriorityQueue] : [self findTask:task inQueue:self.highPriorityQueue];
}



#pragma mark - Queue operations

- (void)suspendQueue:(NSMutableArray *)queue
{
    [self cleanupTheQueue:queue];
    for (NSURLSessionTask *currentTask in queue) {
        [self suspendTask:currentTask];
    }
}

- (void)resumeQueue:(NSMutableArray *)queue {
    [self cleanupTheQueue:queue];
    if ([self isQueueCanBeStarted:queue]) {
        for (NSURLSessionTask *currentTask in queue) {
            [self startTask:currentTask];
        }
    }
    
}

- (void)cancelQueue:(NSMutableArray *)queue {
    for (NSURLSessionTask *currentTask in queue) {
        [self cancelTask:currentTask];
    }
    [self cleanupTheQueue:queue];
    
}

- (void)cleanupTheQueue:(NSMutableArray *)queue {
    
    for (NSURLSessionTask *task in queue) {
        if (task.state == NSURLSessionTaskStateCompleted || task.state == NSURLSessionTaskStateCanceling) {
            [self removeDownloadTask:task fromQueue:queue];
        }
    }
}

- (void)resetPrioritiesInQueue:(NSMutableArray *)queue {
    
    for (NSURLSessionTask *task in queue) {
        task.priority = NSURLSessionTaskPriorityDefault;
    }
    
}

- (void)moveTask:(NSURLSessionTask *)task fromQueue:(NSMutableArray *)sourceQueue toQueue:(NSMutableArray *)destinationQueue withPRiority:(float)priority {
    
    [self suspendTask:task];
    if ([destinationQueue indexOfObject:task] == NSNotFound) {
        [destinationQueue addObject:task];
    }
    if ([sourceQueue indexOfObject:task] != NSNotFound) {
        [sourceQueue removeObject:task];
    }
    [task setPriority:priority];
    if ([self isQueueCanBeStarted:destinationQueue]) {
        [self startTask:task];
    }
    
}


- (void)moveAllTasksFromQueue:(NSMutableArray *)sourceQueue toQueue:(NSMutableArray *)destinationQueue withPriority:(float)priority {
    
    NSURLSessionTask *currTask = [sourceQueue firstObject];
    while (currTask) {
        [self moveTask:currTask fromQueue:sourceQueue toQueue:destinationQueue withPRiority:priority];
        currTask = [sourceQueue firstObject];
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

- (void)suspendTask:(NSURLSessionTask *)task
{
    if (self.isDebug) {
        NSLog(@"Task suspended: %@",task.currentRequest.URL);
    }
    [task suspend];
}

- (void)cancelTask:(NSURLSessionTask *)task
{
    if (self.isDebug) {
        NSLog(@"Task cancelled: %@",task.currentRequest.URL);
    }
    [task cancel];
}



@end

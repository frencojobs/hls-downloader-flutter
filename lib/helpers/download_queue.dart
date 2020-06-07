// just got this download queue idea
// download queue would be similar to the idea of `event loop`
// download queue is a queue of download functions
// these download functions leave queue when they are complete
// executor is like a stack that execute these functions

// [dfn1, dfn2, dfn3]
// step 1. take dfn1 and put it in executor
// step 2. executor wait for dfn1 *completed* output
// step 3. removes dfn1 from queue

// dfns: download functions
// dfns download asynchronously and update db
// dfns returns completed output whether download is successful or not
// dfn handles error state and remove downloading element from db

// execution should work on an isolate
import 'dart:async';
import 'dart:collection';

typedef Dfn = Future Function();

class DownloadQueue {
  static Queue<Dfn> queue = Queue();
  static final _controller = StreamController()..sink.add(queue);

  static void add(Dfn value) {
    queue.add(value);
    // execute();
    _controller.sink.add(queue);
  }

  static Stream load() {
    return _controller.stream;
  }

  static Future<void> execute(Queue q) async {
    for (Dfn dfn in q) {
      await dfn();
    }
    // clear the queue
    queue.clear();
  }
}

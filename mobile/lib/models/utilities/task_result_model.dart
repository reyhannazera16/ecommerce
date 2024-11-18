class TaskResult<T> {
  T? result;
  int? elapsedTime;
  bool? isError;
  String? message;

  TaskResult({this.result, this.elapsedTime, this.isError, this.message});
}

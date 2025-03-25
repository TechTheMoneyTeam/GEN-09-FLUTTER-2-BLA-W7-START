class AsyncValue<T> {
  final T? data;
  final Object? error;
  final bool isLoading;

  AsyncValue.loading() : isLoading = true, data = null, error = null;
  AsyncValue.success(T data) : isLoading = false, data = data, error = null;
  AsyncValue.error(Object error) : isLoading = false, data = null, error = error;
}

/// @Created by akash on 15-09-2025.
/// Know more about author at https://akash.cloudemy.in
sealed class UiState<T> {
  const UiState._();

  /// Factory constructors
  factory UiState.success(T data) = _Success<T>;
  factory UiState.error(String msg) = _Error<T>;
  factory UiState.loading() = _Loading<T>;
  factory UiState.none() = _None<T>;

/*  T? getDataOrNull2() {
    if (this is _Success<T>) {
      return (this as _Success<T>)._data;
    }
    return null;
  }*/
  /// Getters
  T? getDataOrNull() => this.isSuccess ? (this as _Success<T>)._data : null;
  String? getErrorOrNull() => this is _Error<T> ? (this as _Error<T>)._msg : null;

  /// Type checks
  bool get isSuccess => this is _Success<T>;
  bool get isError => this is _Error<T>;
  bool get isLoading => this is _Loading<T>;

  /// Pattern matching
  R when<R>({
    required R Function() none,
    required R Function() loading,
    required R Function(String msg) error,
    required R Function(T data) success,



  }) {
    if (this is _Success<T>) {
      return success((this as _Success<T>)._data);
    } else if (this is _Error<T>) {
      return error((this as _Error<T>)._msg);
    } else if (this is _Loading<T>) {
      return loading();
    } else /*if (this is _None<T>)*/ {
      return none();
    }
  }
}

/// Private implementations
class _Success<T> extends UiState<T> {
  final T _data;
  const _Success(this._data) : super._();
}

class _Error<T> extends UiState<T> {
  final String _msg;
  const _Error(this._msg) : super._();
}

class _Loading<T> extends UiState<T> {
  const _Loading() : super._();
}

class _None<T> extends UiState<T> {
  const _None() : super._();
}

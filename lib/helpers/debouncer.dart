import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829

// Voy a recibir algun tipo de dato a la hora de crear la instancia
// En este caso manejare un stream
class Debouncer<T> {
  Debouncer(
      {
      // Duration es la cantidad de tiempo antes de omitir un valor
      required this.duration,
      // Metodo que voy a disparar cuando se obtenga un valor
      this.onValue});

  final Duration duration;

  void Function(T value)? onValue;

  T? _value;
  // El timer es una funcion de control que viene en dart
  Timer? _timer;

  T get value => _value!;

  set value(T val) {
    // Entonces si recibimos un valor el timer se cancela
    //Y si el timer cumple la duracion llamamos la funcion
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue!(_value!));
  }
}

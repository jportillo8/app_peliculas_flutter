import 'package:flutter/material.dart';
import 'package:peliculas_flutter/providers/movies_provider.dart';
import 'package:peliculas_flutter/screens/screens.dart';
import 'package:provider/provider.dart';

// EL AppState es el primer widget que se va a crear
// Despues de ese widget voy a tener acceso a la instancia del movies provider
void main() => runApp(AppState());

// Con esta clase monitorearemos el estado de la aplicacion
// El estado del provider se ve aca
class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Con esto creamos la primera instancia del Provider
        // con el lazy en false garantizamos que la instacia ya este creada
        // para que se pueda inicializar la instancia
        ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false)
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(),
        'details': (_) => DetailsScreen(),
      },
      theme: ThemeData.light()
          .copyWith(appBarTheme: AppBarTheme(color: Colors.indigo)),
    );
  }
}

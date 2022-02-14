# weather_app

This is a project that consume [openweathermap.org](https://openweathermap.org/) API for fetching weather data.

all you need is to get an appKey from their website and change it in config.dart file.
## Features

User can do the following

- View weather for his current location
- Select and search for city from malaysia cities
- User will see current and forecasted weather for the selected city

## Used Technologies

### State managment
I used Cubit to manage app state with BlocProvider and MultiBlocProvider.

Cubit is a subset of Bloc Pattern, that stores and observe state, it has less boilerplate code comparing to the normal Bloc.


### Networking
I've used retrofit to handle network calls, with json_serializable, retrofit_generator, and build_runner
to manage and generate the boilerplate code to handel coding and encoding json responses.

### Local storage and cache
For storing city list I used shared_preferences, it's not the best soluation to use for storing models and complex struction in local storage, I used it just because it's faster to integrate, 
other solution I would consider is using [Hive](https://pub.dev/packages/hive) which will provide a lightweight and fast key-value database.

I've used memory cache for caching city weathers and forecast so user will not see loader all the time and will see the last updated value before getting the latest value from api.


### Testing
I build part of the code using TDD, with more time I would get the whole app covered with testing.
I've used mocktail and bloc_test to test Cubits.
mocktail provide a simple mocking with null safety support.
bloc_test will help us test Cubit and listen to states changes.

### Locate user location
I've used geolocator to get user current location.


import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia_app/core/network/network_info.dart';

class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockInternetConnectionChecker mockInternetConnectionChecker;

  group(('isConnected'), () {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);

    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        final tHasConnectionFuture = Future.value(true);

        when(() => mockInternetConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);

        final result = networkInfoImpl.isConnected;

        verify(() => mockInternetConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}

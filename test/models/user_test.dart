import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User model should convert to/from JSON with all fields', () {
      final user = User(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );

      final json = user.toJson();
      final fromJsonUser = User.fromJson(json);

      expect(fromJsonUser.id, equals('123'));
      expect(fromJsonUser.name, equals('Test User'));
      expect(fromJsonUser.email, equals('test@example.com'));
      expect(fromJsonUser.password, equals('password123'));
    });

    test('Empty JSON should throw error', () {
      expect(() => User.fromJson({}), throwsA(isA<Error>()));
    });

    test('Partial JSON should throw error', () {
      expect(
        () => User.fromJson({'id': '1', 'name': 'Test'}),
        throwsA(isA<Error>()),
      );
    });
  });
}

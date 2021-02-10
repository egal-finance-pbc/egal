import 'package:dio/dio.dart';
import 'package:conellas/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

@RestApi(baseUrl: 'https://602338e56bf3e6001766ae35.mockapi.io/api/')
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/users')
  Future<List<UserModel>> findAll();

  @GET('/users/{id}')
  Future<UserModel> findById(@Path('id') String  id);

  @POST('/users')
  Future<void> save(@Body() UserModel user);

}
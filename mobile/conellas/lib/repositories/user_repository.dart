import 'package:dio/dio.dart';
import 'package:conellas/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

@RestApi(baseUrl: '')
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/users')
  Future<List<UserModel>> findAll();

  @GET('/users/{id}')
  Future<UserModel> findById(@Path('id') int id);

  @POST('/users')
  Future<void> save(@Body() UserModel user);

}
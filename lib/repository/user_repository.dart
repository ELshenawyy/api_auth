import 'package:dartz/dartz.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api_consumer.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/get_user_data_model.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/sign_up_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../cache/cache_helper.dart';
import '../core/end_points.dart';
import '../core/errors/exceptions.dart';
import '../core/functions/upload_image_to_api.dart';
import '../models/sign_in_model.dart';

class UserRepository {
  final ApiConsumer apiConsumer;

  UserRepository({required this.apiConsumer});

  Future<Either<String, SignInModel>> signIn(
      {required String email, required String password}) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.signIn,
        data: {
          ApiKey.email: email,
          ApiKey.password: password,
        },
      );
      final user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user.token);
      CacheHelper().saveData(key: ApiKey.token, value: user.token);
      CacheHelper().saveData(key: ApiKey.id, value: decodedToken[ApiKey.id]);
      return Right(user);
    } on ServerExceptions catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, SignUpModel>> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required XFile profilePic,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.signup,
        isFormData: true,
        data: {
          ApiKey.name: name,
          ApiKey.phone: phone,
          ApiKey.email: email,
          ApiKey.password: password,
          ApiKey.confirmPassword: confirmPassword,
          ApiKey.location:
          '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}',
          ApiKey.profilePic: await uploadImageToAPI(profilePic),
        },
      );
      final signUpModel = SignUpModel.fromJson(response);
      return Right(signUpModel);
    } on ServerExceptions catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, UserModel>> getUserData() async
  {
    try {
      final response = await apiConsumer.get(
        EndPoints.getUserData(
          CacheHelper().getData(key: ApiKey.id),
        ),
      );
      return Right(response);
    } on ServerExceptions catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }
}



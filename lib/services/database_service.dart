import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/utilities/constans.dart';

class DatabaseService {

  static void updateUser(User user){
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImgUrl': user.profileImgUrl,
      'bio': user.bio,
    });
  }

}
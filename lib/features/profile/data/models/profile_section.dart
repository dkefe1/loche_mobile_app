import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/profile/data/models/profile.dart';

class ProfileSection{
  final Profile profile;
  final List<Advertisement> ads;

  ProfileSection({required this.profile, required this.ads});
}
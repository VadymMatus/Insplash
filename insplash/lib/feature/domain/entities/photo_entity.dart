import 'package:equatable/equatable.dart';

class PhotoEntity extends Equatable {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String color;
  final String altDescription;
  final String blurHash;
  final bool likedByUser;
  final int width;
  final int height;
  final int likes;
  final LinksEntity links;
  final SponsorshipEntity? sponsorship;
  final UrlsEntity urls;
  final UserEntity user;

  const PhotoEntity(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.color,
      required this.altDescription,
      required this.likedByUser,
      required this.width,
      required this.height,
      required this.likes,
      required this.links,
      required this.blurHash,
      this.sponsorship,
      required this.urls,
      required this.user});

  @override
  List<Object> get props => [id];
}

class LinksEntity extends Equatable {
  final String self;
  final String html;
  final String photos;
  final String likes;
  final String portfolio;
  final String following;
  final String followers;

  const LinksEntity(
      {required this.self,
      required this.html,
      required this.photos,
      required this.likes,
      required this.portfolio,
      required this.following,
      required this.followers});

  @override
  List<Object?> get props =>
      [self, html, photos, likes, portfolio, following, followers];
}

class SponsorshipEntity extends Equatable {
  final String impressionsId;
  final String tagline;
  final SponsorEntity sponsor;
  final List<String> impressionUrls;

  const SponsorshipEntity(
      {required this.impressionsId,
      required this.tagline,
      required this.sponsor,
      required this.impressionUrls});

  @override
  List<Object?> get props => [impressionsId, tagline, sponsor, impressionUrls];
}

class UrlsEntity extends Equatable {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  const UrlsEntity(
      {required this.raw,
      required this.full,
      required this.regular,
      required this.small,
      required this.thumb});

  @override
  List<Object?> get props => [raw, full, regular, small, thumb];
}

class UserEntity extends Equatable {
  final String id;
  final String updatedAt;
  final String username;
  final String name;
  final String firstName;
  final String lastName;
  final String twitterUsername;
  final String portfolioUrl;
  final String bio;
  final String instagramUsername;
  final bool acceptedTos;
  final int totalCollections;
  final int totalLikes;
  final int totalPhotos;
  final LinksEntity links;
  final ProfileImageEntity profileImage;

  const UserEntity(
      {required this.id,
      required this.updatedAt,
      required this.username,
      required this.name,
      required this.firstName,
      required this.lastName,
      required this.twitterUsername,
      required this.portfolioUrl,
      required this.bio,
      required this.instagramUsername,
      required this.acceptedTos,
      required this.totalCollections,
      required this.totalLikes,
      required this.totalPhotos,
      required this.links,
      required this.profileImage});

  @override
  List<Object?> get props => [
        id,
        updatedAt,
        username,
        name,
        firstName,
        lastName,
        twitterUsername,
        portfolioUrl,
        bio,
        instagramUsername,
        acceptedTos,
        totalCollections,
        totalLikes,
        totalPhotos,
        links,
        profileImage
      ];
}

class SponsorEntity extends Equatable {
  final String id;
  final String updatedAt;
  final String username;
  final String name;
  final String firstName;
  final String lastName;
  final String twitterUsername;
  final String portfolioUrl;
  final String bio;
  final String instagramUsername;
  final bool acceptedTos;
  final int totalCollections;
  final int totalLikes;
  final int totalPhotos;
  final LinksEntity links;
  final ProfileImageEntity profileImage;

  const SponsorEntity(
      {required this.id,
      required this.updatedAt,
      required this.username,
      required this.name,
      required this.firstName,
      required this.lastName,
      required this.twitterUsername,
      required this.portfolioUrl,
      required this.bio,
      required this.instagramUsername,
      required this.acceptedTos,
      required this.totalCollections,
      required this.totalLikes,
      required this.totalPhotos,
      required this.links,
      required this.profileImage});

  @override
  List<Object?> get props => [
        id,
        updatedAt,
        username,
        name,
        firstName,
        lastName,
        twitterUsername,
        portfolioUrl,
        bio,
        instagramUsername,
        acceptedTos,
        totalCollections,
        totalLikes,
        totalPhotos,
        links,
        profileImage
      ];
}

class ProfileImageEntity extends Equatable {
  final String small;
  final String medium;
  final String large;

  const ProfileImageEntity(
      {required this.small, required this.medium, required this.large});

  @override
  List<Object?> get props => [small, medium, large];
}

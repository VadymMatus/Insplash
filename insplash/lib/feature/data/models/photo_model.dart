import 'package:logger/logger.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';

var logger = Logger();

class PhotoListResponse {
  final List<PhotoModel> results;

  PhotoListResponse(this.results);

  factory PhotoListResponse.fromJsonArray(List json) {
    var result = <PhotoModel>[];
    json.forEach((element) {
      try {
        result.add(PhotoModel.fromJson(element));
      } catch (e, s) {}
    });

    return PhotoListResponse(result);
  }
}

class PhotoModel extends PhotoEntity {
  const PhotoModel(
      {required id,
      required createdAt,
      required updatedAt,
      required color,
      required altDescription,
      required blurHash,
      required likedByUser,
      required width,
      required height,
      required likes,
      required links,
      required sponsorship,
      required urls,
      required user})
      : super(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            color: color,
            altDescription: altDescription,
            likedByUser: likedByUser,
            blurHash: blurHash,
            width: width,
            height: height,
            likes: likes,
            links: links,
            sponsorship: sponsorship,
            urls: urls,
            user: user);

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
        id: json["id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        blurHash: json["blur_hash"] ?? "",
        color: json["color"],
        altDescription: json["alt_description"] ?? "No description",
        likedByUser: json["liked_by_user"],
        width: json["width"] ?? 0,
        height: json["height"] ?? 0,
        likes: json["likes"],
        links:
            json['links'] != null ? LinksModel.fromJson(json['links']) : null,
        sponsorship: null,
        //json['sponsorship'] != null ? SponsorshipModel.fromJson(json['sponsorship']) : null,
        urls: json['urls'] != null ? UrlsModel.fromJson(json['urls']) : null,
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['color'] = color;
    data['alt_description'] = altDescription;
    data['liked_by_user'] = likedByUser;
    data['width'] = width;
    data['height'] = height;
    data['likes'] = likes;
    data['links'] = links;
    data['sponsorship'] = sponsorship;
    data['urls'] = urls;
    data['user'] = user;
    return data;
  }
}

class LinksModel extends LinksEntity {
  const LinksModel(
      {required super.self,
      required super.html,
      required super.photos,
      required super.likes,
      required super.portfolio,
      required super.following,
      required super.followers});

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(
        self: json["self"] ?? "",
        html: json["html"] ?? "",
        photos: json["photos"] ?? "",
        likes: json["likes"] ?? "",
        portfolio: json["portfolio"] ?? "",
        following: json["following"] ?? "",
        followers: json["followers"] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = self;
    data['html'] = html;
    data['photos'] = photos;
    data['likes'] = likes;
    data['portfolio'] = portfolio;
    data['following'] = following;
    data['followers'] = followers;
    return data;
  }
}

class SponsorshipModel extends SponsorshipEntity {
  const SponsorshipModel(
      {required impressionsId,
      required tagline,
      required sponsor,
      required impressionUrls})
      : super(
            impressionsId: impressionsId,
            tagline: tagline,
            sponsor: sponsor,
            impressionUrls: impressionUrls);

  factory SponsorshipModel.fromJson(Map<String, dynamic> json) {
    return SponsorshipModel(
      impressionsId: json['impressions_id'],
      tagline: json['tagline'],
      sponsor: json['sponsor'] != null
          ? SponsorModel.fromJson(json['sponsor'])
          : null,
      impressionUrls: (json['impression_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['impressions_id'] = impressionsId;
    data['tagline'] = tagline;
    data['sponsor'] = sponsor;
    data['impression_urls'] = impressionUrls;
    return data;
  }
}

class UrlsModel extends UrlsEntity {
  const UrlsModel(
      {required super.raw,
      required super.full,
      required super.regular,
      required super.small,
      required super.thumb});

  factory UrlsModel.fromJson(Map<String, dynamic> json) {
    return UrlsModel(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['raw'] = raw;
    data['full'] = full;
    data['regular'] = regular;
    data['small'] = small;
    data['thumb'] = thumb;
    return data;
  }
}

class UserModel extends UserEntity {
  const UserModel(
      {required id,
      required updatedAt,
      required username,
      required name,
      required firstName,
      required lastName,
      required twitterUsername,
      required portfolioUrl,
      required bio,
      required instagramUsername,
      required acceptedTos,
      required totalCollections,
      required totalLikes,
      required totalPhotos,
      required links,
      required profileImage})
      : super(
            id: id,
            updatedAt: updatedAt,
            username: username,
            name: name,
            firstName: firstName,
            lastName: lastName,
            twitterUsername: twitterUsername,
            portfolioUrl: portfolioUrl,
            bio: bio,
            instagramUsername: instagramUsername,
            acceptedTos: acceptedTos,
            totalCollections: totalCollections,
            totalLikes: totalLikes,
            totalPhotos: totalPhotos,
            links: links,
            profileImage: profileImage);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"],
        updatedAt: json["updated_at"],
        username: json["username"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"] ?? "",
        twitterUsername: json["social"]["twitter_username"] ?? "",
        portfolioUrl: json["social"]["portfolio_url"] ?? "",
        bio: json["bio"] ?? "",
        instagramUsername: json["social"]["instagram_username"] ?? "",
        acceptedTos: json["accepted_tos"],
        totalCollections: json["total_collections"],
        totalLikes: json["total_likes"],
        totalPhotos: json["total_photos"],
        links:
            json['links'] != null ? LinksModel.fromJson(json['links']) : null,
        profileImage: json['profile_image'] != null
            ? ProfileImageModel.fromJson(json['profile_image'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['updated_at'] = updatedAt;
    data['username'] = username;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['twitter_username'] = twitterUsername;
    data['portfolio_url'] = portfolioUrl;
    data['bio'] = bio;
    data['instagram_username'] = instagramUsername;
    data['accepted_tos'] = acceptedTos;
    data['total_collections'] = totalCollections;
    data['total_likes'] = totalLikes;
    data['total_photos'] = totalPhotos;
    data['links'] = links;
    data['profile_image'] = profileImage;
    return data;
  }
}

class SponsorModel extends SponsorEntity {
  const SponsorModel(
      {required id,
      required updatedAt,
      required username,
      required name,
      required firstName,
      required lastName,
      required twitterUsername,
      required portfolioUrl,
      required bio,
      required instagramUsername,
      required acceptedTos,
      required totalCollections,
      required totalLikes,
      required totalPhotos,
      required links,
      required profileImage})
      : super(
            id: id,
            updatedAt: updatedAt,
            username: username,
            name: name,
            firstName: firstName,
            lastName: lastName,
            twitterUsername: twitterUsername,
            portfolioUrl: portfolioUrl,
            bio: bio,
            instagramUsername: instagramUsername,
            acceptedTos: acceptedTos,
            totalCollections: totalCollections,
            totalLikes: totalLikes,
            totalPhotos: totalPhotos,
            links: links,
            profileImage: profileImage);

  factory SponsorModel.fromJson(Map<String, dynamic> json) {
    return SponsorModel(
        id: json['id'],
        updatedAt: json['updated_at'],
        username: json['username'],
        name: json['name'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        twitterUsername: json['twitter_username'],
        portfolioUrl: json['portfolio_url'],
        bio: json['bio'],
        instagramUsername: json['instagram_username'],
        acceptedTos: json['accepted_tos'],
        totalCollections: json['total_collections'],
        totalLikes: json['total_likes'],
        totalPhotos: json['total_photos'],
        links:
            json['links'] != null ? LinksModel.fromJson(json['links']) : null,
        profileImage: json['profile_image'] != null
            ? ProfileImageModel.fromJson(json['profile_image'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['updated_at'] = updatedAt;
    data['username'] = username;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['twitter_username'] = twitterUsername;
    data['portfolio_url'] = portfolioUrl;
    data['bio'] = bio;
    data['instagram_username'] = instagramUsername;
    data['accepted_tos'] = acceptedTos;
    data['total_collections'] = totalCollections;
    data['total_likes'] = totalLikes;
    data['total_photos'] = totalPhotos;
    data['links'] = links;
    data['profile_image'] = profileImage;
    return data;
  }
}

class ProfileImageModel extends ProfileImageEntity {
  const ProfileImageModel(
      {required super.small, required super.medium, required super.large});

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) {
    return ProfileImageModel(
        small: json['small'] ?? "",
        medium: json['medium'] ?? "",
        large: json['large'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    return data;
  }
}

part of 'banner_bloc.dart';

@immutable
sealed class BannerEvent {}

final class FetchBannerEvent extends BannerEvent{}

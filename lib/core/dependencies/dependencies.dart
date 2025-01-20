import 'package:get_it/get_it.dart';
import 'package:ordering_app/core/common/cubits/cubit/auth_cubit.dart';
import 'package:ordering_app/core/utils/cached_web_service.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/core/utils/web_service.dart';
import 'package:ordering_app/features/about/data/data_sources/about_remote_data_source.dart';
import 'package:ordering_app/features/about/data/repositories/about_repository_impl.dart';
import 'package:ordering_app/features/about/domain/repositories/about_repository.dart';
import 'package:ordering_app/features/about/domain/use_cases/fetch_info.dart';
import 'package:ordering_app/features/about/presentation/blocs/info/info_bloc.dart';
import 'package:ordering_app/features/address_book/data/data_sources/address_book_remote_data_source.dart';
import 'package:ordering_app/features/address_book/data/repositories/address_book_repository_impl.dart';
import 'package:ordering_app/features/address_book/domain/repositories/address_book_repository.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/delete_address.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/fetch_address_list.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/fetch_country_list.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/fetch_zone_list.dart';
import 'package:ordering_app/features/address_book/domain/use_cases/save_address.dart';
import 'package:ordering_app/features/address_book/presentation/blocs/address_book/address_book_bloc.dart';
import 'package:ordering_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:ordering_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ordering_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ordering_app/features/auth/domain/use_cases/delete_account.dart';
import 'package:ordering_app/features/auth/domain/use_cases/fetch_login_info.dart';
import 'package:ordering_app/features/auth/domain/use_cases/forgot_password.dart';
import 'package:ordering_app/features/auth/domain/use_cases/login.dart';
import 'package:ordering_app/features/auth/domain/use_cases/logout.dart';
import 'package:ordering_app/features/auth/domain/use_cases/register.dart';
import 'package:ordering_app/features/auth/domain/use_cases/reset_password.dart';
import 'package:ordering_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ordering_app/features/checkout/data/data_sources/cart_remote_data_source.dart';
import 'package:ordering_app/features/checkout/data/repositories/cart_repository_impl.dart';
import 'package:ordering_app/features/checkout/domain/repositories/cart_repository.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/apply_coupon.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/apply_reward.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/apply_voucher.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_cart.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_checkout_summary.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/remove_coupon.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/remove_item.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/remove_reward.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/remove_voucher.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/update_cart.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/checkout/data/data_sources/checkout_remote_data_source.dart';
import 'package:ordering_app/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/confirm_order.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_payment_methods.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_shipping_methods.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/set_payment_method.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/set_shipping_address.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/set_shipping_method.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/checkout/checkout_bloc.dart';
import 'package:ordering_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:ordering_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:ordering_app/features/home/domain/repositories/home_repository.dart';
import 'package:ordering_app/features/home/domain/use_cases/fetch_featured_products.dart';
import 'package:ordering_app/features/home/domain/use_cases/fetch_home_banners.dart';
import 'package:ordering_app/features/home/presentation/blocs/banner/banner_bloc.dart';
import 'package:ordering_app/features/home/presentation/blocs/featured_products/featured_products_bloc.dart';
import 'package:ordering_app/features/menu/data/data_sources/menu_local_data_source.dart';
import 'package:ordering_app/features/menu/data/data_sources/menu_remote_data_source.dart';
import 'package:ordering_app/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:ordering_app/features/menu/domain/repositories/menu_repository.dart';
import 'package:ordering_app/features/menu/domain/use_cases/add_to_cart.dart';
import 'package:ordering_app/features/menu/domain/use_cases/fetch_categories.dart';
import 'package:ordering_app/features/menu/domain/use_cases/fetch_products.dart';
import 'package:ordering_app/features/menu/presentation/blocs/menu/menu_bloc.dart';
import 'package:ordering_app/features/splash/data/data_sources/splash_local_data_source.dart';
import 'package:ordering_app/features/splash/data/data_sources/splash_remote_data_source.dart';
import 'package:ordering_app/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:ordering_app/features/splash/domain/repositories/splash_repository.dart';
import 'package:ordering_app/features/splash/domain/use_cases/fetch_menu.dart';
import 'package:ordering_app/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:ordering_app/features/theme/data/data_sources/theme_local_data_source.dart';
import 'package:ordering_app/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:ordering_app/features/theme/domain/repositories/theme_repository.dart';
import 'package:ordering_app/features/theme/domain/use_cases/fetch_theme.dart';
import 'package:ordering_app/features/theme/domain/use_cases/save_theme.dart';
import 'package:ordering_app/features/theme/presentation/bloc/theme_bloc.dart';



part 'dependencies_main.dart';

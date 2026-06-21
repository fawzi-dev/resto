import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/network/api_client.dart';
import '../core/network/api_config.dart';
import '../features/menu/data/datasources/menu_remote_data_source.dart';
import '../features/menu/data/repositories/menu_repository_impl.dart';
import '../features/menu/domain/repositories/menu_repository.dart';
import '../features/menu/presentation/view_models/menu_view_model.dart';

// The whole dependency graph in one spot. The data source is the only thing
// that changes between offline (fake) and live (HTTP) — everything above it is
// identical. Toggle with --dart-define=USE_REMOTE_API=true.
List<SingleChildWidget> buildAppProviders() {
  return [
    Provider<MenuRemoteDataSource>(
      create: (_) => ApiConfig.useRemoteApi
          ? HttpMenuRemoteDataSource(ApiClient(baseUrl: ApiConfig.baseUrl))
          : FakeMenuRemoteDataSource(),
    ),
    ProxyProvider<MenuRemoteDataSource, MenuRepository>(
      update: (_, remote, __) => MenuRepositoryImpl(remote),
    ),
    ChangeNotifierProvider<MenuViewModel>(
      create: (context) => MenuViewModel(context.read<MenuRepository>())..load(),
    ),
  ];
}

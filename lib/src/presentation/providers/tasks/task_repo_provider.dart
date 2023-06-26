import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infractrusture/infractrusture.dart';

final taskRepoProvider =
    Provider((ref) => TaskRepositoryImpl(IsarDatasource()));

import '../datasources/wiki_remote_datasource.dart';
import '../models/wiki_summary.dart';

class WikiRepository {
  WikiRepository(this._remote);

  final WikiRemoteDataSource _remote;

  Future<WikiSummary?> getCraftBeerSummary() => _remote.fetchCraftBeerSummary();
}

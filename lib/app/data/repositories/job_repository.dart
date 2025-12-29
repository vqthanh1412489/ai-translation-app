import '../models/job.dart';
import '../providers/storage_provider.dart';

class JobRepository {
  final StorageProvider _storageProvider;

  JobRepository(this._storageProvider);

  Future<void> saveJob(Job job) async {
    await _storageProvider.saveJob(job);
  }

  List<Job> listJobs() {
    return _storageProvider.listJobs();
  }

  Job? getJob(String id) {
    return _storageProvider.getJob(id);
  }

  Future<void> deleteJob(String id) async {
    await _storageProvider.deleteJob(id);
  }
}

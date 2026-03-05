import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_directory/models/listing.dart';

final listingServiceProvider = Provider<ListingService>((ref) => ListingService());

final listingsProvider = StreamProvider<List<Listing>>((ref) {
  return ref.watch(listingServiceProvider).getListings();
});

class ListingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Listing>> getListings() {
    return _firestore.collection('listings').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList();
    });
  }

  Future<void> createListing(Listing listing) {
    return _firestore.collection('listings').add(listing.toMap());
  }

  Future<void> updateListing(Listing listing) {
    return _firestore.collection('listings').doc(listing.id).update(listing.toMap());
  }

  Future<void> deleteListing(String listingId) {
    return _firestore.collection('listings').doc(listingId).delete();
  }
}

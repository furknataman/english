import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseProvider extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  static const Set<String> _productIds = {
    'vocapp_support_small',
    'vocapp_support_medium',
    'vocapp_support_large',
  };

  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _loading = true;
  String? _error;

  // Purchase callbacks
  Function(String productId)? onPurchaseSuccess;
  Function(String error)? onPurchaseError;

  // Getters
  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;
  bool get loading => _loading;
  String? get error => _error;

  /// Initialize the store connection, query products, listen to purchase stream
  Future<void> initStore() async {
    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      if (!_isAvailable) {
        _loading = false;
        notifyListeners();
        return;
      }

      // Listen to purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _listenToPurchaseUpdated,
        onDone: () => _subscription.cancel(),
        onError: (error) => debugPrint('Purchase stream error: $error'),
      );

      // Query products
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_productIds);

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }

      if (response.error != null) {
        _error = response.error!.message;
      }

      _products = response.productDetails;
      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
      debugPrint('Error initializing store: $e');
    }
  }

  /// Buy a consumable product (donation)
  Future<bool> buyProduct(ProductDetails product) async {
    try {
      if (!_isAvailable) return false;

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      return await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Error buying product: $e');
      return false;
    }
  }

  /// Handle purchase stream updates
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // Pending - do nothing, UI can show loading
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      onPurchaseError
          ?.call(purchaseDetails.error?.message ?? 'Bilinmeyen hata');
    } else if (purchaseDetails.status == PurchaseStatus.purchased) {
      // Consumable donation - just notify success
      onPurchaseSuccess?.call(purchaseDetails.productID);
    }

    // Complete the purchase
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  /// Get product by ID
  ProductDetails? getProductById(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/urls.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' show Client;

class ProductDetailService {
  Client client = Client();

  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await client.post(Uri.parse("$BASEURL/api/add-to-cart"),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": userProvider.user.token,
          },
          body: jsonEncode({
            "id": product.id,
          }));

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            User user = userProvider.user
                .copyWith(cart: jsonDecode(response.body)["cart"]);
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void rateProduct(
      {required BuildContext context,
      required Product product,
      required double rating}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await client.post(Uri.parse("$BASEURL/api/rate-product"),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": userProvider.user.token,
          },
          body: jsonEncode({
            "id": product.id,
            "rating": rating,
          }));

      httpErrorHandle(response: response, context: context, onSuccess: () {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

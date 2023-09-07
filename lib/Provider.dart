import 'package:flutter/material.dart';


class ProviderClass extends ChangeNotifier {
   String vehicleType='two wheeler';
   int index = 0;

   int first = 0;
   int second = 1;
   int third = 2;

   void swapWithFirst(int tappedIndex) {
      if (tappedIndex == second || tappedIndex == third) {
         final temp = first;
         first = tappedIndex;
         if (tappedIndex == second) {
            second = temp;
         } else {
            third = temp;
         }

         notifyListeners();
      }
   }

}
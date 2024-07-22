import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class QuickAlerts {
  static void showErrorAlert(BuildContext context, String title, String text,
      void Function() onConfirm) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.error,
      title: title,
      text: text,
      confirmBtnTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      confirmBtnColor: Theme.of(context).colorScheme.tertiary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      textColor: Theme.of(context).colorScheme.primary,
      titleColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        onConfirm();
      },
    );
  }

  static void showLoadingAlert(
      BuildContext context, String title, String text) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      barrierDismissible: false,
      title: title,
      text: text,
      confirmBtnTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      confirmBtnColor: Theme.of(context).colorScheme.tertiary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      textColor: Theme.of(context).colorScheme.primary,
      titleColor: Theme.of(context).colorScheme.primary,
    );
  }

  static void showSuccessAlert(BuildContext context, String title, String text,
      void Function() onConfirm) {
    QuickAlert.show(
        context: context,
        barrierDismissible: false,
        type: QuickAlertType.success,
        title: title,
        text: text,
        confirmBtnTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        confirmBtnColor: Theme.of(context).colorScheme.tertiary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        textColor: Theme.of(context).colorScheme.primary,
        titleColor: Theme.of(context).colorScheme.primary,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          onConfirm();
        });
  }
}

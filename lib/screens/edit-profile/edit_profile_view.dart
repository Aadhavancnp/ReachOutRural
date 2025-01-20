import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/screens/edit-profile/cubit/editprofile_cubit.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/utils/toast.dart';
import 'package:reach_out_rural/widgets/default_icon_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final toaster = ToastHelper(context);

    return BlocConsumer<EditprofileCubit, EditprofileState>(
        listener: (context, state) {
      toaster.cancelAllCustomToast();
      if (state.status.isFailure && state.errorMsg.isNotEmpty) {
        toaster.showErrorCustomToastWithIcon(state.errorMsg);
      }
      if (state.status.isSuccess) {
        toaster.showSuccessCustomToastWithIcon(l10n.proflie_update_success);
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.edit_profile),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTextField(
                  context,
                  l10n.name,
                  (value) =>
                      context.read<EditprofileCubit>().nameChanged(value)),
              const SizedBox(height: 20),
              _buildTextField(
                  context,
                  l10n.email,
                  (value) =>
                      context.read<EditprofileCubit>().emailChanged(value)),
              const SizedBox(height: 20),
              _buildTextField(
                  context,
                  l10n.phone,
                  (value) =>
                      context.read<EditprofileCubit>().phoneChanged(value)),
              const SizedBox(height: 20),
              _buildAgeField(context, l10n),
              const SizedBox(height: 20),
              _buildTextField(
                  context,
                  l10n.location,
                  (value) =>
                      context.read<EditprofileCubit>().locationChanged(value)),
              const SizedBox(height: 20),
              _buildSaveButton(context, l10n),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTextField(
      BuildContext context, String label, Function(String) onChanged) {
    return BlocBuilder<EditprofileCubit, EditprofileState>(
      buildWhen: (previous, current) =>
          _shouldRebuild(previous, current, label),
      builder: (context, state) {
        final value = _getValueForField(state, label);
        return TextField(
          controller: TextEditingController(text: value)
            ..selection =
                TextSelection.fromPosition(TextPosition(offset: value.length)),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      },
    );
  }

  Widget _buildAgeField(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<EditprofileCubit, EditprofileState>(
      buildWhen: (previous, current) => previous.age != current.age,
      builder: (context, state) {
        return TextField(
          controller: TextEditingController(text: state.age.value.toString())
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: state.age.value.toString().length)),
          textInputAction: TextInputAction.done,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) => context
              .read<EditprofileCubit>()
              .ageChanged(int.tryParse(value) ?? 0),
          decoration: InputDecoration(
            labelText: l10n.age,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          keyboardType: TextInputType.number,
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<EditprofileCubit, EditprofileState>(
      buildWhen: (previous, current) => previous.isValid != current.isValid,
      builder: (context, state) {
        return DefaultIconButton(
          width: SizeConfig.getProportionateScreenWidth(320),
          height: SizeConfig.getProportionateScreenHeight(60),
          fontSize: SizeConfig.getProportionateTextSize(20),
          text: l10n.save,
          icon: Iconsax.tick_square,
          press: state.isValid
              ? () => context.read<EditprofileCubit>().updateProfile()
              : () {},
        );
      },
    );
  }

  bool _shouldRebuild(
      EditprofileState previous, EditprofileState current, String field) {
    switch (field) {
      case 'Name':
        return previous.name != current.name;
      case 'Email':
        return previous.email != current.email;
      case 'Phone':
        return previous.phone != current.phone;
      case 'Location':
        return previous.location != current.location;
      default:
        return false;
    }
  }

  String _getValueForField(EditprofileState state, String field) {
    switch (field) {
      case 'Name':
        return state.name.value;
      case 'Email':
        return state.email.value;
      case 'Phone':
        return state.phone.value;
      case 'Location':
        return state.location.value;
      default:
        return '';
    }
  }
}

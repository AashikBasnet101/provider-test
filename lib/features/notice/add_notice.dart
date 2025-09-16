import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/core/constants/app_color.dart';
import 'package:provider_test/core/constants/app_string.dart';
import 'package:provider_test/core/utils/helper.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/provider/notice_provider.dart';
import 'package:provider_test/features/widgets/custom_dropdown.dart';
import 'package:provider_test/features/widgets/custom_elevatedbutton.dart';
import 'package:provider_test/features/widgets/custom_snackbar.dart';
import 'package:provider_test/features/widgets/custom_textformfield.dart';

class AddNoticeScreen extends StatefulWidget {
  const AddNoticeScreen({super.key});

  @override
  State<AddNoticeScreen> createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final noticeProvider = context.read<NoticeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Notice")),
      body: Stack(
        children: [
          Container(
            color: primaryColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: secondaryColor,
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Title
                      CustomTextform(
                        labelText: titleLabel,
                        prefixIcon: const Icon(Icons.title),
                        validator: noticeProvider.titleValidator,
                        onChanged: (val) => noticeProvider.title = val,
                      ),

                      const SizedBox(height: 16),

                      // File ID
                      CustomTextform(
                        labelText: fileIdLabel,
                        prefixIcon: const Icon(Icons.insert_drive_file),
                        onChanged: (val) => noticeProvider.fileId = val,
                      ),

                      const SizedBox(height: 16),

                      // Priority Dropdown
                      DropDown(
                        labelText: priorityLabel,
                        items: priorities,
                        value: noticeProvider.priority,
                        onChanged: (val) => noticeProvider.setPriority(val),
                        validator: noticeProvider.priorityValidator,
                      ),

                      const SizedBox(height: 16),

                      // Category Dropdown
                      DropDown(
                        labelText: categoryLabel,
                        items: categories,
                        value: noticeProvider.category,
                        onChanged: (val) => noticeProvider.setCategory(val),
                        validator: noticeProvider.categoryValidator,
                      ),

                      const SizedBox(height: 16),

                      // Target Audience Multi-Select (custom)
                      DropDown(
                        labelText: targetAudienceLabel,
                        items: audiences,
                        value: noticeProvider.targetAudience.isNotEmpty
                            ? noticeProvider.targetAudience.join(", ")
                            : null,
                        onChanged: (val) {
                          noticeProvider.setTargetAudience(
                            val?.split(", ") ?? [],
                          );
                        },
                        validator: noticeProvider.targetAudienceValidator,
                      ),

                      const SizedBox(height: 20),

                      // Submit Button
                      CustomElevatedButton(
                        backgroundColor: primaryColor,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await noticeProvider.createNotice();

                            if (noticeProvider.createStatus ==
                                ViewState.success) {
                              displaySnackBar(context, noticeCreatedSuccess);
                            } else if (noticeProvider.createStatus ==
                                ViewState.error) {
                              displaySnackBar(context, noticeCreatedFailed);
                            }
                          }
                        },
                        child: Text(submitLabel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          noticeProvider.createStatus == ViewState.loading
              ? backdropFilter(context)
              : const SizedBox(),
        ],
      ),
    );
  }
}

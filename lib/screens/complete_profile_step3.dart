import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/fields.dart';

class CompleteProfileStep3 extends StatefulWidget {
  @override
  _CompleteProfileStep3State createState() => _CompleteProfileStep3State();
}

class _CompleteProfileStep3State extends State<CompleteProfileStep3> {
  String? selectedCountry;
  int? selectedCountryId;
  String? selectedCity;
  int? selectedCityId;

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.fetchCountriesAndCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileHeader(),
            SizedBox(height: 8),
            ProfileDescription(text: "Choose your first destination!"),
            SizedBox(height: 86),

            // Country Dropdown
            CustomDropdownField(
              label: "Country",
              value: selectedCountry,
              options: provider.countries.map((c) => c['name'] as String).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                  selectedCountryId = provider.countries.firstWhere((c) => c['name'] == value)['id'];
                  selectedCity = null; // Reset city when country changes
                });
              },
            ),
            SizedBox(height: 16),

            // City Dropdown
            CustomDropdownField(
              label: "City",
              value: selectedCity,
              options: selectedCountryId != null
                  ? provider.getCitiesByCountry(selectedCountryId!).map((c) => c['name'] as String).toList()
                  : [],
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  selectedCityId = provider.cities.firstWhere((c) => c['name'] == value)['id'];
                });
              },
            ),
            SizedBox(height: 24),

            // Dates of Visit
            DatePickerField(
              label: "From Date",
              controller: fromDateController,
              onDateSelected: () {},
              initialDate: DateTime.now(),
              lastDate: DateTime(2030, 1, 1),
            ),
            SizedBox(height: 16),

            DatePickerField(
              label: "To Date",
              controller: toDateController,
              onDateSelected: () {},
              initialDate: DateTime.now(),
              lastDate: DateTime(2030, 1, 1),
            ),
            Spacer(),

            SubmitButton(
              text: "Create an account",
              isEnabled: selectedCountryId != null && selectedCityId != null,
              onPressed: selectedCountryId != null && selectedCityId != null
                  ? () async {
                final provider = Provider.of<ProfileProvider>(context, listen: false);

                provider.updateProfileStep3(
                  country: selectedCountry!,
                  countryId: selectedCountryId!,
                  city: selectedCity!,
                  cityId: selectedCityId!,
                  fromDate: fromDateController.text,
                  toDate: toDateController.text,
                );

                await provider.saveProfileData(); // Отправляем данные на сервер

                Navigator.pushNamed(context, '/match'); // Переход на следующий экран
              }
                  : null,
            ),
            SizedBox(height: 16),
            ProfileProgressIndicator(step: 3),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

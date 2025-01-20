import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/hospital.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchHospitalsScreen extends StatefulWidget {
  const SearchHospitalsScreen({super.key, required this.hospitals});
  final List<Hospital> hospitals;

  @override
  State<SearchHospitalsScreen> createState() => _SearchHospitalsScreenState();
}

class _SearchHospitalsScreenState extends State<SearchHospitalsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Hospital> _filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _filteredHospitals = widget.hospitals;
  }

  void _filterHospitals(String query) {
    setState(() {
      _filteredHospitals = widget.hospitals
          .where((hospital) =>
              (hospital.name.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.search_nearby_hospitals,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: kGreyColor),
                  labelText:
                      AppLocalizations.of(context)!.search_for_nearby_hospitals,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(color: kBlackColor),
                onChanged: _filterHospitals,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredHospitals.length,
                itemBuilder: (context, index) {
                  final hospital = _filteredHospitals[index];
                  return ListTile(
                    title: Text(hospital.name),
                    onTap: () {
                      // Handle doctor selection
                      // For example, navigate to a doctor detail page
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

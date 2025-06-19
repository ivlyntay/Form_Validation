import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

void main() => runApp(MaterialApp(home: FormValidationDemo()));

class FormValidationDemo extends StatefulWidget {
  @override
  _FormValidationDemoState createState() => _FormValidationDemoState();
}

class _FormValidationDemoState extends State<FormValidationDemo> {
  final _formKey = GlobalKey<FormState>();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  String? fullName;
  String? dob;
  String? selectedGender;
  double familyMembers = 8;
  int rating = 0;
  int stepperValue = 10;
  bool agreedToTerms = false;

  List<String> genders = ['Male', 'Female', 'Other'];
  Map<String, bool> languages = {
    'English': false,
    'Hindi': false,
    'Other': false,
  };

  void _resetForm() {
    _formKey.currentState?.reset();
    _signatureController.clear();
    setState(() {
      fullName = null;
      dob = null;
      selectedGender = null;
      familyMembers = 8;
      rating = 0;
      stepperValue = 10;
      agreedToTerms = false;
      languages.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Form Validation",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              TextFormField(
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "This field cannot be empty." : null,
                onSaved: (value) => fullName = value,
              ),
              SizedBox(height: 16),

              // Date of Birth
              TextFormField(
                decoration: InputDecoration(labelText: "Date of Birth"),
                validator: (value) =>
                    value == null || value.isEmpty ? "This field cannot be empty." : null,
                onSaved: (value) => dob = value,
              ),
              SizedBox(height: 16),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Gender"),
                items: genders
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
                validator: (value) => value == null ? "This field cannot be empty." : null,
                onChanged: (value) => selectedGender = value,
              ),
              SizedBox(height: 16),

              // Age
              TextFormField(
                decoration: InputDecoration(labelText: "Age"),
                validator: (value) =>
                    value == null || value.isEmpty ? "This field cannot be empty." : null,
                onSaved: (value) => dob = value,
              ),
              SizedBox(height: 16),

              // Number of Family Members (Slider)
              Text("Number of Family Members"),
              Slider(
                value: familyMembers,
                min: 0,
                max: 10,
                divisions: 10,
                label: familyMembers.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    familyMembers = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Rating
              Text("Rating"),
              Wrap(
                spacing: 10,
                children: List.generate(
                  5,
                  (index) => ChoiceChip(
                    label: Text('${index + 1}'),
                    selected: rating == index + 1,
                    selectedColor: Colors.purple.shade100,
                    onSelected: (_) {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Stepper
              Text("Stepper"),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (stepperValue > 0) stepperValue--;
                      });
                    },
                  ),
                  Text(
                    stepperValue.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        stepperValue++;
                      });
                    },
                  ),
                ],
              ),
              Container(
                height: 1,
                color: const Color.fromARGB(255, 160, 160, 160),
              ),
              SizedBox(height: 16),

              // Languages you know (checkboxes)
              Text("Languages you know"),
              ...languages.entries.map((entry) {
                return CheckboxListTile(
                  title: Text(entry.key),
                  value: entry.value,
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (val) {
                    setState(() {
                      languages[entry.key] = val ?? false;
                    });
                  },
                );
              }).toList(),
              SizedBox(height: 16),

              // Signature
              Text("Signature", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(border: Border.all()),
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _signatureController.clear();
                    },
                    icon: Icon(Icons.clear, color: Colors.red),
                    label: Text("Clear", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Container(
                height: 1,
                color: const Color.fromARGB(255, 160, 160, 160),
              ),
              SizedBox(height: 16),

              // Star Rating
              Text("Rate this site"),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < rating ? Colors.purple : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),

              Container(
                height: 1,
                color: const Color.fromARGB(255, 160, 160, 160),
              ),
              SizedBox(height: 16),

              // Terms & Conditions
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("I have read and agree to the terms and conditions"),
                value: agreedToTerms,
                onChanged: (value) {
                  setState(() {
                    agreedToTerms = value ?? false;
                  });
                },
              ),
              if (!agreedToTerms)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "You must accept terms and conditions to continue",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 16),

              // Submit & Reset Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && agreedToTerms) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Form submitted successfully")),
                        );
                      }
                    },
                    child: Text("Submit", style: TextStyle(color: Colors.white)),
                  ),
                  OutlinedButton(
                    onPressed: _resetForm,
                    child: Text("Reset"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

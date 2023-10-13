import 'package:flutter/material.dart';

class AppointmentForm extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;

  AppointmentForm({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  @override
  _AppointmentFormState createState() => _AppointmentFormState(
    userId: userId,
    userName: userName,
    userEmail: userEmail,
  );
}

class _AppointmentFormState extends State<AppointmentForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final String userId;
  final String userName;
  final String userEmail;

  _AppointmentFormState({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    // Add your validation logic here
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      // Display an error message or prevent form submission
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              controller: stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextFormField(
              controller: zipController,
              decoration: InputDecoration(labelText: 'Zip'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_validateForm()) {
                  final firstName = firstNameController.text;
                  final lastName = lastNameController.text;
                  final phone = phoneController.text;
                  final email = emailController.text;
                  final description = descriptionController.text;
                  final city = cityController.text;
                  final state = stateController.text;
                  final zip = zipController.text;

                  final appointmentData = {
                    'userId': userId,
                    'userName': userName,
                    'userEmail': userEmail,
                    'firstName': firstName,
                    'lastName': lastName,
                    'phone': phone,
                    'email': email,
                    'description': description,
                    'city': city,
                    'state': state,
                    'zip': zip,
                    // Include other appointment data as needed
                  };

                  // Simulate a successful appointment booking (replace with actual logic)
                  _bookAppointment(appointmentData);
                } else {
                  // Display an error message or prevent submission
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _bookAppointment(Map<String, dynamic> appointmentData) async {
    // Simulate a delay for demonstration purposes (remove this in your actual code)
    await Future.delayed(Duration(seconds: 2));

    // Simulate a successful appointment booking (remove this in your actual code)
    // You can handle booking failure if needed
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointment Booked'),
          content: Text('Your appointment has been successfully booked.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

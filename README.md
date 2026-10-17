SplitSmart – Dart Expense Splitter

About the Project

SplitSmart is a console-based expense-sharing application developed using Dart. It helps a group of people track shared expenses, calculate individual shares, and determine who owes money or should receive money.

This project demonstrates core Dart programming concepts such as classes, functions, collections, enums, input validation, and exception handling.

Features

- Member Management: Add group members with unique IDs and names.
- Expense Tracking: Record expenses with a title, amount, payer, category, and participants.
- Equal Expense Splitting: Divide expenses equally among selected participants.
- Expense Listing: Display all recorded expenses and their details.
- Member Filtering: Find expenses involving a particular member.
- Category Filtering: Filter expenses by categories such as food, travel, and shopping.
- Balance Calculation: Calculate total paid, individual share, and net balance for each member.
- Input Validation: Handle invalid amounts, duplicate members, unknown members, and invalid categories.
- Exception Handling: Display meaningful error messages for invalid operations.

Technologies Used

- Programming Language: Dart
- Code Editor: Visual Studio Code
- Application Type: Command-line application
- External Packages: None required

Project Structure

SplitSmart/
├── main.dart
└── README.md

Prerequisites

Before running the project, make sure you have:

- Dart SDK installed on your computer.
- Visual Studio Code or another code editor.
- A terminal or command prompt.

Check your Dart installation using:

dart --version

How to Run

1. Download or clone this repository.
2. Open the project folder in Visual Studio Code.
3. Open the terminal.
4. Run the following command:

dart run main.dart

5. View the expense details, filters, and calculated balances in the terminal.

Example Scenario

Suppose three members share a dinner expense of INR 900.

Member| Amount Paid| Individual Share| Net Balance
Asha| INR 900| INR 300| +INR 600
Ravi| INR 0| INR 300| -INR 300
Neha| INR 0| INR 300| -INR 300

Asha should receive INR 600, while Ravi and Neha should each pay INR 300.

A positive net balance means the member should receive money. A negative net balance means the member owes money.

Learning Outcomes

Through this project, the following concepts are demonstrated:

- Object-oriented programming using classes and objects.
- Managing data using lists and maps.
- Using enums for expense categories.
- Implementing reusable methods and functions.
- Validating data and handling exceptions.
- Applying basic financial calculations and problem-solving techniques.

Future Improvements

- Interactive menu-driven input.
- Edit and delete expenses.
- Settlement suggestions between members.
- Persistent storage using files or a database.
- A Flutter-based graphical user interface.

Author

Developed as an academic application development assignment using Dart.

License

This project is created for educational purposes.

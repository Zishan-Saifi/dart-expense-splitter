enum ExpenseCategory {
  food,
  travel,
  shopping,
  bills,
  entertainment,
  other,
}

// 1. MEMBER CLASS
class Member {
  final String id;
  final String name;

  Member({required this.id, required this.name});
}

// 2. EXPENSE CLASS
class Expense {
  final String title;
  final int amount;
  final String paidBy;
  final ExpenseCategory category;
  final List<String> splitBetween;

  Expense({
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.category,
    required this.splitBetween,
  });
}

// 3. EXPENSE GROUP CLASS
class ExpenseGroup {
  final List<Member> _members = [];
  final List<Expense> _expenses = [];

  int _nextId = 1;

  // Add a member with a unique name and ID.
  void addMember(String name) {
    name = name.trim();

    if (name.isEmpty) {
      throw ArgumentError('Member name cannot be empty.');
    }

    for (final member in _members) {
      if (member.name.toLowerCase() == name.toLowerCase()) {
        throw ArgumentError('Member already exists: $name');
      }
    }

    final id = 'M${_nextId.toString().padLeft(3, '0')}';

    _members.add(Member(id: id, name: name));
    _nextId++;

    print('Member added: $name (ID: $id)');
  }

  // Find a member by name or ID.
  Member _findMember(String nameOrId) {
    for (final member in _members) {
      if (member.name.toLowerCase() == nameOrId.toLowerCase() ||
          member.id.toLowerCase() == nameOrId.toLowerCase()) {
        return member;
      }
    }

    throw ArgumentError('Unknown member: $nameOrId');
  }

  // Convert category text to an enum.
  ExpenseCategory _parseCategory(String category) {
    for (final item in ExpenseCategory.values) {
      if (item.name.toLowerCase() == category.trim().toLowerCase()) {
        return item;
      }
    }

    throw ArgumentError('Invalid category: $category');
  }

  // 4. ADD EXPENSE
  void addExpense({
    required String title,
    required int amount,
    required String paidBy,
    required String category,
    required List<String> splitBetween,
  }) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Expense title cannot be empty.');
    }

    if (amount <= 0) {
      throw ArgumentError('Amount must be positive.');
    }

    if (splitBetween.isEmpty) {
      throw ArgumentError('At least one participant is required.');
    }

    final payer = _findMember(paidBy);
    final selectedMembers = <Member>[];
    final selectedIds = <String>{};

    for (final name in splitBetween) {
      final member = _findMember(name);

      if (!selectedIds.add(member.id)) {
        throw ArgumentError('Duplicate participant: ${member.name}');
      }

      selectedMembers.add(member);
    }

    if (amount % selectedMembers.length != 0) {
      throw ArgumentError(
        'Amount must divide evenly among participants '
        'in the basic version.',
      );
    }

    final expense = Expense(
      title: title.trim(),
      amount: amount,
      paidBy: payer.id,
      category: _parseCategory(category),
      splitBetween: selectedMembers.map((m) => m.id).toList(),
    );

    _expenses.add(expense);

    print('Expense added: ${expense.title} - INR ${expense.amount}');
  }

  // 5. LIST ALL EXPENSES
  void printExpenses() {
    print('\n========== ALL EXPENSES ==========');

    if (_expenses.isEmpty) {
      print('No expenses found.');
      return;
    }

    for (final expense in _expenses) {
      final payer = _findMember(expense.paidBy);
      final participants = expense.splitBetween
          .map((id) => _findMember(id).name)
          .join(', ');

      print('Title: ${expense.title}');
      print('Amount: INR ${expense.amount}');
      print('Paid by: ${payer.name}');
      print('Category: ${expense.category.name}');
      print('Participants: $participants');
      print('Share per person: INR '
          '${expense.amount ~/ expense.splitBetween.length}');
      print('------------------------------');
    }
    // 6. FILTER BY SINGLE MEMBER
  void filterByMember(String nameOrId) {
    final member = _findMember(nameOrId);

    print('\n--- Expenses involving ${member.name} ---');

    final results = _expenses.where((expense) {
      return expense.paidBy == member.id ||
          expense.splitBetween.contains(member.id);
    }).toList();

    if (results.isEmpty) {
      print('No matching expenses.');
      return;
    }

    for (final expense in results) {
      final role = (expense.paidBy == member.id) ? 'Paid' : 'Participant';
      print('• ${expense.title}: INR ${expense.amount} ($role)');
    }
  }

  // SHOW EXPENSES FOR ALL MEMBERS INDIVIDUALLY
  void printExpensesForAllMembers() {
    print('\n========== EXPENSES BY EACH MEMBER ==========');
    for (final member in _members) {
      filterByMember(member.name);
    }
  }

  // 7. FILTER BY CATEGORY
  void filterByCategory(String category) {
    final selectedCategory = _parseCategory(category);

    print('\n========== EXPENSES IN CATEGORY: ${selectedCategory.name.toUpperCase()} ==========');

    final results = _expenses
        .where((expense) => expense.category == selectedCategory)
        .toList();

    if (results.isEmpty) {
      print('No matching expenses.');
      return;
    }

    for (final expense in results) {
      print('• ${expense.title}: INR ${expense.amount}');
    }
  }

  // 8. CALCULATE TOTAL PAID, SHARE AND NET BALANCE
  void printBalances() {
    print('\n========== MEMBER BALANCES ==========');

    for (final member in _members) {
      int totalPaid = 0;
      int totalShare = 0;

      for (final expense in _expenses) {
        if (expense.paidBy == member.id) {
          totalPaid += expense.amount;
        }

        if (expense.splitBetween.contains(member.id)) {
          totalShare += expense.amount ~/ expense.splitBetween.length;
        }
      }

      final netBalance = totalPaid - totalShare;

      print('\nMember: ${member.name}');
      print('Total paid: INR $totalPaid');
      print('Share owed: INR $totalShare');
      print('Net balance: INR $netBalance');

      if (netBalance > 0) {
        print('${member.name} should receive INR $netBalance');
      } else if (netBalance < 0) {
        print('${member.name} should pay INR ${-netBalance}');
      } else {
        print('${member.name} is settled.');
      }
      print('------------------------------');
    }
  }
}

// 9. MAIN FUNCTION
void main() {
  try {
    final group = ExpenseGroup();

    // Add members
    group.addMember('Asha');
    group.addMember('Ravi');
    group.addMember('Neha');

    print('');

    // Example 1: Asha pays for dinner
    group.addExpense(
      title: 'Dinner',
      amount: 900,
      paidBy: 'Asha',
      category: 'Food',
      splitBetween: ['Asha', 'Ravi', 'Neha'],
    );

    // Example 2: Ravi pays for a cab
    group.addExpense(
      title: 'Cab',
      amount: 300,
      paidBy: 'Ravi',
      category: 'Travel',
      splitBetween: ['Asha', 'Ravi', 'Neha'],
    );

    // Example 3: Neha pays for Movie
    group.addExpense(
      title: 'Movie',
      amount: 600,
      paidBy: 'Neha',
      category: 'Entertainment',
      splitBetween: ['Asha', 'Ravi', 'Neha'],
    );

    // Example 4: Ravi pays for Groceries (Replaced Electricity Bill)
    group.addExpense(
      title: 'Groceries',
      amount: 1200,
      paidBy: 'Ravi',
      category: 'Shopping',
      splitBetween: ['Asha', 'Ravi', 'Neha'],
    );

    // Display overall expenses
    group.printExpenses();

    // Display expenses for each member individually
    group.printExpensesForAllMembers();

    // Display category filters
    group.filterByCategory('Shopping');

    // Display balances
    group.printBalances();

  } on ArgumentError catch (error) {
    print('Input error: ${error.message}');
  } catch (error) {
    print('An unexpected error occurred: $error');
  }
}
  }

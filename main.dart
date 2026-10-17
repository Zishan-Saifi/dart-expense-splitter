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

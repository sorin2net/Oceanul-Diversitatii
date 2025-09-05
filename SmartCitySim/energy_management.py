Title:  BudgetApp

=== FILE: budget.py ===
class Budget:
    def __init__(self, name, limit):
        self.name = name
        self.limit = limit
        self.expenses = []

    def add_expense(self, amount, description):
        self.expenses.append({"amount": amount, "description": description})

    def get_total_expenses(self):
        total = sum([expense["amount"] for expense in self.expenses])
        return total

    def remaining_amount(self):
        return self.limit - self.get_total_expenses()

    def generate_report(self):
        report = f"Budget: {self.name}\nLimit: {self.limit}\n\nExpenses:\n"
        for expense in self.expenses:
            report += f"- {expense['description']}: ${expense['amount']}\n"
        report += f"\nTotal Expenses: ${self.get_total_expenses()}\nRemaining: ${self.remaining_amount()}"
        return report

    def categorize_expenses(self):
        categories = {}
        for expense in self.expenses:
            desc = expense['description'].lower()
            category = "other"
            if "food" in desc:
                category = "food"
            elif "transport" in desc or "travel" in desc:
                category = "transport"
            elif "housing" in desc or "rent" in desc:
                category = "housing"
            elif "entertainment" in desc:
                category = "entertainment"
            if category not in categories:
                categories[category] = 0
            categories[category] += expense['amount']
        return categories

=== END FILE ===

=== FILE: user.py ===
class User:
    def __init__(self, username, password):
        self.username = username
        self.password = password
        self.budgets = []

    def add_budget(self, budget):
        self.budgets.append(budget)

    def get_budget_by_name(self, name):
        for budget in self.budgets:
            if budget.name == name:
                return budget
        return None

    def generate_overall_report(self):
      report = f"User: {self.username}\nOverall Budget Report:\n\n"
      for budget in self.budgets:
          report += budget.generate_report() + "\n\n"
      return report

    def get_all_budgets(self):
        return self.budgets

    def categorize_all_expenses(self):
        overall_categories = {}
        for budget in self.budgets:
            categories = budget.categorize_expenses()
            for category, amount in categories.items():
                if category not in overall_categories:
                    overall_categories[category] = 0
                overall_categories[category] += amount
        return overall_categories


=== END FILE ===

=== FILE: interface.py ===
import budget
import user

def main():
    user1 = user.User("john_doe", "password123")

    food_budget = budget.Budget("Food", 500)
    food_budget.add_expense(100, "Groceries")
    food_budget.add_expense(50, "Restaurant")
    user1.add_budget(food_budget)

    transport_budget = budget.Budget("Transport", 200)
    transport_budget.add_expense(75, "Bus tickets")
    transport_budget.add_expense(100, "Fuel")
    user1.add_budget(transport_budget)

    print(user1.generate_overall_report())
    print("\nCategorized Expenses:")
    print(user1.categorize_all_expenses())

    food_budget2 = user1.get_budget_by_name("Food")
    if food_budget2:
        print("\nFood Budget Remaining:",food_budget2.remaining_amount())


if __name__ == "__main__":
    main()

=== END FILE ===
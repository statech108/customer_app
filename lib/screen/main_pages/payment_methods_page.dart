import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/fake_data.dart';

class PaymentMethodsPage extends StatefulWidget {
  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final MockDataService _mockDataService = MockDataService();

  @override
  Widget build(BuildContext context) {
    final User currentUser = _mockDataService.getCurrentUser();
    final List<PaymentMethod> paymentMethods = currentUser.paymentMethods;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Payment Methods", style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700)),
      ),
      body: paymentMethods.isEmpty
          ? Center(
        child: Text(
          "No payment methods added yet. Add one to get started!",
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: paymentMethods.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildPaymentMethodItem(paymentMethods[index], index, context);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) => SelectPaymentMethodTypePage()),
          );
        },
        backgroundColor: Colors.teal,
        label: const Text("Add Payment Method", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethod payment, int index, BuildContext context) {
    final String type = payment.type;
    Widget content;
    Color cardBgColor = Theme.of(context).colorScheme.surface;
    Color onCardColor = Theme.of(context).colorScheme.onSurface;
    IconData icon;
    Color buttonColor = Colors.teal;

    switch (type) {
      case "Card":
        final String brand = payment.brand ?? 'Card';
        final String number = payment.number ?? '**** **** **** 0000';
        final String expiry = payment.expiry ?? 'MM/YY';
        final bool isVisa = brand == "Visa";
        cardBgColor = isVisa ? Colors.teal : Colors.blueGrey;
        onCardColor = Colors.white;
        icon = Icons.credit_card;

        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: onCardColor, size: 32),
                const Spacer(),
                Text(brand, style: TextStyle(color: onCardColor, fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 20),
            Text(number, style: TextStyle(color: onCardColor, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 2)),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("EXPIRY", style: TextStyle(color: onCardColor.withOpacity(0.7), fontSize: 10)),
                    Text(expiry, style: TextStyle(color: onCardColor, fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Spacer(),
                if (payment.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: onCardColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: onCardColor.withOpacity(0.5)),
                    ),
                    child: Text("Default", style: TextStyle(color: onCardColor, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
          ],
        );
        buttonColor = onCardColor;
        break;

      case "UPI":
        final String upiId = payment.upiId ?? 'user@upi';
        icon = Icons.account_circle;
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Colors.teal, size: 32),
                const SizedBox(width: 12),
                Text("UPI", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
                const Spacer(),
                if (payment.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Default", style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(upiId, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
            Text("Verified", style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        );
        break;

      case "BankAccount":
        final String bankName = payment.bankName ?? 'Bank';
        final String accountNumber = payment.accountNumber ?? '**** **** 0000';
        final String accountHolder = payment.accountHolder ?? 'Account Holder';
        icon = Icons.account_balance;
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Colors.teal, size: 32),
                const SizedBox(width: 12),
                Text(bankName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
                const Spacer(),
                if (payment.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Default", style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text("A/c No: $accountNumber", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 4),
            Text("Holder: $accountHolder", style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        );
        break;

      case "CashOnDelivery":
        final String status = payment.status ?? 'Available';
        icon = Icons.money;
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Colors.teal, size: 32),
                const SizedBox(width: 12),
                Text("Cash on Delivery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
                const Spacer(),
                if (payment.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Default", style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text("Status: $status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 4),
            Text("Pay with cash when your order arrives.", style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        );
        buttonColor = Colors.grey;
        break;

      default:
        content = Text("Unknown Payment Type: $type", style: TextStyle(color: Theme.of(context).colorScheme.error));
        icon = Icons.error_outline;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: type == "Card" ? cardBgColor : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          content,
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: type != "CashOnDelivery"
                      ? () async {
                    final PaymentMethod? updatedMethod = await Navigator.push<PaymentMethod>(
                      context,
                      MaterialPageRoute<PaymentMethod>(
                          builder: (BuildContext context) => AddEditPaymentMethodPage(
                            initialPaymentMethod: payment,
                            paymentType: type,
                          )),
                    );
                    if (updatedMethod != null) {
                      _updatePaymentMethod(index, updatedMethod);
                    }
                  }
                      : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cash on Delivery cannot be edited directly.")),
                    );
                  },
                  icon: Icon(Icons.edit_outlined, size: 18, color: type == "CashOnDelivery" ? Colors.grey : buttonColor),
                  label: Text("Edit", style: TextStyle(color: type == "CashOnDelivery" ? Colors.grey : buttonColor)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: type == "CashOnDelivery" ? Colors.grey : buttonColor,
                    side: BorderSide(color: type == "CashOnDelivery" ? Colors.grey.withOpacity(0.3) : buttonColor.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _removePaymentMethod(index);
                  },
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  label: const Text("Delete", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withOpacity(0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updatePaymentMethod(int index, PaymentMethod updatedMethod) {
    final User currentUser = _mockDataService.getCurrentUser();
    currentUser.paymentMethods[index] = updatedMethod;
    _mockDataService.updateUser(currentUser);
    setState(() {});
  }

  void _removePaymentMethod(int index) {
    final User currentUser = _mockDataService.getCurrentUser();
    currentUser.paymentMethods.removeAt(index);
    _mockDataService.updateUser(currentUser);
    setState(() {});
  }
}

class SelectPaymentMethodTypePage extends StatelessWidget {
  const SelectPaymentMethodTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Payment Type", style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _buildPaymentTypeOption(context, Icons.credit_card, "Credit/Debit Card", () {
            Navigator.push<PaymentMethod>(context, MaterialPageRoute<PaymentMethod>(builder: (BuildContext context) => const AddEditPaymentMethodPage(paymentType: "Card")));
          }),
          _buildPaymentTypeOption(context, Icons.currency_rupee, "UPI", () {
            Navigator.push<PaymentMethod>(context, MaterialPageRoute<PaymentMethod>(builder: (BuildContext context) => const AddEditPaymentMethodPage(paymentType: "UPI")));
          }),
          _buildPaymentTypeOption(context, Icons.account_balance, "Bank Account", () {
            Navigator.push<PaymentMethod>(context, MaterialPageRoute<PaymentMethod>(builder: (BuildContext context) => const AddEditPaymentMethodPage(paymentType: "BankAccount")));
          }),
          _buildPaymentTypeOption(context, Icons.money, "Cash on Delivery", () {
            final MockDataService mockDataService = MockDataService();
            final User currentUser = mockDataService.getCurrentUser();
            
            final PaymentMethod codMethod = PaymentMethod(
              id: 'PAY_${DateTime.now().millisecondsSinceEpoch}',
              type: 'CashOnDelivery',
              status: 'Available',
              lastFourDigits: '0000',
              cardHolderName: currentUser.username,
              isDefault: false,
            );
            
            currentUser.paymentMethods.add(codMethod);
            mockDataService.updateUser(currentUser);
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cash on Delivery added!")),
            );
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeOption(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}

class AddEditPaymentMethodPage extends StatefulWidget {
  final String paymentType;
  final PaymentMethod? initialPaymentMethod;

  const AddEditPaymentMethodPage({super.key, required this.paymentType, this.initialPaymentMethod});

  @override
  _AddEditPaymentMethodPageState createState() => _AddEditPaymentMethodPageState();
}

class _AddEditPaymentMethodPageState extends State<AddEditPaymentMethodPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MockDataService _mockDataService = MockDataService();
  late bool _isDefault;

  // Card controllers
  late TextEditingController _cardNumberController;
  late TextEditingController _cardExpiryController;
  late TextEditingController _cardBrandController;

  // UPI controllers
  late TextEditingController _upiIdController;

  // Bank Account controllers
  late TextEditingController _bankNameController;
  late TextEditingController _accountHolderController;
  late TextEditingController _accountNumberController;
  late TextEditingController _ifscCodeController;

  @override
  void initState() {
    super.initState();
    _isDefault = widget.initialPaymentMethod?.isDefault ?? false;

    // Initialize all controllers
    _cardNumberController = TextEditingController(text: widget.initialPaymentMethod?.number ?? '');
    _cardExpiryController = TextEditingController(text: widget.initialPaymentMethod?.expiry ?? '');
    _cardBrandController = TextEditingController(text: widget.initialPaymentMethod?.brand ?? '');

    _upiIdController = TextEditingController(text: widget.initialPaymentMethod?.upiId ?? '');

    _bankNameController = TextEditingController(text: widget.initialPaymentMethod?.bankName ?? '');
    _accountHolderController = TextEditingController(text: widget.initialPaymentMethod?.accountHolder ?? '');
    _accountNumberController = TextEditingController(text: widget.initialPaymentMethod?.accountNumber ?? '');
    _ifscCodeController = TextEditingController(text: widget.initialPaymentMethod?.ifscCode ?? '');
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardBrandController.dispose();
    _upiIdController.dispose();
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.initialPaymentMethod == null ? "Add ${widget.paymentType}" : "Edit ${widget.paymentType}";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDynamicForm(),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text("Set as default payment method"),
                  value: _isDefault,
                  onChanged: (bool? value) => setState(() => _isDefault = value!),
                  activeColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Theme.of(context).colorScheme.surface,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _savePaymentMethod,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      widget.initialPaymentMethod == null ? "Save Method" : "Update Method",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicForm() {
    switch (widget.paymentType) {
      case "Card":
        return Column(
          children: <Widget>[
            _buildTextField("Card Number", _cardNumberController, Icons.credit_card, context, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildTextField("Expiry Date (MM/YY)", _cardExpiryController, Icons.calendar_today, context),
            const SizedBox(height: 20),
            _buildTextField("Card Brand (Visa/Mastercard)", _cardBrandController, Icons.label_important_outline, context),
          ],
        );
      case "UPI":
        return Column(
          children: <Widget>[
            _buildTextField("UPI ID", _upiIdController, Icons.account_circle, context),
          ],
        );
      case "BankAccount":
        return Column(
          children: <Widget>[
            _buildTextField("Bank Name", _bankNameController, Icons.account_balance, context),
            const SizedBox(height: 20),
            _buildTextField("Account Holder Name", _accountHolderController, Icons.person_outline, context),
            const SizedBox(height: 20),
            _buildTextField("Account Number", _accountNumberController, Icons.account_balance_wallet_outlined, context, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildTextField("IFSC Code", _ifscCodeController, Icons.business_outlined, context),
          ],
        );
      case "CashOnDelivery":
        return Center(
          child: Text(
            "Cash on Delivery is enabled. No further details needed.",
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, BuildContext context, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      validator: (String? value) => value == null || value.isEmpty ? "$label is required" : null,
    );
  }

  void _savePaymentMethod() {
    if (widget.paymentType == "CashOnDelivery") {
      final User currentUser = _mockDataService.getCurrentUser();
      final PaymentMethod codMethod = PaymentMethod(
        id: widget.initialPaymentMethod?.id ?? 'PAY_${DateTime.now().millisecondsSinceEpoch}',
        type: "CashOnDelivery",
        status: "Available",
        lastFourDigits: '0000',
        cardHolderName: currentUser.username,
        isDefault: _isDefault,
      );
      
      if (widget.initialPaymentMethod == null) {
        currentUser.paymentMethods.add(codMethod);
      } else {
        final index = currentUser.paymentMethods.indexOf(widget.initialPaymentMethod!);
        if (index != -1) {
          currentUser.paymentMethods[index] = codMethod;
        }
      }
      
      _mockDataService.updateUser(currentUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.paymentType} ${widget.initialPaymentMethod == null ? "added" : "updated"} successfully!")),
      );
      Navigator.pop(context);
      return;
    }

    if (_formKey.currentState!.validate()) {
      final User currentUser = _mockDataService.getCurrentUser();
      final String id = widget.initialPaymentMethod?.id ?? 'PAY_${DateTime.now().millisecondsSinceEpoch}';
      
      PaymentMethod newOrUpdatedMethod = PaymentMethod(
        id: id,
        type: widget.paymentType,
        lastFourDigits: '0000',
        cardHolderName: currentUser.username,
        isDefault: _isDefault,
      );

      switch (widget.paymentType) {
        case "Card":
          newOrUpdatedMethod = PaymentMethod(
            id: id,
            type: widget.paymentType,
            brand: _cardBrandController.text,
            number: _cardNumberController.text,
            expiry: _cardExpiryController.text,
            lastFourDigits: _cardNumberController.text.length >= 4 ? _cardNumberController.text.substring(_cardNumberController.text.length - 4) : '0000',
            cardHolderName: currentUser.username,
            isDefault: _isDefault,
          );
          break;
        case "UPI":
          newOrUpdatedMethod = PaymentMethod(
            id: id,
            type: widget.paymentType,
            upiId: _upiIdController.text,
            lastFourDigits: '0000',
            cardHolderName: currentUser.username,
            isDefault: _isDefault,
          );
          break;
        case "BankAccount":
          newOrUpdatedMethod = PaymentMethod(
            id: id,
            type: widget.paymentType,
            bankName: _bankNameController.text,
            accountHolder: _accountHolderController.text,
            accountNumber: _accountNumberController.text,
            ifscCode: _ifscCodeController.text,
            lastFourDigits: _accountNumberController.text.length >= 4 ? _accountNumberController.text.substring(_accountNumberController.text.length - 4) : '0000',
            cardHolderName: currentUser.username,
            isDefault: _isDefault,
          );
          break;
      }

      if (widget.initialPaymentMethod == null) {
        currentUser.paymentMethods.add(newOrUpdatedMethod);
      } else {
        final index = currentUser.paymentMethods.indexOf(widget.initialPaymentMethod!);
        if (index != -1) {
          currentUser.paymentMethods[index] = newOrUpdatedMethod;
        }
      }
      
      _mockDataService.updateUser(currentUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.paymentType} ${widget.initialPaymentMethod == null ? "added" : "updated"} successfully!")),
      );
      Navigator.pop(context);
    }
  }
}

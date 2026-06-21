/// Foydalanuvchiga ko'rinadigan kategoriya nomlari (O'zbek).
class AppCategories {
  AppCategories._();

  // Vazifalar
  static const taskGeneral = 'umumiy';
  static const taskWork = 'ish';
  static const taskPersonal = 'shaxsiy';
  static const taskHealth = 'sog\'liq';
  static const taskStudy = 'ta\'lim';

  static const taskDefaults = [
    taskGeneral,
    taskWork,
    taskPersonal,
    taskHealth,
    taskStudy,
  ];

  // Moliya — daromad
  static const incomeSalary = 'maosh';
  static const incomeFreelance = 'freelance';
  static const incomeOther = 'boshqa';

  static const incomeDefaults = [
    incomeSalary,
    incomeFreelance,
    incomeOther,
  ];

  // Moliya — xarajat
  static const expenseFood = 'ovqat';
  static const expenseTransport = 'transport';
  static const expenseHousing = 'uy-joy';
  static const expenseEntertainment = 'ko\'ngilochar';
  static const expenseHealth = 'sog\'liq';
  static const expenseEducation = 'ta\'lim';
  static const expenseOther = 'boshqa';

  static const expenseDefaults = [
    expenseFood,
    expenseTransport,
    expenseHousing,
    expenseEntertainment,
    expenseHealth,
    expenseEducation,
    expenseOther,
  ];

  // Hujjat turlari
  static const documentPassport = 'pasport';
  static const documentContract = 'shartnoma';
  static const documentCertificate = 'sertifikat';
  static const documentOther = 'boshqa';

  static const documentDefaults = [
    documentPassport,
    documentContract,
    documentCertificate,
    documentOther,
  ];
}

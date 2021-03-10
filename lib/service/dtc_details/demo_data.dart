class DemoData {
  static final carBrands = [
    'Acura',
    'Audi',
    'BMW',
    'Buick',
    'Cadillac',
    'Chevrolet',
    'Chrysler',
    'Dodge',
    'Eagle',
    'Ford',
    'GEO',
    'GMC',
    'Honda',
    'Hummer',
    'Hyundai',
    'Infiniti',
    'Isuzu',
    'Jaguar',
    'Jeep',
    'KIA',
    'Land Rover',
    'Lexus',
    'Lincoln',
    'Mazda',
    'Mercedes-Benz',
    'Mercury',
    'MINI',
    'Mitsubishi',
    'Nissan',
    'Oldsmobile',
    'Pontiac',
    'Saab',
    'Saturn',
    'Scion',
    'Subaru',
    'Suzuki',
    'Toyota',
    'Volkswagen',
    'Volvo'
  ];

  static final p0500DtcCode = {
    'possiblesCauses': '- Faulty Speed Sensor- Speed Sensor harness is open '
        'or shorted- Speed Sensor circuit poor electrical connection?',
    'whenCodeDetected': 'Diagnostic trouble code is detected when Transmission '
        'Control Module (TCM) does not receive the proper voltage signal from the sensor.',
    'possibleSymptoms':
        '- Engine Light ON (or Service Engine Soon Warning Light)'
            '- Speedometer improper reading- Possible shifting problems',
    'description': 'The speed sensor detects the revolution of the idler gear'
        'parking pawl lock gear and emits a pulse signal. The pulse signal is '
        'sent to the Transmission Control Module (TCM) which converts it into '
        'vehicle speed.'
  };

  static final p0174DtcCode = {
    'possiblesCauses': '- Intake air leaks- Faulty front heated oxygen sensor'
        '- Ignition misfiring- Faulty fuel injectors- Exhaust gas leaks'
        '- Incorrect fuel pressure- Lack of fuel- Faulty Mass Air Flow (MAF) sensor'
        '- Incorrect Positive Crankcase Ventilation (PCV) hose connection',
    'whenCodeDetected': '- Fuel injection system does not operate properly.'
        ' - The amount of mixture ratio compensation is too small.'
        ' (The mixture ratio is too lean.)',
    'possibleSymptoms':
        '- Engine Light ON (or Service Engine Soon Warning Light)'
            '- Excessive Fuel Consumption',
    'description': 'With the Air/Fuel Mixture Ratio Self-Learning Control,'
        ' the actual mixture ratio can be brought closely to the theoretical '
        'mixture ratio based on the mixture ratio feedback signal from the'
        ' heated oxygen sensors 1. The Engine Control Module (ECM) calculates '
        'the necessary compensation to correct the offset between the actual '
        'and the theoretical ratios. In case the amount of the compensation'
        'value is extremely large (The actual mixture ratio is too lean.), the '
        'ECM judges the condition as the fuel injection system malfunction and '
        'light up the Malfunction Indicator Light (MIL) (2 trip detection logic).'
  };
}

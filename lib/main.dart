import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const HemoPulseApp());
}

class HemoPulseApp extends StatelessWidget {
  const HemoPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HemoPulse Data Collector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF008080), // Teal como en el diagrama
          primary: const Color(0xFF008080),
          secondary: const Color(0xFF5E35B1), // Púrpura para el modelo
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationPage(),
    );
  }
}

// Modelo de datos de cada Sesión
class SessionData {
  final String id;
  final String patientCode; // ID Anónimo (ej. PAT-802)
  final DateTime timestamp;
  
  // Datos del Hardware (MAX30102 + AD8232)
  final double hr;
  final double spo2Sensor;
  final double ptt;
  final double ppgAmplitude;

  // Datos de Referencia (Ingresados por Operador)
  final double? spo2Ref;
  final double? sysBP;
  final double? diaBP;
  final double? labHct;
  final double? labHb;

  // Control de Calidad
  bool isQualityValid;
  String notes;

  SessionData({
    required this.id,
    required this.patientCode,
    required this.timestamp,
    required this.hr,
    required this.spo2Sensor,
    required this.ptt,
    required this.ppgAmplitude,
    this.spo2Ref,
    this.sysBP,
    this.diaBP,
    this.labHct,
    this.labHb,
    this.isQualityValid = true,
    this.notes = '',
  });

  // Genera la fila CSV
  String toCsvRow() {
    return '$id,$patientCode,${timestamp.toIso8601String()},$hr,$spo2Sensor,$ptt,$ppgAmplitude,${spo2Ref ?? ""},${sysBP ?? ""},${diaBP ?? ""},${labHct ?? ""},${labHb ?? ""},$isQualityValid,"$notes"';
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  // Base de datos local en memoria
  final List<SessionData> _dataset = [];

  // Coeficientes del modelo desplegado (Regresión Múltiple en App)
  // Hct = B0 + (B1 * PTT) + (B2 * SpO2) + (B3 * PPG_Amp)
  double beta0 = 82.5;
  double beta1 = -0.11; // A menor PTT (arteria rígida), mayor Hct
  double beta2 = -0.22; // A menor SpO2, mayor Hct
  double beta3 = -0.04;

  void _addSession(SessionData session) {
    setState(() {
      _dataset.add(session);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sesión de ${session.patientCode} guardada en el celular'),
        backgroundColor: const Color(0xFF008080),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CapturePage(onSave: _addSession),
      DatasetPage(dataset: _dataset, onUpdate: () => setState(() {})),
      DeploymentPage(
        dataset: _dataset,
        beta0: beta0,
        beta1: beta1,
        beta2: beta2,
        beta3: beta3,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sensors),
            label: '1. Captura Campo',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_chart),
            label: '2. Dataset CSV',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            label: '3. Despliegue Regresión',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 1: CAPTURA EN CAMPO (HARDWARE + REFERENCIA OPERADOR)
// ---------------------------------------------------------------------------
class CapturePage extends StatefulWidget {
  final Function(SessionData) onSave;
  const CapturePage({super.key, required this.onSave});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  // Datos simulados del Hardware
  double hwHr = 76;
  double hwSpo2 = 91;
  double hwPtt = 215;
  double hwPpgAmp = 42;

  // Controllers para datos del Operador
  final _patientCodeController = TextEditingController(text: 'ANON-${100 + (DateTime.now().millisecond % 899)}');
  final _spo2RefController = TextEditingController();
  final _sysBpController = TextEditingController();
  final _diaBpController = TextEditingController();
  final _labHctController = TextEditingController();
  final _labHbController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isQualityValid = true;

  void _submit() {
    final session = SessionData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientCode: _patientCodeController.text.trim().isEmpty ? 'ANON-000' : _patientCodeController.text.trim(),
      timestamp: DateTime.now(),
      hr: hwHr,
      spo2Sensor: hwSpo2,
      ptt: hwPtt,
      ppgAmplitude: hwPpgAmp,
      spo2Ref: double.tryParse(_spo2RefController.text),
      sysBP: double.tryParse(_sysBpController.text),
      diaBP: double.tryParse(_diaBpController.text),
      labHct: double.tryParse(_labHctController.text),
      labHb: double.tryParse(_labHbController.text),
      isQualityValid: _isQualityValid,
      notes: _notesController.text,
    );

    widget.onSave(session);

    // Resetear formulario para el siguiente paciente
    setState(() {
      _patientCodeController.text = 'ANON-${100 + (DateTime.now().millisecond % 899)}';
      _spo2RefController.clear();
      _sysBpController.clear();
      _diaBpController.clear();
      _labHctController.clear();
      _labHbController.clear();
      _notesController.clear();
      _isQualityValid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura en Campo (Hardware + Operador)'),
        backgroundColor: const Color(0xFF008080),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección Hardware
            Card(
              color: Colors.teal.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF008080), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.memory, color: Color(0xFF008080)),
                        SizedBox(width: 8),
                        Text(
                          'Hardware BLE: MAX30102 + AD8232',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _hwMetric('HR', '${hwHr.round()} bpm'),
                        _hwMetric('SpO2', '${hwSpo2.round()}%'),
                        _hwMetric('PTT', '${hwPtt.round()} ms'),
                        _hwMetric('PPG Amp', '${hwPpgAmp.round()} au'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Simular variación de señal en vivo:', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                    Slider(
                      value: hwPtt,
                      min: 150,
                      max: 280,
                      activeColor: const Color(0xFF008080),
                      onChanged: (v) => setState(() => hwPtt = v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sección Formulario Operador
            const Text('Datos del Operador & Historia Clínica', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _patientCodeController,
              decoration: const InputDecoration(
                labelText: 'Código Anónimo Paciente',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sysBpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'P. Art. Sistólica',
                      suffixText: 'mmHg',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _diaBpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'P. Art. Diastólica',
                      suffixText: 'mmHg',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _labHctController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hematocrito Lab (Hct)',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _labHbController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hemoglobina Lab (Hb)',
                      suffixText: 'g/dL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Filtro de Calidad de Señal
            SwitchListTile(
              title: const Text('¿Calidad de Señal Aceptable?'),
              subtitle: Text(_isQualityValid ? 'Señal limpia (Apta para training)' : 'Ruido/Artefacto (Se descartará en ML)'),
              value: _isQualityValid,
              activeColor: const Color(0xFF008080),
              onChanged: (val) => setState(() => _isQualityValid = val),
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas / Observaciones',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('GUARDAR SESIÓN LOCALMENTE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hwMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 2: DATASET LOCAL & EXPORTACIÓN CSV
// ---------------------------------------------------------------------------
class DatasetPage extends StatelessWidget {
  final List<SessionData> dataset;
  final VoidCallback onUpdate;

  const DatasetPage({super.key, required this.dataset, required this.onUpdate});

  String _generateCsv() {
    StringBuffer sb = StringBuffer();
    sb.writeln("session_id,patient_code,timestamp,hr_bpm,spo2_sensor,ptt_ms,ppg_amp,spo2_ref,sys_bp,dia_bp,lab_hct,lab_hb,quality_valid,notes");
    for (var session in dataset) {
      sb.writeln(session.toCsvRow());
    }
    return sb.toString();
  }

  void _exportCsvDialog(BuildContext context) {
    String csvData = _generateCsv();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_download, color: Color(0xFF008080)),
            SizedBox(width: 8),
            Text('Dataset CSV Generado'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Registros: ${dataset.length} | Limpios para ML: ${dataset.where((s) => s.isQualityValid).length}'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade200,
                height: 180,
                child: SingleChildScrollView(
                  child: SelectableText(
                    csvData,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: csvData));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('CSV copiado al portapapeles. ¡Listo para pegar en Excel o Python!')),
              );
            },
            child: const Text('COPIAR CSV'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CERRAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int validCount = dataset.where((s) => s.isQualityValid).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dataset Local Anonimizado'),
        backgroundColor: const Color(0xFF008080),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: dataset.isEmpty ? null : () => _exportCsvDialog(context),
          ),
        ],
      ),
      body: dataset.isEmpty
          ? const Center(
              child: Text(
                'No hay sesiones guardadas.\nRealiza capturas en la pestaña 1.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.teal.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sesiones Totales: ${dataset.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Limpias: $validCount', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: () => _exportCsvDialog(context),
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('EXPORTAR CSV'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008080), foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataset.length,
                    itemBuilder: (context, index) {
                      final s = dataset[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: s.isQualityValid ? Colors.teal : Colors.orange,
                            child: Icon(s.isQualityValid ? Icons.check : Icons.warning, color: Colors.white, size: 18),
                          ),
                          title: Text('${s.patientCode} - PTT: ${s.ptt.round()}ms | SpO2: ${s.spo2Sensor.round()}%'),
                          subtitle: Text('Hct Lab: ${s.labHct != null ? "${s.labHct}%" : "N/A"} | BP: ${s.sysBP ?? "-"}/${s.diaBP ?? "-"}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              dataset.removeAt(index);
                              onUpdate();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 3: DESPLIEGUE DE MODELO (REGRESIÓN LÍNEA ÚNICA EN APP)
// ---------------------------------------------------------------------------
class DeploymentPage extends StatelessWidget {
  final List<SessionData> dataset;
  final double beta0;
  final double beta1;
  final double beta2;
  final double beta3;

  const DeploymentPage({
    super.key,
    required this.dataset,
    required this.beta0,
    required this.beta1,
    required this.beta2,
    required this.beta3,
  });

  // Inferencia instantánea en Flutter (Paso 5 del diagrama)
  double predictHct(double ptt, double spo2, double ppgAmp) {
    return beta0 + (beta1 * ptt) + (beta2 * spo2) + (beta3 * ppgAmp);
  }

  @override
  Widget build(BuildContext context) {
    List<SessionData> validSessions = dataset.where((s) => s.isQualityValid && s.labHct != null).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inferencia & Validación (Despliegue)'),
        backgroundColor: const Color(0xFF5E35B1), // Púrpura para modelo
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ecuación desplegada
            Card(
              color: Colors.purple.shade50,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF5E35B1), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.functions, color: Color(0xFF5E35B1)),
                        SizedBox(width: 8),
                        Text(
                          'Modelo de Regresión Ridge Desplegado',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text(
                      'Hct_pred = β₀ + (β₁ × PTT) + (β₂ × SpO2) + (β₃ × Amp)',
                      style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('• β₀ (Intercepto): $beta0', style: const TextStyle(fontSize: 12)),
                    Text('• β₁ (PTT): $beta1', style: const TextStyle(fontSize: 12)),
                    Text('• β₂ (SpO2): $beta2', style: const TextStyle(fontSize: 12)),
                    Text('• β₃ (PPG Amp): $beta3', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Validación vs Valor Real
            const Text('Paso 6: Validación (Predicción vs Lab Real)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            validSessions.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Registra al menos una sesión limpia con valor de "Hematocrito Lab" en la Pestaña 1 para comparar la predicción contra la realidad.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : Column(
                    children: validSessions.map((s) {
                      double predHct = predictHct(s.ptt, s.spo2Sensor, s.ppgAmplitude);
                      double realHct = s.labHct!;
                      double error = (predHct - realHct).abs();

                      return Card(
                        child: ListTile(
                          title: Text('${s.patientCode} -> Hct Predicho: ${predHct.toStringAsFixed(1)}%'),
                          subtitle: Text('Hct Real Lab: ${realHct.toStringAsFixed(1)}% | Error Absoluto: ${error.toStringAsFixed(1)}%'),
                          trailing: Icon(
                            error <= 3.0 ? Icons.check_circle : Icons.warning_amber,
                            color: error <= 3.0 ? Colors.green : Colors.amber,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
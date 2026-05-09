import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../sidebar/admin_sidebar.dart';

class SetKScreen extends StatefulWidget {
  const SetKScreen({super.key});

  @override
  State<SetKScreen> createState() => _SetKScreenState();
}

class _SetKScreenState extends State<SetKScreen> {
  bool isLoading = true;
  
  // Configuration values
  int kValue = 3;
  String algorithm = "KNN";
  String distanceMetric = "Euclidean Distance";
  String normalization = "Min-Max Scaling";
  
  // Metrics
  int trainingSamples = 0;
  double modelAccuracy = 0.0;
  double precision = 0.0;
  double recall = 0.0;
  double f1Score = 0.0;

  @override
  void initState() {
    super.initState();
    loadConfiguration();
  }

  // 🔥 LOAD CONFIGURATION FROM BACKEND
  void loadConfiguration() async {
    try {
      final config = await ApiService.getKNNConfiguration();
      final metrics = await ApiService.getKNNMetrics();
      
      setState(() {
        kValue = config["k_value"] ?? 3;
        algorithm = config["algorithm"] ?? "KNN";
        distanceMetric = config["distance_metric"] ?? "Euclidean Distance";
        normalization = config["normalization"] ?? "Min-Max Scaling";
        
        trainingSamples = metrics["training_samples"] ?? 0;
        modelAccuracy = (metrics["model_accuracy"] ?? 0.0).toDouble();
        precision = (metrics["precision"] ?? 0.0).toDouble();
        recall = (metrics["recall"] ?? 0.0).toDouble();
        f1Score = (metrics["f1_score"] ?? 0.0).toDouble();
        
        isLoading = false;
      });
    } catch (e) {
      print("Error loading configuration: $e");
      setState(() => isLoading = false);
    }
  }

  // 🔥 SAVE CONFIGURATION
  void saveConfiguration() async {
    try {
      final config = {
        "k_value": kValue,
        "algorithm": algorithm,
        "distance_metric": distanceMetric,
        "normalization": normalization,
      };
      
      final response = await ApiService.updateKNNConfiguration(config);
      
      // Update metrics
      setState(() {
        modelAccuracy = (response["model_accuracy"] ?? 0.0).toDouble();
        precision = (response["precision"] ?? 0.0).toDouble();
        recall = (response["recall"] ?? 0.0).toDouble();
        f1Score = (response["f1_score"] ?? 0.0).toDouble();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfigurasi berhasil disimpan")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("K-Nearest Neighbor Configuration"),
        elevation: 0,
      ),
      drawer: const AdminSidebar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== CONFIGURATION CARD =====
                    _buildConfigurationCard(),
                    const SizedBox(height: 24),
                    
                    // ===== METRICS CARDS =====
                    _buildMetricsSection(),
                    const SizedBox(height: 24),
                    
                    // ===== SAVE BUTTON =====
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: saveConfiguration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "save configuration",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  // ===== BUILD CONFIGURATION CARD =====
  Widget _buildConfigurationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF2D3E50),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // K VALUE SLIDER
            _buildKValueSlider(),
            const SizedBox(height: 20),
            
            // ALGORITHM & DISTANCE METRIC
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    "algoritma",
                    algorithm,
                    ["KNN", "K-Means", "Decision Tree"],
                    (value) => setState(() => algorithm = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    "Distance Metric",
                    distanceMetric,
                    ["Euclidean Distance", "Manhattan Distance", "Cosine Distance"],
                    (value) => setState(() => distanceMetric = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // NORMALIZATION & TRAINING SAMPLES
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    "Normalization",
                    normalization,
                    ["Min-Max Scaling", "Standard Scaler", "None"],
                    (value) => setState(() => normalization = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Training Samples",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          trainingSamples.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // MODEL ACCURACY
            _buildAccuracyBar(),
          ],
        ),
      ),
    );
  }

  // ===== BUILD K VALUE SLIDER =====
  Widget _buildKValueSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nilai K Saat Ini",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                kValue.toString(),
                style: const TextStyle(
                  color: Color(0xFF2D3E50),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Text(
                "-",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Expanded(
                child: Slider(
                  value: kValue.toDouble(),
                  min: 1,
                  max: 50,
                  divisions: 49,
                  activeColor: Colors.deepPurple,
                  inactiveColor: Colors.white30,
                  onChanged: (value) {
                    setState(() => kValue = value.toInt());
                  },
                ),
              ),
              const Text(
                "+",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: TextEditingController(text: kValue.toString()),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  onChanged: (value) {
                    int? newK = int.tryParse(value);
                    if (newK != null && newK >= 1 && newK <= 50) {
                      setState(() => kValue = newK);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===== BUILD DROPDOWN =====
  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF3D4E60),
            style: const TextStyle(color: Colors.white),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ),
      ],
    );
  }

  // ===== BUILD ACCURACY BAR =====
  Widget _buildAccuracyBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Model Accuracy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${modelAccuracy.toStringAsFixed(1)}%",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: modelAccuracy / 100,
            minHeight: 8,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getAccuracyColor(modelAccuracy),
            ),
          ),
        ),
      ],
    );
  }

  // ===== BUILD METRICS SECTION =====
  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Model Metrics",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCompactMetricCard("precision", precision),
              const SizedBox(width: 12),
              _buildCompactMetricCard("Recall", recall),
              const SizedBox(width: 12),
              _buildCompactMetricCard("F1Score", f1Score),
            ],
          ),
        ),
      ],
    );
  }

  // ===== BUILD COMPACT METRIC CARD =====
  Widget _buildCompactMetricCard(String label, double value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3E50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          
          // Value
          Text(
            "${value.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getAccuracyColor(value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== HELPER: GET ACCURACY COLOR =====
  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.amber;
    return Colors.red;
  }
}
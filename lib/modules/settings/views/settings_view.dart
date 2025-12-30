import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../../app/data/models/agent_config.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.resetToDefaults,
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: Obx(() {
        final settings = controller.settings.value;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // API Section
            Text(
              'API Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildBaseUrlSelector(context, settings.baseUrl),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'API Key',
              ),
              obscureText: true,
              controller: TextEditingController(text: settings.apiKey),
              onChanged: controller.updateApiKey,
            ),
            const SizedBox(height: 32),

            // Translation Section
            Text(
              'Translation Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Target Language',
              ),
              controller: TextEditingController(text: settings.targetLang),
              onChanged: controller.updateTargetLang,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tone Profile',
              ),
              maxLines: 3,
              controller: TextEditingController(text: settings.toneProfile),
              onChanged: controller.updateToneProfile,
            ),
            const SizedBox(height: 32),

            // Agent Configs
            Text(
              'Agent Configurations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildAgentCard(
              context,
              'Agent 1 - Translator',
              settings.agent1,
              controller.updateAgent1,
            ),
            const SizedBox(height: 16),
            _buildAgentCard(
              context,
              'Agent 2 - Stylist',
              settings.agent2,
              controller.updateAgent2,
            ),
            const SizedBox(height: 16),
            _buildAgentCard(
              context,
              'Agent 3 - QA',
              settings.agent3,
              controller.updateAgent3,
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton.icon(
              onPressed: () => controller.saveSettings(settings),
              icon: const Icon(Icons.save),
              label: const Text('Save Settings'),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAgentCard(
    BuildContext context,
    String title,
    AgentConfig agent,
    Function(AgentConfig) onUpdate,
  ) {
    return Card(
      child: ExpansionTile(
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Model'),
                  controller: TextEditingController(text: agent.model),
                  onChanged: (value) => onUpdate(agent.copyWith(model: value)),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Temperature (Độ sáng tạo: 0-1)',
                    helperText:
                        '0 = chính xác, nhất quán | 1 = sáng tạo, đa dạng. Nhấn Enter để lưu',
                  ),
                  controller: TextEditingController(
                    text: agent.temperature.toString(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (value) => onUpdate(
                    agent.copyWith(temperature: double.tryParse(value) ?? 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Tokens (Giới hạn độ dài output)',
                    helperText:
                        'Số token tối đa cho câu trả lời (~1 token ≈ 0.75 từ). Nhấn Enter để lưu',
                  ),
                  controller: TextEditingController(
                    text: agent.maxTokens.toString(),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) => onUpdate(
                    agent.copyWith(maxTokens: int.tryParse(value) ?? 2000),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Prompts Configuration',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'System Prompt',
                    helperText: 'Prompt hệ thống cho agent này',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: agent.systemPrompt),
                  maxLines: 5,
                  onChanged: (value) =>
                      onUpdate(agent.copyWith(systemPrompt: value)),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'User Prompt Template',
                    helperText:
                        'Template prompt tùy chỉnh (có thể dùng {{VARIABLE}})',
                    border: OutlineInputBorder(),
                  ),
                  controller:
                      TextEditingController(text: agent.userPromptTemplate),
                  maxLines: 10,
                  onChanged: (value) =>
                      onUpdate(agent.copyWith(userPromptTemplate: value)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaseUrlSelector(BuildContext context, String currentUrl) {
    // Predefined URLs
    const String openAiUrl = 'https://api.openai.com/v1/chat/completions';
    const String bieApiUrl = 'https://api.bieapi.com/v1/chat/completions';
    const String customOption = 'custom';

    // Determine current selection
    String selectedOption;
    if (currentUrl == openAiUrl) {
      selectedOption = openAiUrl;
    } else if (currentUrl == bieApiUrl) {
      selectedOption = bieApiUrl;
    } else {
      selectedOption = customOption;
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Base URL',
                border: OutlineInputBorder(),
              ),
              value: selectedOption,
              items: const [
                DropdownMenuItem(
                  value: openAiUrl,
                  child: Text('OpenAI (mặc định)'),
                ),
                DropdownMenuItem(
                  value: bieApiUrl,
                  child: Text('BieAPI'),
                ),
                DropdownMenuItem(
                  value: customOption,
                  child: Text('Custom URL'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                  if (value != customOption) {
                    controller.updateBaseUrl(value);
                  }
                });
              },
            ),
            if (selectedOption == customOption) ...[
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Custom Base URL',
                  hintText: 'https://your-api.com/v1/chat/completions',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: currentUrl),
                onChanged: controller.updateBaseUrl,
              ),
            ],
          ],
        );
      },
    );
  }
}

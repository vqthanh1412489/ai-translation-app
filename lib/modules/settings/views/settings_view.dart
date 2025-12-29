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
            TextField(
              decoration: const InputDecoration(
                labelText: 'Base URL',
                hintText: 'https://api.openai.com/v1/chat/completions',
              ),
              controller: TextEditingController(text: settings.baseUrl),
              onChanged: controller.updateBaseUrl,
            ),
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
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Model'),
                  controller: TextEditingController(text: agent.model),
                  onChanged: (value) => onUpdate(agent.copyWith(model: value)),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Temperature',
                    helperText: 'Nhấn Enter để lưu',
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
                    labelText: 'Max Tokens',
                    helperText: 'Nhấn Enter để lưu',
                  ),
                  controller: TextEditingController(
                    text: agent.maxTokens.toString(),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) => onUpdate(
                    agent.copyWith(maxTokens: int.tryParse(value) ?? 2000),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

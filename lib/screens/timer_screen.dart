import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/house_service.dart';

class TimerScreen extends StatefulWidget {
  final String taskName;
  final String? zone;
  
  const TimerScreen({
    super.key,
    required this.taskName,
    this.zone,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 0;
  bool _isRunning = false;
  Timer? _timer;
  DateTime? _startTime;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _startTime = DateTime.now();
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _seconds = 0;
      _startTime = null;
    });
    _timer?.cancel();
  }

  void _completeTask() {
    _timer?.cancel();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ Task Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task: ${widget.taskName}'),
            const SizedBox(height: 8),
            Text('Time: ${_formatDuration(_seconds)}'),
            if (_startTime != null) ...[
              const SizedBox(height: 8),
              Text('Started: ${DateFormat('h:mm a').format(_startTime!)}'),
              Text('Completed: ${DateFormat('h:mm a').format(DateTime.now())}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: const Text('Start Another'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Timer'),
        actions: [
          if (_seconds > 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetTimer,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Task Info Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('📝 ', style: TextStyle(fontSize: 24)),
                        Expanded(
                          child: Text(
                            widget.taskName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.zone != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.room,
                            size: 16,
                            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.zone!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Timer Display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRunning
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: _isRunning ? 5 : 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatDuration(_seconds),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isRunning ? 'In Progress' : _seconds > 0 ? 'Paused' : 'Ready',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Timer info
                    if (_startTime != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Started at ${DateFormat('h:mm a').format(_startTime!)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_isRunning && _seconds > 0)
                  FloatingActionButton.large(
                    heroTag: 'reset',
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    onPressed: _resetTimer,
                    child: Icon(
                      Icons.refresh,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                
                FloatingActionButton.large(
                  heroTag: 'main',
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                ),
                
                if (_seconds > 0)
                  FloatingActionButton.large(
                    heroTag: 'complete',
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    onPressed: _completeTask,
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Tips Card
            if (!_isRunning && _seconds == 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Timer Tips',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Start the timer when you begin\n'
                        '• Pause if you need a break\n'
                        '• Complete when task is done\n'
                        '• Track your time to improve!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

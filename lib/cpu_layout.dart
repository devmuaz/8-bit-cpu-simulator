import 'package:flutter/material.dart';

import 'core/control_signal.dart';
import 'ui/editor/code_editor.dart';
import 'ui/modules/alu_module.dart';
import 'ui/modules/bus_module.dart';
import 'ui/modules/clock_module.dart';
import 'ui/modules/control_unit_module.dart';
import 'ui/modules/control_word_module.dart';
import 'ui/modules/flags_module.dart';
import 'ui/modules/instruction_register_module.dart';
import 'ui/modules/output_module.dart';
import 'ui/modules/program_counter_module.dart';
import 'ui/modules/ram_module.dart';
import 'ui/modules/register_module.dart';
import 'ui/painters/grid_painter.dart';

class CPULayout extends StatelessWidget {
  final String? initialProgram;

  // Bus
  final int bus;
  final bool busActive;

  // Registers
  final int registerA;
  final int registerB;
  final int instructionRegister;
  final int memoryAddressRegister;
  final int programCounter;
  final int outputRegister;
  final int sumRegister;

  // Flags
  final bool carryFlag;
  final bool zeroFlag;

  // Control signals
  final bool clockHigh;
  final bool haltFlag;
  final bool memoryIn;
  final bool ramIn;
  final bool ramOut;
  final bool instructionOut;
  final bool instructionIn;
  final bool aRegisterIn;
  final bool aRegisterOut;
  final bool bRegisterIn;
  final bool sumOut;
  final bool subtract;
  final bool outputIn;
  final bool counterEnable;
  final bool counterOut;
  final bool jump;
  final bool flagsIn;

  // RAM
  final List<int> ram;

  // Clock
  final bool isRunning;
  final double clockSpeed;
  final bool manualMode;

  // Animation
  final Animation<double> busAnimation;

  // Microcode step
  final int microStep;

  // Control word
  final int controlWord;

  // Clock
  final void Function() onClockToggle;
  final void Function() onClockSingleStep;
  final void Function(double speed) onClockSpeedChanged;
  final void Function(bool manual) onClockManualModeChanged;

  // RAM
  final void Function(int address, int value) onRamEdit;

  // CPU
  final void Function() onReset;
  final void Function() onClearControlSignals;
  final void Function(List<int> program) onLoadProgram;

  const CPULayout({
    super.key,
    this.initialProgram,

    // Bus
    required this.bus,
    required this.busActive,

    // Registers
    required this.registerA,
    required this.registerB,
    required this.instructionRegister,
    required this.memoryAddressRegister,
    required this.programCounter,
    required this.outputRegister,
    required this.sumRegister,

    // Flags
    required this.carryFlag,
    required this.zeroFlag,

    // Control signals
    required this.clockHigh,
    required this.haltFlag,
    required this.memoryIn,
    required this.ramIn,
    required this.ramOut,
    required this.instructionOut,
    required this.instructionIn,
    required this.aRegisterIn,
    required this.aRegisterOut,
    required this.bRegisterIn,
    required this.sumOut,
    required this.subtract,
    required this.outputIn,
    required this.counterEnable,
    required this.counterOut,
    required this.jump,
    required this.flagsIn,

    // RAM
    required this.ram,

    // Clock
    required this.isRunning,
    required this.clockSpeed,
    required this.manualMode,

    // Animation
    required this.busAnimation,

    // Microcode step
    required this.microStep,

    // Control word
    required this.controlWord,

    // Clock
    required this.onClockToggle,
    required this.onClockSingleStep,
    required this.onClockSpeedChanged,
    required this.onClockManualModeChanged,

    // RAM
    required this.onRamEdit,

    // CPU
    required this.onReset,
    required this.onClearControlSignals,
    required this.onLoadProgram,
  });

  @override
  Widget build(BuildContext context) {
    const spaceBetweenModules = 14.0;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            size: Size(
              MediaQuery.sizeOf(context).width,
              MediaQuery.sizeOf(context).height,
            ),
            painter: GridPainter(),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // const Text(
                //   '8-bit CPU Visual Simulator',
                //   style: TextStyle(
                //     color: Colors.white60,
                //     fontSize: 26,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        RegisterModule(
                          name: 'MEMORY ADDRESS REGISTER',
                          value: memoryAddressRegister,
                          busValue: bus,
                          isInput: memoryIn,
                          isOutput: false,
                          color: Colors.red,
                          isConnectedToBus: true,
                          bitWidth: 4,
                        ),
                        const SizedBox(height: spaceBetweenModules),
                        RAMModule(
                          ram: ram,
                          address: memoryAddressRegister,
                          busValue: bus,
                          isInput: ramIn,
                          isOutput: ramOut,
                          onEdit: onRamEdit,
                        ),
                      ],
                    ),
                    const SizedBox(width: spaceBetweenModules),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProgramCounterModule(
                          value: programCounter,
                          busValue: bus,
                          isOutput: counterOut,
                          isCount: counterEnable,
                          isJump: jump,
                        ),
                        const SizedBox(height: spaceBetweenModules),
                        ClockModule(
                          clockHigh: clockHigh,
                          isRunning: isRunning,
                          speed: clockSpeed,
                          manualMode: manualMode,
                          onToggle: onClockToggle,
                          onStep: onClockSingleStep,
                          onReset: onReset,
                          onSpeedChanged: onClockSpeedChanged,
                          onModeChanged: onClockManualModeChanged,
                        ),
                        const SizedBox(height: spaceBetweenModules),
                        InstructionRegisterModule(
                          value: instructionRegister,
                          busValue: bus,
                          isInput: instructionIn,
                          isOutput: instructionOut,
                        ),
                        const SizedBox(height: spaceBetweenModules),
                        BusModule(
                          bus: bus,
                          busActive: busActive,
                          animation: busAnimation,
                        ),
                        const SizedBox(height: spaceBetweenModules),
                        ALUModule(
                          registerA: registerA,
                          registerB: registerB,
                          sumRegister: sumRegister,
                          subtract: subtract,
                          carryFlag: carryFlag,
                          zeroFlag: zeroFlag,
                          isOutput: sumOut,
                          isFlagsIn: flagsIn,
                        ),
                      ],
                    ),
                    const SizedBox(width: spaceBetweenModules),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ControlWordModule(controlWord: controlWord),
                        const SizedBox(height: spaceBetweenModules),
                        ControlUnitModule(
                          instruction: instructionRegister,
                          step: microStep,
                          controlWord: controlWord,
                          signals: {
                            ControlSignal.hlt: haltFlag,
                            ControlSignal.mi: memoryIn,
                            ControlSignal.ri: ramIn,
                            ControlSignal.ro: ramOut,
                            ControlSignal.io: instructionOut,
                            ControlSignal.ii: instructionIn,
                            ControlSignal.ai: aRegisterIn,
                            ControlSignal.ao: aRegisterOut,
                            ControlSignal.bi: bRegisterIn,
                            ControlSignal.so: sumOut,
                            ControlSignal.su: subtract,
                            ControlSignal.oi: outputIn,
                            ControlSignal.ce: counterEnable,
                            ControlSignal.co: counterOut,
                            ControlSignal.j: jump,
                            ControlSignal.fi: flagsIn,
                          },
                        ),
                        const SizedBox(height: spaceBetweenModules),
                        Row(
                          children: [
                            OutputModule(
                              value: outputRegister,
                              busValue: bus,
                              isInput: outputIn,
                            ),
                            const SizedBox(width: spaceBetweenModules),
                            FlagsModule(
                              carryFlag: carryFlag,
                              zeroFlag: zeroFlag,
                              isInput: flagsIn,
                            ),
                          ],
                        ),
                        const SizedBox(height: spaceBetweenModules),
                        RegisterModule(
                          name: 'A Register',
                          value: registerA,
                          busValue: bus,
                          isInput: aRegisterIn,
                          isOutput: aRegisterOut,
                          color: Colors.red,
                          isConnectedToBus: true,
                        ),
                        const SizedBox(height: spaceBetweenModules),
                        RegisterModule(
                          name: 'B Register',
                          value: registerB,
                          busValue: bus,
                          isInput: bRegisterIn,
                          isOutput: false,
                          color: Colors.red,
                          isConnectedToBus: true,
                        ),
                      ],
                    ),
                    const SizedBox(width: spaceBetweenModules),
                    ProgramEditor(
                      initialProgram: initialProgram,
                      onAssemble: (program, hasError) {
                        if (!hasError && program.isNotEmpty) {
                          onReset();
                          onClearControlSignals();
                          onLoadProgram(program);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

# 8-bit CPU Simulator

An interactive visual simulator of a simple 8-bit CPU architecture, built entirely with Flutter. This educational tool helps you understand how computers work at the fundamental level by visualizing CPU operations, registers, memory, and the flow of data through the system.

Live Demo: [cpu.devmuaz.com](https://cpu.devmuaz.com)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [CPU Architecture](#cpu-architecture)
- [Instruction Set](#instruction-set)
- [Getting Started](#getting-started)
- [Writing Assembly Programs](#writing-assembly-programs)
- [Example Programs](#example-programs)
- [Understanding the Interface](#understanding-the-interface)
- [Technical Details](#technical-details)
- [Contributing](#contributing)
- [License](#license)

## Overview

This simulator implements a simplified yet fully functional 8-bit CPU inspired by classic educational architectures. It provides a visual, step-by-step execution environment where you can write assembly programs, load them into memory, and watch how the CPU processes each instruction.

The simulator is perfect for:

- Computer science students learning about CPU architecture
- Educators teaching computer organization
- Hobbyists interested in low-level computing
- Anyone curious about how processors work

## Features

- **Visual CPU Simulation**: Watch data flow through the bus, registers update in real-time, and control signals activate during execution
- **Built-in Assembler**: Write programs in assembly language and automatically convert them to machine code
- **Step-by-Step Execution**: Execute programs one clock cycle at a time or run continuously at variable speeds
- **16 Bytes of RAM**: Fully editable memory with 4-bit addressing
- **Multiple Registers**: A, B, Instruction Register, Memory Address Register, Program Counter, Output, and Sum registers
- **Status Flags**: Carry and Zero flags for conditional operations
- **Pre-loaded Programs**: Includes example programs like Fibonacci sequence, counters, and arithmetic operations
- **Interactive Interface**: Dark-themed, modern UI built with Flutter
- **Cross-Platform**: Runs on Web, Windows, macOS, Linux, iOS, and Android

## CPU Architecture

### Registers

| Register | Size  | Description                                         |
| -------- | ----- | --------------------------------------------------- |
| **A**    | 8-bit | General-purpose accumulator register                |
| **B**    | 8-bit | General-purpose register for arithmetic operations  |
| **PC**   | 4-bit | Program Counter (0-15)                              |
| **MAR**  | 4-bit | Memory Address Register                             |
| **IR**   | 8-bit | Instruction Register (4-bit opcode + 4-bit operand) |
| **OUT**  | 8-bit | Output Register for displaying results              |
| **SUM**  | 8-bit | ALU result register                                 |

### Flags

- **Carry Flag (CF)**: Set when arithmetic operations produce a carry or borrow
- **Zero Flag (ZF)**: Set when the result of an operation is zero

### Memory

- **RAM**: 16 bytes (addresses 0x0 to 0xF)
- Each memory location stores an 8-bit value (0-255)

### Bus

- **8-bit data bus**: Transfers data between components
- Visual indication when active during instruction execution

## Instruction Set

The CPU supports 11 instructions with a simple format: 4-bit opcode and 4-bit operand.

| Mnemonic | Opcode | Format     | Description                                   |
| -------- | ------ | ---------- | --------------------------------------------- |
| **NOP**  | 0x0    | `NOP`      | No operation                                  |
| **LDA**  | 0x1    | `LDA addr` | Load value from RAM address into register A   |
| **ADD**  | 0x2    | `ADD addr` | Add value at RAM address to register A        |
| **SUB**  | 0x3    | `SUB addr` | Subtract value at RAM address from register A |
| **STA**  | 0x4    | `STA addr` | Store register A value to RAM address         |
| **LDI**  | 0x5    | `LDI #val` | Load immediate value into register A          |
| **JMP**  | 0x6    | `JMP addr` | Jump to address                               |
| **JC**   | 0x7    | `JC addr`  | Jump to address if Carry flag is set          |
| **JZ**   | 0x8    | `JZ addr`  | Jump to address if Zero flag is set           |
| **OUT**  | 0xE    | `OUT`      | Copy register A to output register            |
| **HLT**  | 0xF    | `HLT`      | Halt program execution                        |

## Getting Started

### Prerequisites

- Flutter SDK (version 3.9.0 or higher)
- A code editor (VS Code, Android Studio, or any text editor)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/devmuaz/flutter_8_bit_cpu_simulator.git
cd flutter_8_bit_cpu_simulator
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the application:

```bash
flutter run
```

### System Requirements

The simulator requires a minimum screen size of 1400px width and 900px height for optimal viewing. Please run in full-screen mode for the best experience.

## Writing Assembly Programs

### Basic Syntax

- One instruction per line
- Comments start with semicolon (`;`)
- Addresses and values can be in decimal or hexadecimal (prefix with `0x`)
- Immediate values are prefixed with `#`

### Example Program

```assembly
; Simple counter from 0 to 255
LDI #0       ; Initialize counter to 0
STA 0xF      ; Store in RAM at address 15
LDI #1       ; Load increment value
STA 0xE      ; Store increment at address 14
LDA 0xF      ; Load current counter value
OUT          ; Display current value
ADD 0xE      ; Add 1 to counter
STA 0xF      ; Store new value
JZ 0xA       ; If zero, jump to halt
JMP 0x4      ; Otherwise, loop back
HLT          ; Program end
```

## Understanding the Interface

### Control Panel

- **Clock Toggle**: Start/stop program execution
- **Single Step**: Execute one clock cycle at a time
- **Clock Speed**: Adjust execution speed (1x to 50x)
- **Reset**: Reset all registers and reload the program
- **Manual Mode**: Switch between automatic and manual stepping

### Visual Components

1. **Bus Visualization**: Shows when data is being transferred and what value is on the bus
2. **Register Displays**: Real-time values of all registers in binary, hexadecimal, and decimal
3. **Memory View**: Complete view of all 16 RAM locations
4. **Control Signals**: Visual indicators showing which control signals are active
5. **Flags Display**: Current state of Carry and Zero flags
6. **Output Display**: Shows the current output value
7. **Assembly Editor**: Write and edit assembly programs
8. **Machine Code View**: See the assembled machine code

## Technical Details

### Fetch-Execute Cycle

The CPU follows a standard fetch-execute cycle:

1. **T0 (Fetch Address)**:

   - PC → MAR (Counter Out, Memory In)
   - Load program counter into memory address register

2. **T1 (Fetch Instruction)**:

   - RAM[MAR] → IR (RAM Out, Instruction In)
   - PC++ (Counter Enable)
   - Load instruction from memory, increment program counter

3. **T2+ (Execute)**:
   - Varies by instruction
   - Can take 1-3 additional clock cycles

### Control Signals

The CPU uses the following control signals to orchestrate data flow:

- **MI**: Memory Address In
- **RI**: RAM In
- **RO**: RAM Out
- **IO**: Instruction Out (operand)
- **II**: Instruction In
- **AI**: A Register In
- **AO**: A Register Out
- **BI**: B Register In
- **SO**: Sum Out (ALU output)
- **SU**: Subtract (ALU mode)
- **OI**: Output In
- **CE**: Counter Enable (PC++)
- **CO**: Counter Out
- **J**: Jump (load PC)
- **FI**: Flags In

### Microcode

Each instruction is broken down into microcode steps. For example, the ADD instruction:

```
ADD addr:
  T0: CO|MI       ; PC to MAR
  T1: RO|II|CE    ; RAM to IR, increment PC
  T2: IO|MI       ; Operand to MAR
  T3: RO|BI       ; RAM to B register
  T4: SO|AI|FI    ; A+B to A, update flags
```

## Contributing

Contributions are welcome! Whether it's bug reports, feature requests, or code contributions, please feel free to get involved.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open source and available under the MIT License.

---

Built with Flutter by [devmuaz](https://github.com/devmuaz)

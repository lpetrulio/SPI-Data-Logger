# SPI High-Speed Data Logger – Arty A7-100T FPGA  

## 📌 Project Overview  
This FPGA-based **SPI High-Speed Data Logger** captures real-time temperature data from a **thermocouple sensor** using SPI communication and writes it to an **SD card** for later analysis. The system is optimized for **low latency, high-speed data acquisition, and efficient storage**.

## 🎯 Features  
- **SPI Interface**: Communicates with a thermocouple sensor (e.g., MAX31855) for temperature readings.  
- **High-Speed Data Logging**: Captures and stores temperature data in real time.  
- **SD Card Storage**: Writes logged data to an SD card 
- **Efficient Memory Management**: Uses **FIFO buffering and pipelining** to handle continuous data flow.  
- **UART Debug Interface**: Displays real-time temperature readings via a UART terminal.  
- **Optimized for Timing & Performance**: Implements **clock domain crossing (CDC), timing closure, and latency optimization**.  

---

## 🛠️ Hardware & Tools  
### **🔧 Hardware Components**
- **FPGA Board**: Arty A7-100T  
- **Thermocouple Sensor**: MAX31855 (SPI-based)  
- **SD Card Module**: SPI-compatible SD card breakout  
- **Jumper Wires**: Female-to-male for sensor & SD card connection  

### **📦 Software & Toolchain**
- **Vivado** – FPGA design & simulation  
- **Verilog** – HDL for hardware description  
- **UART Terminal** – Serial data visualization  
- **SD Card FAT32 File System** (if implemented)  



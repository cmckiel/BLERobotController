//
//  BLEModel.swift
//  BLERobotController
//
//  Created by Guest on 4/18/21.
//

import Foundation
import CoreBluetooth

struct BLEParameters {
    static let robotService = CBUUID(string: "FFE0")
    static let robotCharacteristic = CBUUID(string: "FFE1")
}

protocol BLEModelDelegate {
    
}

class BLEModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var centralManager: CBCentralManager!
    private var robot: CBPeripheral?
    private var robotCharacteristic: CBCharacteristic?
    
    public  func initCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Initialized CentralManager...")
    }
    
    //BLE Workflow: Scan, Connect, Discover Services, Discover Characteristics,
    //Read/Write to Characteristics, Disconnect.
    private func scan() {
        centralManager.scanForPeripherals(withServices: [BLEParameters.robotService], options: nil)
        print("Scanning...")
    }
    
    private func connect(_ peripheral: CBPeripheral) {
        print("Connecting...")
        centralManager.connect(peripheral, options: nil)
    }
    
    private func discoverServices(_ peripheral: CBPeripheral) {
        print("Discovering Services...")
        peripheral.discoverServices([BLEParameters.robotService])
    }
    
    private func discoverCharacteristics(_ peripheral: CBPeripheral) {
        print("Discovering Characteristics...")
        guard let services = peripheral.services else { return }
        
        for service in services {
            if service.uuid == BLEParameters.robotService {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    private func assignCharacteristic(_ service: CBService) {
        print("Assigning Characteristic...")
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.uuid == BLEParameters.robotCharacteristic {
                robotCharacteristic = characteristic
            }
        }
        print("Assigned.")
        centralManager.stopScan()
    }
    
    // MARK -  CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            scan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered Peripheral.")
        robot = peripheral
        connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected.")
        peripheral.delegate = self
        discoverServices(peripheral)
    }
    
    //MARK - CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered Services.")
        discoverCharacteristics(peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Discovered Characteristics.")
        assignCharacteristic(service)
    }
}
